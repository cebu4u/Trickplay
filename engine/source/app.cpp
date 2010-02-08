
#include "app.h"
#include "sysdb.h"
#include "util.h"
#include "context.h"
#include "network.h"

//-----------------------------------------------------------------------------
#define APP_METADATA_FILENAME   "app"
#define APP_TABLE_NAME          "app"
#define APP_FIELD_ID            "id"
#define APP_FIELD_NAME          "name"
#define APP_FIELD_DESCRIPTION   "description"
#define APP_FIELD_AUTHOR        "author"
#define APP_FIELD_COPYRIGHT     "copyright"
#define APP_FIELD_RELEASE       "release"
#define APP_FIELD_VERSION       "version"

//-----------------------------------------------------------------------------
// Bindings
//-----------------------------------------------------------------------------

extern void luaopen_clutter(lua_State*L);
extern void luaopen_timer(lua_State*L);
extern void luaopen_url_request(lua_State*L);
extern void luaopen_storage(lua_State*L);
extern void luaopen_globals(lua_State*L);
extern void luaopen_app(lua_State*L);
extern void luaopen_system(lua_State*L);
extern void luaopen_settings(lua_State*L);
extern void luaopen_profile(lua_State*L);
extern void luaopen_xml(lua_State*L);
extern void luaopen_controllers_module(lua_State*L);
extern void luaopen_mediaplayer_module(lua_State*L);

extern void luaopen_restricted(lua_State*L);
extern void luaopen_apps(lua_State*L);

// This one comes from keys.cpp and is not generated by lb

extern void luaopen_keys(lua_State*L);

//-----------------------------------------------------------------------------

bool App::load_metadata(const char * app_path,App::Metadata & md)
{
    g_assert(app_path);
    
    // To clear the one passed in
    
    md=Metadata();
    
    md.path=app_path;
    
    // Open a state with no libraries - not even the base one
    
    lua_State * L=lua_open();
    
    g_assert(L);
    
    try
    {
	// Build the path to the metadata file and test that it exists
	
	gchar * path = g_build_filename(app_path,APP_METADATA_FILENAME,NULL);
	
	Util::GFreeLater free_path(path);
	
	if (!g_file_test(path,G_FILE_TEST_IS_REGULAR))
	    throw String("App metadata file does not exist");
	
	// Now, run it with Lua
	
	int result = luaL_dofile(L,path);
	
	// Check that it ran OK
	
	if(result)
	    throw String("Failed to parse app metadata : ") + lua_tostring(L,-1);
	    
	// Look for the 'app' global
	
	lua_getglobal(L,APP_TABLE_NAME);	
	if (!lua_istable(L,-1))
	    throw String("Missing or invalid app table");
	    
	// Look for the id
	lua_getfield(L,-1,APP_FIELD_ID);
	if (lua_type(L,-1)!=LUA_TSTRING)
	    throw String("Missing or invalid app id");
	    
	// Validate the id
	
	size_t len;
	const char * s=lua_tolstring(L,-1,&len);
	
	if (len>64)
	    throw String("App id is too long");
	
	static const char * valid_id_characters = "_-.";
	
	for(const char * c=s;*c;++c)
	{
	    if (!g_ascii_isalnum(*c))
	    {
		if(!strchr(valid_id_characters,*c))
		    throw String("App id contains invalid characters");
	    }
	}
	
	if (strstr(s,".."))
	    throw String("App id contains two dots");

	if (strstr(s,"--"))
	    throw String("App id contains two dashes");
	    
	if (strstr(s,"__"))
	    throw String("App id contains two underscores");
	    
	
	// Store it
	md.id=s;
	lua_pop(L,1);

	// Look for the other fields
	lua_getfield(L,-1,APP_FIELD_NAME);
	if (lua_type(L,-1)!=LUA_TSTRING)
	    throw String("Missing or invalid app name");
	md.name=lua_tostring(L,-1);
	lua_pop(L,1);
	
	lua_getfield(L,-1,APP_FIELD_RELEASE);
	if (lua_tointeger(L,-1)<=0)
	    throw String("Missing or invalid app release, it must be a number greater than 0");
	md.release=lua_tointeger(L,-1);
	lua_pop(L,1);
	
	lua_getfield(L,-1,APP_FIELD_VERSION);
	if (lua_type(L,-1)!=LUA_TSTRING)
	    throw String("Missing or invalid app version");	
	md.version=lua_tostring(L,-1);
	lua_pop(L,1);
	
	lua_getfield(L,-1,APP_FIELD_DESCRIPTION);
	if(lua_isstring(L,-1))
	    md.description=lua_tostring(L,-1);
	lua_pop(L,1);
	
	lua_getfield(L,-1,APP_FIELD_AUTHOR);
	if(lua_isstring(L,-1))
	    md.author=lua_tostring(L,-1);
	lua_pop(L,1);
	
	lua_getfield(L,-1,APP_FIELD_COPYRIGHT);
	if(lua_isstring(L,-1))
	    md.copyright=lua_tostring(L,-1);
	lua_pop(L,1);
	
	lua_close(L);
	return true;	
    }
    catch( const String & e)
    {
	lua_close(L);
	g_warning("Failed to load app metadata from '%s' : %s" , app_path , e.c_str() );
	return false;	
    }
}



