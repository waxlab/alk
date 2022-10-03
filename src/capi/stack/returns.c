#include <lua.h>
#include <lauxlib.h>

/*
** This function allow you to check what is on each extremity of the stack.
** In order to represent the real state of the stack on function calling, we
** need to push the last first, as once pushed the stack can be changed
*/

static int example(lua_State *L) {
  int before, after;
  before = lua_gettop(L);
  lua_pushstring(L, "hi");
  after = lua_gettop(L);
  lua_pushinteger(L, before);
  lua_pushinteger(L, after);
  return 3;
}


static luaL_Reg module[] = {
    { "example", example },
    { NULL,      NULL    }
};


int luaopen_capi_stack_returns(lua_State *L) {
  #if ( LUA_VERSION_NUM < 502 )
    luaL_register(L, "", module);
  #else
    luaL_newlib(L,module);
  #endif
  return 1;
}
