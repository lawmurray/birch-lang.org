Optional types allow variables to have a value of a particular type, or no value at all. An optional type is indicated by following any other type with `?`, like so:

    a:A?;

To check whether a variable of optional type has a value, use the postfix `?` operator, which returns `true` if there is a value and `false` if not. If there is a value, use the postfix `!` operator to retrieve it. A common usage idiom is as follows:

    if (a?) {  // check if a has a value
      f(a!);  // if so, do something with the value of a
    }

The special value of `nil` may be assigned to an optional to remove an existing value (if any):

    a <- nil;

!!! info
    A variable of class type always has a value in Birch. In some other languages (e.g. Java), variables of class type may have a null value, and this null value is often used to denote no value. In Birch, optionals are always used where a variable may have no value.
    
    This is particularly useful when writing functions that accept arguments of class type, as there is no need to check whether those arguments actually have a value or not; they will always have a value, unless denoted as optional.

Optional types compose with other types. The following is an optional of array type:

    a:A[_]?;
    
while the following is an array of optional type:

    a:A?[_];

In the former case, either the whole array exists or it does not. Retrieve an element with:

    if (a?) {
      f(a![n]);
    }
    
In the latter case, the whole array exists, but each individual element may or may not have a value:

    if (a[n]?) {
      f(a[n]!);
    }
