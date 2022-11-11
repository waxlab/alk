/*
 * Basic example for userdata.
 *
 * Userdata is a value in C allocated by the Lua `lua_newuserdata()` function.
 * This data then receive a metatable to which can be added Lua functions.
 *
 * With userdata you can basically implement types in Lua to handle directly
 * values only possible (or that are more efficient) on C side, as well as
 * represent types for other C libraries.
 */

#include <lua.h>
#include <lauxlib.h>

/* Type in C */
typedef struct {int x; int y; int z;} coord_t;

/* Data tables used by Lua Module */
static const luaL_Reg coord_mt[];
static const luaL_Reg module[];

/* Module functions */
static int ucreate(lua_State *L);
static int unpack(lua_State *L);
static int rotate(lua_State *L);
int luaopen_capi_userdata_basic(lua_State *L);


/* Type implementations */

static const luaL_Reg coord_mt[] = {
  {"rotate", rotate},
  {"unpack", unpack},
  {NULL, NULL},
};

static const luaL_Reg module[] = {
  {"create", ucreate},
  {NULL,    NULL }
};


/* The public function used by Lua to open the module */
int luaopen_capi_userdata_basic(lua_State *L) {
  #if ( LUA_VERSION_NUM <= 501 )
    /* The metatable for Lua 5.1 */
    luaL_newmetatable(L, "coord_udata_mt");
    lua_pushvalue(L, -1);
    lua_setfield(L, -2, "__index");
    luaL_register(L, NULL, coord_mt);

    /* The module table for Lua <= 5.1 */
    luaL_register(L, "", module);
  #else
    /* The metatable for Lua 5.2+ */
    luaL_newmetatable(L, "coord_udata_mt");
    luaL_newmetatable(L, "coord_udata_mt");
    lua_pushvalue(L, -1);
    lua_setfield(L, -2, "__index");
    luaL_setfuncs(L, coord_mt, 0);

    /* The module table for Lua 5.2+ */
    luaL_newlib(L, module);
  #endif
  return 1;
}


/* Function implementations */

static int ucreate(lua_State *L) {
  int x = luaL_checkinteger(L,1);
  int y = luaL_checkinteger(L,2);
  int z = luaL_checkinteger(L,3);

  /* it registers on Lua and pushes onto stack */
  coord_t *coord = lua_newuserdata(L, sizeof(coord_t));
  coord->x = x;
  coord->y = y;
  coord->z = z;

  luaL_getmetatable(L, "coord_udata_mt");
  lua_setmetatable(L, -2);

  /* only the last is pushed, i.e. the userdata */
  return 1;
}


static int unpack(lua_State *L) {
  coord_t *coord = luaL_checkudata(L, 1, "coord_udata_mt");
  lua_pushinteger(L, coord->x);
  lua_pushinteger(L, coord->y);
  lua_pushinteger(L, coord->z);
  return 3;
}


static int rotate(lua_State *L) {
  coord_t *coord = luaL_checkudata(L, 1, "coord_udata_mt");
  int a = coord->x;
  coord->x = coord->y;
  coord->y = coord->z;
  coord->z = a;

  /* return the same userdata received, so can be chained */
  lua_pushvalue(L,1);
  return 1;
}




