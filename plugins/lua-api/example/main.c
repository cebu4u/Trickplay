
#include "trickplay/plugins/lua-api.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>


/******************************************************************************
 * Initialize
 * Called by TrickPlay the first time this plugin is loaded.
 */

void
tp_plugin_initialize( TPPluginInfo * info , const char * config )
{
    strncpy( info->name , "TrickPlay LUA API Example" , sizeof( info->name ) - 1 );
    strncpy( info->version , "1.0" , sizeof( info->version ) - 1 );
}

/******************************************************************************
 * foo
 * A function we will add to Lua.
 */

static int foo( lua_State * L )
{
	int top = lua_gettop( L );

	if ( 0 == top )
	{
		return luaL_error( L , "This is a failure from a plugin." );
	}

	printf( "'foo' was called with %d argument(s)\n" , top );

	return 0;
}

/******************************************************************************
 * Open
 * Called whenever a new app is executed.
 */

int
tp_lua_api_open( lua_State * L , const char * app_id , void * user_data )
{
	printf( "THIS PLUGIN IS BEING OPENED FOR APP '%s'\n" , app_id );

	/* Add a global function called 'foo' */

	lua_pushcfunction( L , foo );
	lua_setglobal( L , "foo" );

	return 0;
}

/******************************************************************************
 * Close
 * Called when an app is shutting down.
 */

void
tp_lua_api_close( lua_State * L , const char * app_id , void * user_data )
{
	printf( "THIS PLUGIN IS BEING CLOSED FOR APP '%s'\n" , app_id );
}

/******************************************************************************
 * Shutdown
 * Called by TrickPlay before this plugin is unloaded.
 */

void
tp_plugin_shutdown( void * user_data )
{
    /* Nothing to do - but we could free resources associated with user data. */
}

/*****************************************************************************/



