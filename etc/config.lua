rockspec = 'alk-dev-1.rockspec'


bin = { }

-- clib paths have are relative to `./src/`
-- ./src/ext - External dependencies (from other projects)
-- ./src/lib - The C code containing the Lua C Api logic
-- ./src/macros
clib = {
    { "alk.capi.stack.c", { "capi/stack/ex.c" } }
}

cbin = {
  -- {'target', 'code.c' }
}



-- vim: ts=4 sts=4 sw=4
