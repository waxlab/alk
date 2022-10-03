#include <lua.h>
#include <lauxlib.h>

/*
** This simple example returns to Lua the number of the items on stack;
** The number returned should be equal to the number of passed arguments.
*/

static int example(lua_State *L) {
  lua_pushinteger(L, lua_gettop(L));
  return 1;
}

static luaL_Reg module[] = {
    { "example", example },
    { NULL,      NULL    }
};

int luaopen_capi_stack_args(lua_State *L) {
  #if ( LUA_VERSION_NUM < 502 )
    luaL_register(L, "", module);
  #else
    luaL_newlib(L,module);
  #endif
  return 1;
}
