Birch supports the most common arithmetic and logical operators found in other programming languages.

### Unary operators

The prefix unary operators are all of equal precedence, and of higher precedence than all binary operators:

|              |              |                 |
| ------------ | ------------ | --------------- |
| `+` Identity | `-` Negative | `!` Logical not |

The postfix unary operators are used with [optionals](/language/optionals). They are of equal precedence, and of higher precedence than all other operators, including the prefix unary operators:

|           |         |
| --------- | ------- |
| `?` Query | `!` Get |

### Binary operators

The (infix) binary operators are, in order of highest to lowest precedence:

|     |     |     |     |
| --- | --- | --- | --- |
| `*` Multiply       | `/` Divide      | | |
| `+` Add            | `-` Subtract    | | |
| `<` Less           | `>` Greater     | `<=` Less or equal  | `>=` Greater or equal |
| `==` Equal         | `!=` Not equal  | | |
| `&&` Logical and   | | | |
| `||` Logical or    | | | |
| `<-` Assign

There are no operators for power or modulus: the standard library functions `pow` and `mod` should be used instead. There are no operators defined for bit operations.

### Overloading

The action of standard operators is defined by overloads, declared using the `operator` statement. Only the standard operators may be overloaded. All other operators have in-built behavior as described above.

!!! info
    It is still possible to manipulate the behavior of some operators that cannot be overloaded. For example, the behavior of the assignment operator `<-` can be manipulated by declaring assignments and conversions in class declarations.

A binary operator `+` with two operands `a:A` and `b:B`, and return type `C`, is declared as:
```birch
operator (a:A + b:B) -> C {
  c:C;
  // do something
  return c;
}
```
Any of the standard binary operators may be used in place of `+`.

A unary operator `+` with one operand `a:A`, and return type `C`, is declared as:
```birch
operator (+a:A) -> C {
  c:C;
  return c;
}
```
Any of the standard unary operators may be used in place of `+`.

Operators always have a return type. It is not possible to manipulate operator precedence.
