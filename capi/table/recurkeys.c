#include <lua.h>
#include <lauxlib.h>
#include <string.h>



typedef struct {
  int c;
  char r[100][100];
} recurse_res;


static void getkeys(lua_State *L, int idx, recurse_res *res) {
  lua_pushnil(L);
  while(lua_next(L, idx) != 0) {
    if (lua_type(L, -2) == LUA_TSTRING) {
      strcpy(res->r[res->c], lua_tostring(L, -2));
      res->c++;
      if (lua_type(L,-1) == LUA_TTABLE)
        /*
         * as the value is on -1 (the top) we pass recursively
         * the positive position of the index on stack
         */
        getkeys(L, lua_gettop(L), res);
    }
    lua_pop(L, 1);
  }
}


static int example(lua_State *L) {
  recurse_res res = { 0, {{0}}};
  int i;
  getkeys(L, 1, &res);
  for (i=0; i<res.c; i++) lua_pushstring(L, res.r[i]);
  return res.c;
}


int luaopen_capi_table_recurkeys(lua_State *L) {

  luaL_Reg module[] = {
    { "example", example },
    { NULL, NULL    }
  };

  #if ( LUA_VERSION_NUM < 502 )
    luaL_register(L, "", module);
  #else
    luaL_newlib(L,module);
  #endif
  return 1;
}
