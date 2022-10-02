# CONTRIBUTING GUIDELINES

You are free to fork this repo and use it in any way you want to.
We encourage you to share and spread the knowledge built with this project.

To not turn it on a mess, only will be accepted pull requests following these
characteristics:


### Always test under multiple Lua versions

By now we strive to make it very helpful to community, so add tests to be
supported under multiple Lua versions from 5.1 to 5.4. Tests and examples for
flavors of Lua will not be accepted (ex. Luajit, Luvit, Löve) as it has
potential to be messy from the Lua beginner until the advanced. The same line
of thought is extended for packages that restricts to a single Lua flavor or
version (like OpenResty or LuaPower).

### Code style

ALK should be accessible to people under different environments and devices.

* **Test instead output** Lua files should not have output. People should know
the expected result of a Lua code without need to run the code or see the output.
You can accomplish that using the Lua `assert()` function so when running code
you will be certain that the provided example has proven to be correct.

* **Small screens and narrow editors** Today many people use editors with
support to side by side edition. Also casual programmers or people looking for
a readily documentation on small screen devices. To address the most wider
audience in a simple way, we restrict the submissions code that has `80` column
wide text and `2` spaces per indentation level applyable to the comments and
code.

* **Lua comments** should not be block comments ( started as `--[[` ); Always use
the single line notation. On comments feel free to use plain text or markdown
notation only. LuaDoc or EmmyLuaCodeStyle or other notation different from
markdown will not be accepted.

* **C comments** should only use the C89 syntax. Continuation lines for comments
should start with `**`:

```C
/* This is a single line comment. */

/*
** This is a multiline comment
** That spans for more than one line
*/
```

* **C blocks** should keep the open curly braces `{` on the same line of the previous
expression be it function declarations, structs, enums, conditionals or loops.

* **Functions signatures** can be documented as simple and clearer as possible
using `:` to describe expected types:

```Lua
-- sum( a:number, b:number ) : number
function sum(a, b) return a+b end

-- keys( t:{} ): {}
function keys(t)
  local r={}
  for k,_ in pairs(t) do
    r[#r+1] = k
  end
  return r
end
```

**Why it is important?**

I really expect it can be very useful for Lua community. Also expect that in
the future we can spend a time generating a good source for free offline
documentation to be used on consoles, distributed with editors or accessible
through ereaders. Keep a consistent code style is good for the reader and for
the future of project.

## Copyright and License

You are responsible by what you commit. Submitting a code you assume that you
own the copyrights, is the author and aggree to release the code and the text
submitted with it to the ALK project under the MIT Licensing.
