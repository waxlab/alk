#include <lua.h>
#include <lauxlib.h>

/*
--| lua_gettop(L) returns the top of stack index, i.e, stack size
*/

static int table(lua_State *L) {
  return 0;
}


static int args(lua_State *L) {
  lua_pushinteger(L, lua_gettop(L));
  return 1;
}

/* In order to represent the real state of the stack on function
** calling, we need to push the last first, as once pushed the
** stack can be changed */
static int edges(lua_State *L) {
  lua_pushvalue(L,-1);
  lua_pushvalue(L,1);
  return 2;
}

static int returns(lua_State *L) {
  int before, after;
  before = lua_gettop(L);
  lua_pushstring(L, "hi");
  after = lua_gettop(L);
  lua_pushinteger(L, before);
  lua_pushinteger(L, after);
  return 3;
}

int luaopen_alk_capi_stack_c(lua_State *L) {

  luaL_Reg module[] = {
    { "args",    args    },
    { "edges",   edges   },
    { "returns", returns },
    { "table",   table   },
    { NULL,      NULL    }
  };

  #if ( LUA_VERSION_NUM < 502 )
    luaL_register(L, "", module);
  #else
    luaL_newlib(L,module);
  #endif
  return 1;
}
