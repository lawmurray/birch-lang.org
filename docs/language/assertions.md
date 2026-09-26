Assertion statements are written as:
```birch
assert a;
```

When in debug or test mode, and `a` evaluates to false, a runtime error occurs. When in release mode, assertions are ignored (see [configure](https://birch-docs.indii.org/libraries/Standard/programs/configure) regarding modes).