//-----------------------------------------------------------------------------

void App::scan_app_sources(SystemDatabase * sysdb,const char * app_sources,const char * installed_apps_root,bool force)
{
    // If the scan is not forced and we already have apps in the database, bail
    
    if (!force && sysdb->get_app_count()>0)
	return;
    
    // Otherwise, let's do the scan
    
    if (!app_sources)
    {
	g_warning("NO APP SOURCES TO SCAN");
	return;
    }
    
    std::map< String,std::list<Metadata> > apps;
    
    //.........................................................................
    // First scan app sources
    
    gchar ** paths=g_strsplit(app_sources,";",0);
    
    for(gchar**p=paths;*p;++p)
    {
	gchar * path=g_strstrip(*p);
	
	GDir * dir=g_dir_open(path,0,NULL);
	
	if (!dir)
	{
	    g_warning("FAILED TO SCAN APP SOURCE %s",path);
	}
	else
	{
	    while(const gchar * base=g_dir_read_name(dir))
	    {
		gchar * md_file_name=g_build_filename(path,base,"app",NULL);		
		Util::GFreeLater free_md_file_name(md_file_name);
		
		if (!g_file_test(md_file_name,G_FILE_TEST_IS_REGULAR))
		    continue;
		
		gchar * app_path=g_build_filename(path,base,NULL);
		Util::GFreeLater free_app_path(app_path);
		
		Metadata md;
		
		if (load_metadata(app_path,md))
		{
		    g_info("SCAN FOUND %s (%s/%d) @ %s",
			    md.id.c_str(),
			    md.version.c_str(),
			    md.release,
			    app_path);
		
		    apps[md.id].push_back(md);    
		}
	    }
	    
	    g_dir_close(dir);
	}
    }
    
    g_strfreev(paths);
    
    //.........................................................................
    // Now scan the data directory - where apps may be installed
        
    if (g_file_test(installed_apps_root,G_FILE_TEST_EXISTS))
    {
	GDir * dir=g_dir_open(installed_apps_root,0,NULL);
	
	if (!dir)
	{
	    g_warning("FAILED TO SCAN APP SOURCE %s",installed_apps_root);
	}
	else
	{
	    while(const gchar * base=g_dir_read_name(dir))
	    {
		gchar * app_path=g_build_filename(installed_apps_root,base,"source",NULL);
		Util::GFreeLater free_app_path(app_path);
		
		gchar * md_file_name=g_build_filename(app_path,"app",NULL);
		Util::GFreeLater free_md_file_name(md_file_name);
		
		if (!g_file_test(md_file_name,G_FILE_TEST_IS_REGULAR))
		    continue;
		
		Metadata md;
		
		if (load_metadata(app_path,md))
		{
		    g_info("SCAN FOUND %s (%s/%d) @ %s",
			    md.id.c_str(),
			    md.version.c_str(),
			    md.release,
			    app_path);
		    
		    apps[md.id].push_back(md);    
		}
	    }
	    
	    g_dir_close(dir);
	}
    }
    
    if (!apps.empty())
    {
	//.........................................................................
	// Now we have a map of app ids - each entry has a list of versions found
	
	// We delete all the apps from the database
	
	sysdb->delete_all_apps();
	
	std::map< String,std::list<Metadata> >::iterator it=apps.begin();
	
	for(;it!=apps.end();++it)
	{
	    if (it->second.size()>1)
	    {    
		// We move the list to a new list and clear the original
		
		const std::list<Metadata> versions(it->second);
		
		it->second.clear();
		
		// Now, we point an iterator to the first one in the list. If one of the
		// others has a greater release number, we point the iterator at it.
		//
		// When we are done, this iterator will point to the app metadata
		// with the greatest release number.
		
		std::list<Metadata>::const_iterator latest=versions.begin();
		
		for(std::list<Metadata>::const_iterator vit=++(versions.begin());vit!=versions.end();++vit)
		{
		    if (vit->release > latest->release)
			latest=vit;
		}
		
		// Finally, we put the one pointed to by the iterator back in the map's list
		
		it->second.push_back(*latest);
	    }
	    
	    const Metadata & md=it->second.front();
	    
	    sysdb->insert_app(md.id,md.path,md.release,md.version);
	    
	    g_info("ADDING %s (%s/%d) @ %s",
		    md.id.c_str(),
		    md.version.c_str(),
		    md.release,
		    md.path.c_str() );
	}
    }
}




