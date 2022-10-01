#include <lua.h>
#include <lauxlib.h>
#include <string.h>
#include "../capi.h"

static int keys(lua_State *L) {
  char keys[100][100];
  int res = 0;
  int i;

  /* Check if argument is a Lua table */
  luaL_checktype(L, 1, LUA_TTABLE);
  lua_pushnil(L);
  while(lua_next(L,1)){
    if (lua_type(L,-2) == LUA_TSTRING) {
      strcpy(keys[res], lua_tostring(L, -2));
      res ++;
    }
    lua_pop(L,1);
  }
  for (i=0; i<res; i++) lua_pushstring(L, keys[i]);
  return res;
}

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
        /* as the value is on -1 (the top) we pass recursively
         * the positive position of the index on stack
         */
        getkeys(L, lua_gettop(L), res);
    }
    lua_pop(L, 1);
  }
}


static int krecursive(lua_State *L) {
  recurse_res res = { 0, {{0}}};
  int i;
  getkeys(L, 1, &res);
  for (i=0; i<res.c; i++) lua_pushstring(L, res.r[i]);
  return res.c;
}


static int vals(lua_State *L) {
  int count = 0;
  /* Check if argument is a Lua table */
  if (lua_type(L,1) == LUA_TTABLE) {
    while( lua_next(L,1) ) {
      /* values are always under -2 when a table is on top of stack */
      count++;
    }
  }
  return count;
}

int luaopen_alk_capi_table_c(lua_State *L) {

  luaL_Reg module[] = {
    { "keys", keys  },
    { "vals", vals  },
    { "krecursive", krecursive },
    { NULL, NULL    }
  };

  #if ( LUA_VERSION_NUM < 502 )
    luaL_register(L, "", module);
  #else
    luaL_newlib(L,module);
  #endif
  return 1;
}
