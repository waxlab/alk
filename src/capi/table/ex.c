#include <lua.h>
#include <lauxlib.h>
#include <string.h>
#include "../capi.h"
#include "luaconf.h"
#include "stdlib.h"

/*
** as
** capi.table.c.keys
*/
static int module_keys(lua_State *L) {
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


/*
** as
** capi.table.c.keysrec
*/

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


/*
** as
** capi.table.c.keys
*/

static int module_keysrec(lua_State *L) {
  recurse_res res = { 0, {{0}}};
  int i;
  getkeys(L, 1, &res);
  for (i=0; i<res.c; i++) lua_pushstring(L, res.r[i]);
  return res.c;
}




static int module_values(lua_State *L) {
  int type;
  int mslot = 1;
  int datalen = 0;
  int reslen = 0;

  /* As example we treat only values if they are string or number. */
  typedef struct {
    int type;
    union { double number; const char *string;} value;
  } resitem;
  resitem *res = malloc(sizeof(resitem));

  lua_pushnil(L);
  if (lua_type(L,-2) == LUA_TTABLE) {
    while( lua_next(L,-2) != 0 ) {
      type = lua_type(L,-1);

      if (datalen == mslot) {
        /* Allocate memory when needed */
        if ( (res = realloc(res, sizeof(resitem) * ((mslot *= 2 )))) == NULL ) {
          lua_pushstring(L,"out of memory");
          lua_error(L);
        }
      }

      if (type == LUA_TSTRING) {
        res[datalen].type = type;
        res[datalen++].value.string = lua_tostring(L,-1);
      } else if (type == LUA_TNUMBER) {
        res[datalen].type = type;
        res[datalen++].value.number = lua_tonumber(L,-1);
      }
      lua_pop(L,1);
    }
  }

  for(; reslen < datalen; reslen++) {
    /* We push what we collected in struct */
    switch (res[reslen].type) {
      case LUA_TNUMBER: lua_pushnumber(L, res[reslen].value.number); break;
      case LUA_TSTRING: lua_pushstring(L, res[reslen].value.string); break;
    }
  }
  free(res);
  return reslen;
}

int luaopen_alk_capi_table_c(lua_State *L) {

  luaL_Reg module[] = {
    { "keys",    module_keys    },
    { "values",  module_values  },
    { "keysrec", module_keysrec },
    { NULL, NULL    }
  };

  #if ( LUA_VERSION_NUM < 502 )
    luaL_register(L, "", module);
  #else
    luaL_newlib(L,module);
  #endif
  return 1;
}
