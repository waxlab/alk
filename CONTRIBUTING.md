# CONTRIBUTING

As you can see this project has documentation inside Lua and C files.
To be more useful to everyone some rules should be observed:

* **Lua files should not have output**, i.e, people should know what Lua is
doing without see output. You can accomplish that adding tests with `assert`
functions, in a way that the reader/visitor/developer/magician that came to
the code know exactly to what the code was evaluated to. Also doing this, when
running code you will be certain that example has proven correct.

* **Always test under multiple Lua versions**. Check the main project documentation
to know which Lua versions should be supported.


## Configure your text editor

For C and Lua files our coding style uses:

* `2` spaces for indentation

* `80` column wide

* C curly braces opening `{` should be kept in the line where the expression is
opened, be in function declaratinos or in conditional/loops.

The main reason to adopt this approach is:

* The majority of IDEs support side-by-side edition. Some support even
multiple vertical splits. 80 columns and 2 spaces as indentation give the
reader/developer possibility to improve its work editing a source and its
testings or even reading documentation.

* It widens the device use possibilities, giving accessibility to develop and
and read the code even in mobile (ex: Termux) or older devices.

* It enforces the code simplicity. It is paradoxal, but it keep your code
vertical, at the same time that reinforce the functions to be smaller,
easy to read and simple to understand.


