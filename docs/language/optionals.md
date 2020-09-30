Optional types allow variables to have a value of a particular type, or no value at all. An optional type is indicated by following any other type with `?`, like so:
```birch
a:A?;
```

To check whether a variable of optional type has a value, use the postfix `?` operator, which returns `true` if there is a value and `false` if not. If there is a value, use the postfix `!` operator to retrieve it. A common usage idiom is as follows:
```birch
if a? {  // check if a has a value
    f(a!);  // if so, do something with the value of a
}
```
The special value of `nil` may be assigned to an optional to remove an existing value (if any):
```birch
a <- nil;
```

!!! tip
    In some languages, e.g. Java, objects may be null, and this null value may be used to indicate no value. In Birch, an object cannot have a null value, but an optional can be used instead.

    This is particularly useful when writing functions that accept objects as arguments, as there is no need to check whether those arguments actually have a value or not; they will always have a value, unless denoted as optional.

Optional types compose with other types. The following is an optional of array type:
```birch
a:A[_]?;
```
while the following is an array of optional type:
```birch
a:A?[_];
```
In the former case, either the whole array exists or it does not. Retrieve an element with:
```birch
if a? {
    f(a![n]);
}
```
In the latter case, the whole array exists, but each individual element may or may not have a value:
```birch
if a[n]? {
    f(a[n]!);
}
```
