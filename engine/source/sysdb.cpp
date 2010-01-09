
#include <set>

#include "glib.h"
#include "glib/gstdio.h"

#include "sysdb.h"
#include "util.h"
#include "db.h"

//-----------------------------------------------------------------------------

static const char * schema_create=
    
    "create table generic( key TEXT PRIMARY KEY NOT NULL , value TEXT );"
    "create table profiles( id INTEGER PRIMARY KEY AUTOINCREMENT,"
    "                       name TEXT,pin TEXT);"
;

//-----------------------------------------------------------------------------

SystemDatabase * SystemDatabase::open(const char * path)
{
    // Create the in-memory database
    
    SQLite::DB db(":memory:");
    
    // If that fails, there is not much we can do - a warning will have been
    // printed out already
    
    if (!db.ok())
        return NULL;
    
    // Construct the filename for the on-disk db
    
    gchar * filename=g_build_filename(path,"system.db",NULL);
    Util::GFreeLater free_filename(filename);
    
    bool create=true;
    
    if (!g_file_test(filename,G_FILE_TEST_EXISTS))
    {
        g_debug("SYSTEM DATABASE DOES NOT EXIST");    
    }
    
    // Try to open the on-disk database in read-only mode
    
    else
    {
        SQLite::DB source(filename,SQLITE_OPEN_READONLY);
        
        if (!source.ok())
        {
            g_warning("FAILED TO OPEN EXISTING SYSTEM DATABASE");
        }
        else
        {
            // Perform an integrity check on it
            
            SQLite::Statement integrity(source,"pragma integrity_check;");
            integrity.step();
            
            if (!integrity.ok() || integrity.get_string(0)!="ok")
            {
                g_warning("FAILED INTEGRITY CHECK ON EXISTING SYSTEM DATABASE");    
            }
            else
            {
                // Backup the existing database into the in-memory database
                
                if (!SQLite::Backup(db,source).ok())
                {
                    g_warning("FAILED TO RESTORE EXISTING SYSTEM DATABASE");
                }
                else
                {
                    create = false;
                    g_debug("SYSTEM DATABASE LOADED");
                }
            }
        }
    }
    
    // If anything failed above, we (re)create the database schema. If this
    // fails, there is not much we can do
    
    if (create)
    {
        db.exec(schema_create);
        
        if (!db.ok())
        {
            g_warning("FAILED TO CREATE INITIAL SYSTEM DATABASE SCHEMA");
            return NULL;
        }
        
        g_debug("SYSTEM DATABASE CREATED");
    }
    
    // Now, we create an instance of a system database - which will steal the
    // underlying sqlite db from our local instance...we transfer ownership of it.
    
    SystemDatabase * result=new SystemDatabase(db,path);
    
    // If we fail to populate the database, we should not continue since we may
    // have inconsistent data. Plus, if this fails, it is very likely that
    // future stuff will also fail.
    
    if (!result->insert_initial_data())
    {
        g_warning("FAILED TO POPULATE SYSTEM DATABASE");
        
        // We reset dirty so that this bad database doesn't get flushed when
        // we delete it
        
        result->dirty=false;
        delete result;
        return NULL;
    }
    
    // Everything is OK
    
    return result;    
}

SystemDatabase::SystemDatabase(SQLite::DB & d,const char * p)
:
    db(d),
    path(p),
    dirty(false)
{
}

SystemDatabase::~SystemDatabase()
{
    flush();
}

bool SystemDatabase::flush()
{
    if (!dirty)
        return true;
    
    gchar * backup_filename=g_build_filename(path.c_str(),"system.db.XXXXXX",NULL);
    Util::GFreeLater free_backup_filename(backup_filename);
    
    // Make a temporary file to backup to
    
    gint fd=g_mkstemp(backup_filename);
    
    if (fd==-1)
    {
        g_warning("FAILED TO CREATE TEMPORARY FILE FOR SYSTEM DATABASE");
        return false;
    }
        
    close(fd);
    
    SQLite::DB dest(backup_filename);
    
    if (!dest.ok())
    {
        g_warning("FAILED TO OPEN TEMPORARY BACKUP FOR SYSTEM DATABASE");
        g_unlink(backup_filename);
        return false;
    }
    
    if (!SQLite::Backup(dest,db).ok())
    {
        g_warning("FAILED TO BACKUP SYSTEM DATABASE");
        g_unlink(backup_filename);
        return false;
    }
    
    // Now move the backup file
    
    gchar * target_filename=g_build_filename(path.c_str(),"system.db",NULL);
    Util::GFreeLater free_target_filename(target_filename);
    
    if (g_rename(backup_filename,target_filename)!=0)
    {
        g_warning("FAILED TO MOVE BACKUP SYSTEM DATABASE");
        g_unlink(backup_filename);
        return false;
    }
    
    g_debug("SYSTEM DATABASE FLUSHED");
    dirty=false;
    return true;    
}

