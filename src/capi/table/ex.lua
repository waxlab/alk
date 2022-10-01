
int luaopen_alk_capi_table_c(lua_State *L) {

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
