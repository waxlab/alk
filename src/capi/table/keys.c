#include <lua.h>
#include <lauxlib.h>
#include <string.h>



static int example(lua_State *L) {
  char keys[100][100];
  int res = 0;
  int i;

  /* Check if argument is a Lua table */
  luaL_checktype(L, 1, LUA_TTABLE);

  /*
  ** it makes the top of stack (-1) be nil
  ** the lua_next will look for the nil key on the (L,1)
  ** Indicating that the next item is the first one
  */
  lua_pushnil(L);

  while(lua_next(L,1)){

    /* To make the example simpler we use only strings */
    if (lua_type(L,-2) == LUA_TSTRING) {
      /* We make a copy to avoid mess with the stack */
      strcpy(keys[res], lua_tostring(L, -2));
      res ++;
    }

    /*
    ** It is necessary to remove the value from the top
    ** of stack or lua_next will act as if it was the key
    */
    lua_pop(L,1);
  }
  for (i=0; i<res; i++) lua_pushstring(L, keys[i]);
  return res;
}


int luaopen_capi_table_keys(lua_State *L) {

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