//-----------------------------------------------------------------------------

App * App::load(TPContext * context,const App::Metadata & md)
{
    g_assert(context);
    
    // Get the data directory ready
    
    gchar * id_hash=g_compute_checksum_for_string(G_CHECKSUM_SHA1,md.id.c_str(),-1);
    
    Util::GFreeLater free_id_hash(id_hash);    
    
    gchar * app_data_path=g_build_filename(context->get(TP_DATA_PATH),"apps",id_hash,NULL);
    
    Util::GFreeLater free_app_data_path(app_data_path);
    
    if (!g_file_test(app_data_path,G_FILE_TEST_EXISTS))
    {
	if (g_mkdir_with_parents(app_data_path,0700)!=0)
	{
	    g_warning("FAILED TO CREATE APP DATA PATH '%s'",app_data_path);
	    return NULL;
	}
    }
    
    return new App(context,md,app_data_path);            
}

//-----------------------------------------------------------------------------

App::App(TPContext * c,const App::Metadata & md,const char * dp)
:
    context(c),
    metadata(md),
    data_path(dp),
    L(NULL),
    cookie_jar(NULL)
{
        
    // Create the user agent
    
    user_agent=Network::get_user_agent(
        context->get(TP_SYSTEM_LANGUAGE),
        context->get(TP_SYSTEM_COUNTRY),
        md.id.c_str(),
        md.release,
        context->get(TP_SYSTEM_NAME),
        context->get(TP_SYSTEM_VERSION));
    
    // Register to get all notifications
    
    context->add_notification_handler("*",forward_notification_handler,this);
    
    // Register for profile switch
    
    context->add_notification_handler(TP_NOTIFICATION_PROFILE_CHANGE,profile_notification_handler,this);
    
    // Create the Lua state
    
    L=lua_open();
    g_assert(L);
    
    // Put a pointer to the context in Lua so bindings can get to it
    lua_pushstring(L,"tp_context");
    lua_pushlightuserdata(L,context);
    lua_rawset(L,LUA_REGISTRYINDEX);
    
    // Put a pointer to us in Lua so bindings can get to it
    lua_pushstring(L,"tp_app");
    lua_pushlightuserdata(L,this);
    lua_rawset(L,LUA_REGISTRYINDEX);

    // Open standard libs
    luaL_openlibs(L);
    
    // Open our stuff
    luaopen_clutter(L);
    luaopen_timer(L);
    luaopen_url_request(L);
    luaopen_storage(L);
    luaopen_globals(L);
    luaopen_app(L);
    luaopen_system(L);
    luaopen_settings(L);
    luaopen_profile(L);
    luaopen_xml(L);
    luaopen_controllers_module(L);
    luaopen_keys(L);
        
    // TODO
    // This creates a new media player here - which we may not want to do.
    // We probably want to create one earlier and keep it across app loads.
    
    luaopen_mediaplayer_module(L);
    
    // TODO
    // This should not be opened for all apps - only trusted ones. Since we
    // don't have a mechanism for determining trustworthiness yet...
    
    luaopen_restricted(L);
    
    // TODO
    // This one should only be opened for the launcher and the store apps
    
    luaopen_apps(L);    
}


