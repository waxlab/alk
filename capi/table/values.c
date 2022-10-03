#include <lua.h>
#include <lauxlib.h>
#include <stdlib.h>

/*
** This example unpacks table values much like the Lua `unpack` function.
** Here is show the unpack only for string and number values.
** While it works, should there a lot of room to improvements.
*/


/* As example we treat only values if they are string or number. */
typedef struct {
  int type;
  union { double number; const char *string;} value;
} resitem;

static int example(lua_State *L) {
  int type;
  int mslot = 1;
  int datalen = 0;
  int reslen = 0;

  resitem *res = malloc(sizeof(resitem));

  /* Push a nil to the top, so lua_next start iteration */
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


int luaopen_capi_table_values(lua_State *L) {

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
