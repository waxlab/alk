#include <lua.h>
#include <lauxlib.h>

/*
 * This function allow you to check what is on each extremity of the stack.
 * In order to represent the real state of the stack on function calling, we
 * need to push the last first, as once pushed the stack can be changed
 */

static int example(lua_State *L) {
  lua_pushvalue(L,-1);
  lua_pushvalue(L,1);
  return 2;
}


static luaL_Reg module[] = {
    { "example", example },
    { NULL,      NULL    }
};


int luaopen_capi_stack_borders(lua_State *L) {
  #if ( LUA_VERSION_NUM < 502 )
    luaL_register(L, "", module);
  #else
    luaL_newlib(L,module);
  #endif
  return 1;
}
