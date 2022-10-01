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

build = {
  type = 'builtin',
  modules = {
    ["alk.stack"]   = "src/stack/ex.lua",
    ["alk.stack.c"] = "src/stack/ex.c"
  }
}
