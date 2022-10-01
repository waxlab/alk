package = "alk"
version = "dev-1"
source = {
  url = "git+https://github.com/waxlab/alk",
  tag = "latest"
}
description = {
  homepage   = "https://codeberg.org/waxlab/alk",
  license    = "MIT",
  summary    = "Recipes on the Lua Alchemy",
  maintainer = "Thadeu de Paula",
  detailed   = "Lua documentation with examples",
}

dependencies = { "lua >= 5.1, < 5.5" }

local build_vars
  = 'ROCKVER="'..version..'" '
  ..'CC="$(CC)" '
  ..'LD="$(LD)" '
  ..'CFLAGS="$(CFLAGS)" '
  ..'LIBFLAG="$(LIBFLAG)" '
  ..'LUA_BINDIR="$(LUA_BINDIR)" '
  ..'LUA_INCDIR="$(LUA_INCDIR)" '
  ..'OBJ_EXTENSION="$(OBJ_EXTENSION)" '
  ..'LIB_EXTENSION="$(LIB_EXTENSION)" '
  ..'LUA="$(LUA)" '

local install_vars
  = 'ROCKVER="'..version..'" '
  ..'INST_PREFIX="$(PREFIX)" '
  ..'INST_BINDIR="$(BINDIR)" '
  ..'INST_LIBDIR="$(LIBDIR)" '
  ..'INST_LUADIR="$(LUADIR)" '
  ..'INST_CONFDIR="$(CONFDIR)" '

build = {
  type = 'command',
  build_command   = build_vars .. '$(LUA) etc/run/make.lua build',
  install_command = install_vars .. '$(LUA) etc/run/make.lua install',
}