bool SystemDatabase::insert_initial_data()
{
    // Collect a list of existing profile ids
    
    std::set<int> ids;

    {
        SQLite::Statement select(db,"select id from profiles;");

        while(select.ok() && select.step()==SQLITE_ROW)
            ids.insert(select.get_int(0));
            
        if (!select.ok())
            return false;
    }
    
    // There are no profiles, we must create one

    if (ids.size()==0)
    {
        int id=create_profile(TP_DB_FIRST_PROFILE_NAME,"");

        if (!id)
            return false;
        
        if (!set(TP_DB_CURRENT_PROFILE_ID,id))
            return false;        
    }
    
    // There are profiles, lets make sure the current profile id is set to one
    // of them
    
    else
    {
        int id=get_int(TP_DB_CURRENT_PROFILE_ID,-1);
                
        // There is no current profile id set, or the one that is set is not
        // in the list of ids
        
        if (id==-1 || ids.find(id)==ids.end())
        {
            if (!set(TP_DB_CURRENT_PROFILE_ID,id))
                return false;
        }
    }
    
    return true;
}

bool SystemDatabase::set(const char * key,int value)
{
    SQLite::Statement insert(db,"insert or replace into generic (key,value) values (?1,?2);");
    insert.bind(1,key);
    insert.bind(2,value);
    insert.step();
    dirty=true;
    return insert.ok();
}

bool SystemDatabase::set(const char * key,const char * value)
{
    SQLite::Statement insert(db,"insert or replace into generic (key,value) values (?1,?2);");
    insert.bind(1,key);
    insert.bind(2,value);
    insert.step();
    dirty=true;
    return insert.ok();
}

bool SystemDatabase::set(const char * key,const String & value)
{
    SQLite::Statement insert(db,"insert or replace into generic (key,value) values (?1,?2);");
    insert.bind(1,key);
    insert.bind(2,value);
    insert.step();
    dirty=true;
    return insert.ok();
}

String SystemDatabase::get_string(const char * key,const char * def)
{
    SQLite::Statement select(db,"select value from generic where key=?1;");
    select.bind(1,key);
    if (select.ok() && select.step()==SQLITE_ROW)
        return select.get_string(0);
    return String(def);
}

int SystemDatabase::get_int(const char * key,int def)
{
    SQLite::Statement select(db,"select value from generic where key=?1;");
    select.bind(1,key);
    if (select.ok() && select.step()==SQLITE_ROW)
        return select.get_int(0);
    return def;    
}

int SystemDatabase::create_profile(const String & name,const String & pin)
{
    SQLite::Statement insert(db,"insert into profiles (id,name,pin) values (NULL,?1,?2);");
    insert.bind(1,name);
    insert.bind(2,pin);
    insert.step();
    dirty=true;
    return db.last_insert_rowid();
}

SystemDatabase::Profile SystemDatabase::get_current_profile()
{
    SystemDatabase::Profile result;
    
    SQLite::Statement select(db,"select p.id,p.name,p.pin from generic g,profiles p where g.key=?1 and g.value=p.id;");
    select.bind(1,TP_DB_CURRENT_PROFILE_ID);
    if (select.ok() && select.step()==SQLITE_ROW)
    {
        result.id=select.get_int(0);
        result.name=select.get_string(1);
        result.pin=select.get_string(2);
    }
    return result;
}

SystemDatabase::Profile SystemDatabase::get_profile(int id)
{
    SystemDatabase::Profile result;
    
    SQLite::Statement select(db,"select name,pin from profiles where id=?1;");
    select.bind(1,id);
    if (select.ok() && select.step()==SQLITE_ROW)
    {
        result.id=id;
        result.name=select.get_string(0);
        result.pin=select.get_string(1);
    }
    return result;    
}
