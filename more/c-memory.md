# C Memory Allocation

Basically two type of allocations:


**Stack**

Automatically allocated memory for the variables on function scope. They are
automatically freed when function returns.

- pros: easy to handle, good for distracted... not need to be manually freed.
- cons: doesn't persist after the scope where was declared.

**Heap**

Manually allocated memory that is not freed automatically when the function
that declares it returns. To use heap you need to allocate memory with
`malloc()`, `realloc()` etc. and free the allocated memory with `free()`.

- pros: allow to return a complex value (string, array, struct etc.) after the
function returns, persisting after the scope where was created.
- cons: need to be manually collected, and distracted programmers will let the
memory leaks from the program.


## Traps

I can say that 99% of my trouble is with memory allocation. The other 1% is
basically distraction or confusion with function names.

The fact is that today most of the editors has some support for LSP using
`clangd` or `ccls`. You can avoid bad patterns that lead to ugly errors checking
your code with [sparse](https://sparse.docs.kernel.org) etc. If you follow their
advices your only problem will be the memory part.

So, when hanging on a segfault, core dump or stack overflow... the main reason
should be bad management of memory.

1. When declaring pointers, init them to NULL. While some people argue it is
not necessary, blablabla, a not initialized pointer points to anywhere. And may
even point to a memory allocated by another uninitialized pointer. So them you
may have very stranger things, and I prefer follow this than loose time
inspecting gdb, valgrind etc.

2. When declaring struct values, always initialize them also by the same reason
than (1). You may prefer to have an initializer function so you centralize the
code for easy and faster future refactoring.

3. While `man realloc` says that if you pass `NULL` it will realloc a new pointer
or when using size `0` it will act like `free()` do not use this way. If you
want a elastic variable that can be used after freed, it is better to create
a reallocator function that:

- receives the pointer and the size
- when size is `0` calls correctly the `free()` and reinitialize the variable
to `NULL` and
- when size is `!= 0` then checks, if the value is `NULL` then uses `malloc`,
otherwise uses `realloc`.


## Strategies

**S.1: Outer function variable:** An interesting way to avoid manual
allocation is declare a variable in outside function and pass in calls as a
pointer.

    void a(void) {
        int x;
        b(&x);
    }

This way `b` can freely use the variable that will freed when the function `a`
ends.

The downside is on variables that need to me resized:

```C
    void a(void) {
        int x[10];
        b(&x);
    }
```

In such case the function `b` cannot resize the length of the array to more
than 10 items.


**S.2 Allocate in outer function:** free before it returns:** It consists in the
use of the `malloc` family of functions to allocate memory in the outer
function, pass the variable through the inner calls and call `free` before the
return.


**S.3 Allocate inside, deallocate outside:** the function called is
responsible to allocate the memory of the data that will returned. The
caller is responsible to free it. This strategy should be avoided as it leads
to confusion and distraction.


**S.4 Use custom allocators/deallocators:** When dealing with complex types
like structs and arrays to deallocate a type you need to deallocate its
branches before to avoid leaks. Also a slip and you may forget to
initialize correctly the structure members. Illustrative suggestion of functions:


Type constructor: `yourtype_set(yourtype *)`
sets the basic values to avoid core dumps or segfaults.

Type destructor: `yourtype_unset(yourtype *)` 
Responsible to deallocate vars if the custom type correctly considering inner
tree.

Array struct:

```C
    typedef struct {
        size_t size;    /* The allocated size */
        size_t len;     /* Used length */
        yourtype *arr;  /* The array */
    } myarray;
```

Array functions
* `myarray_init(size_t sz)` Initialize the structure with correct values.
* `myarray_resize(myarray *A, size_t sz)` resize the array.
* `myarray_add(myarray *A, yourtype *value)` add the item changing the `len`
structure member and possibly reallocating space to `*arr` and updating `size`
when needed.
* `myarray_free(myArray *A)` recursively free the data and sets `A` to `NULL`





