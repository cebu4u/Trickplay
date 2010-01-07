#ifndef CONSOLE_H
#define CONSOLE_H

#include <list>

#include "glib.h"
#include "gio/gio.h"

#include "lb.h"

typedef int (*ConsoleCommandHandler)(const char * command,const char * parameters,void * data);

class Console
{
public:
    
    Console(lua_State*,int port);
    ~Console();
    
    void add_command_handler(ConsoleCommandHandler handler,void * data);
    
protected:
    
    gboolean read_data();
    void process_line(gchar * line);
    
    static gboolean channel_watch(GIOChannel * source,GIOCondition condition,gpointer data);
    
private:
    
    Console() {}
    Console(const Console &) {}
    
    typedef std::pair<ConsoleCommandHandler,void*> CommandHandlerClosure;
    typedef std::list<CommandHandlerClosure> CommandHandlerList;
    
    lua_State *         L;
    GIOChannel *        channel;
    GString *           stdin_buffer;
    CommandHandlerList  handlers;

#if GLIB_CHECK_VERSION(2,22,0)

    static void accept_callback(GObject * source,GAsyncResult * result,gpointer data);
    static void data_read_callback(GObject * source,GAsyncResult * result,gpointer data);
    
    static void output_handler(const gchar * line,gpointer data);
    static void connection_destroyed(gpointer data,GObject*connection);
    
    GSocketListener *   listener;
    
#endif    
};


#endif