//-----------------------------------------------------------------------------

int App::run()
{
    int result=TP_RUN_OK;
    
    // Run the script
    gchar * main_path=g_build_filename(metadata.path.c_str(),"main.lua",NULL);
    Util::GFreeLater free_main_path(main_path);
        
    if (luaL_dofile(L,main_path))
    {
        g_warning("%s",lua_tostring(L,-1));
	
	result=TP_RUN_APP_ERROR;
    }
        
    return result;    
}

//-----------------------------------------------------------------------------

App::~App()
{
    context->remove_notification_handler("*",forward_notification_handler,this);    
    context->remove_notification_handler(TP_NOTIFICATION_PROFILE_CHANGE,profile_notification_handler,this);    

    release_cookie_jar();
    
    lua_close(L);
}

//-----------------------------------------------------------------------------

App * App::get(lua_State * L)
{
    g_assert(L);
    lua_pushstring(L,"tp_app");
    lua_rawget(L,LUA_REGISTRYINDEX);
    App * result = (App*)lua_touserdata(L,-1);
    lua_pop(L,1);
    g_assert(result);
    return result;    
}

//-----------------------------------------------------------------------------

TPContext * App::get_context()
{
    return context;
}

//-----------------------------------------------------------------------------


String App::get_data_path() const
{
    return data_path;
}

//-----------------------------------------------------------------------------

int App::get_profile_id() const
{
    return context->get_int(PROFILE_ID);
}

//-----------------------------------------------------------------------------

const App::Metadata & App::get_metadata() const
{
    return metadata;
}

//-----------------------------------------------------------------------------

void App::release_cookie_jar()
{
    // Will unref it and set it to NULL
    cookie_jar=Network::cookie_jar_unref(cookie_jar);
}

//-----------------------------------------------------------------------------

Network::CookieJar * App::get_cookie_jar()
{
    if (!cookie_jar)
    {
        gchar * name=g_strdup_printf("cookies-%d.txt",get_profile_id());
        Util::GFreeLater free_name(name);
        
        gchar * file_name=g_build_filename(data_path.c_str(),name,NULL);
        Util::GFreeLater free_file_name(file_name);
        
        cookie_jar=Network::cookie_jar_new(file_name);        
    }
        
    return cookie_jar;
}

//-----------------------------------------------------------------------------

const String & App::get_user_agent() const
{
    return user_agent;
}

//-----------------------------------------------------------------------------
// This one forwards all notifications from the context to our listeners

void App::forward_notification_handler(const char * subject,void * data)
{
    ((App*)data)->notify(subject);
}

//-----------------------------------------------------------------------------
// Notification handler for profile switches

void App::profile_notification_handler(const char * subject,void * data)
{
    ((App*)data)->profile_switch();
}

//-----------------------------------------------------------------------------

void App::profile_switch()
{
    release_cookie_jar();    
}

//-----------------------------------------------------------------------------

lua_State * App::get_lua_state()
{
    return L;
}

//-----------------------------------------------------------------------------

char * App::normalize_path(const gchar * path_or_uri,bool * is_uri,const StringSet & additional_uri_schemes)
{
    bool it_is_a_uri=false;
    
    const char * app_path=metadata.path.c_str();
	
    char * result=NULL;
    
    // First, see if there is a scheme
    
    gchar ** parts=g_strsplit(path_or_uri,":",2);
    
    guint count=g_strv_length(parts);
    
    if (count==0)
    {
	// What do we do? This is clearly not a good path
	
	g_critical("INVALID EMPTY PATH OR URI");
    }
    
    else if (count==1)
    {
	// There is no scheme, so this is a simple path
	
	result=Util::rebase_path(app_path,path_or_uri);
    }
    else
    {
	// There is a scheme
	
	gchar * scheme=parts[0];
	gchar * uri=parts[1];
	
	// The scheme is only one character long - assume it
	// is a windows drive letter
	
	if (strlen(scheme)==1)
	{
	    result=Util::rebase_path(app_path,path_or_uri);
	}
	else
	{
	    // If it is HTTP or HTTPS, we just return the whole thing passed in
	    
	    if (!strcmp(scheme,"http")||!strcmp(scheme,"https"))
	    {
		it_is_a_uri=true;
		    
		result=g_strdup(path_or_uri);
	    }
	    
	    // If it is one of the additional schemes passed in, do the same
	    
	    else if (additional_uri_schemes.find(scheme)!=additional_uri_schemes.end())
	    {
		it_is_a_uri=true;
		    
		result=g_strdup(path_or_uri);		
	    }
	    
	    // Localized file
	    
	    else if (!strcmp(scheme,"localized"))
	    {
		const char * language=context->get(TP_SYSTEM_LANGUAGE,TP_SYSTEM_LANGUAGE_DEFAULT);
		const char * country=context->get(TP_SYSTEM_COUNTRY,TP_SYSTEM_COUNTRY_DEFAULT);

		gchar * try_path=NULL;
		
		// Try <app>/localized/en/US/<path>
		
		try_path=g_build_filename(app_path,"localized",language,country,NULL);
		
		result=Util::rebase_path(try_path,uri);
		
		g_free(try_path);
		
		if (!g_file_test(result,G_FILE_TEST_EXISTS))
		{
		    // Try <app>/localized/en/<path>
		    
		    g_free(result);
		    
		    try_path=g_build_filename(app_path,"localized",language,NULL);
		    
		    result=Util::rebase_path(try_path,uri);
		    
		    g_free(try_path);
		    
		    if (!g_file_test(result,G_FILE_TEST_EXISTS))
		    {
			// Try <app>/localized/<path>
			
			g_free(result);
			
			try_path=g_build_filename(app_path,"localized",NULL);
			
			result=Util::rebase_path(try_path,uri);
			
			g_free(try_path);
			
			if (!g_file_test(result,G_FILE_TEST_EXISTS))
			{
			    // End up with <app>/<path>
			    
			    g_free(result);
			    
			    result=Util::rebase_path(app_path,uri);
			}
		    }
		}
	    }
	    else
	    {
		g_critical("INVALID SCHEME IN '%s'",path_or_uri);
	    }
	}
    }
    
    g_strfreev(parts);
    
    if (result && is_uri)
	*is_uri=it_is_a_uri;
	
#ifdef TP_PRODUCTION

    // Check for links
    
    if (result && !it_is_a_uri && g_file_test(result,G_FILE_TEST_IS_SYMLINK))
    {
	g_critical("SYMBOLIC LINKS NOT ALLOWED : %s",result );
	g_free(result);
	result=NULL;
    }
    
#endif

    return result;
}




