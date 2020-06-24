Birch supports the most common arithmetic and logical operators found in other programming languages.

### Unary operators

The prefix unary operators are all of equal precedence, and of higher precedence than all binary operators:

|              |              |                 |
| ------------ | ------------ | --------------- |
| `+` Identity | `-` Negative | `!` Logical not |

The postfix unary operators are used with [optional](optionals) and [fiber](fibers). They are of equal precedence, and of higher precedence than all other operators, including the prefix unary operators:

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
| `<-` Assign | `<~` Simulate | `~>` Observe | `~` Assume |

There are no operators for power or modulus: the standard library functions `pow` and `mod` should be used instead. There are no operators defined for bit operations.

The last three operators are introduced for concise probabilistic statements and interactions between models and inference methods. They may only be used within fibers that yield the type `Event`, in which models are typically defined.

Let `x` be an object of basic type (e.g. `Real`), optional type (e.g. `Real?`) or random type (e.g. `Random<Real>`), and `p` an object of `Distribution` type. Then:

  * `x <~ p` simulates from the distribution `p` and assigns the variate to `x`,
  * `x ~> p` observes a variate of value `x` produced from the distribution `p`,
  * `x ~ p` assumes that the variate `x` is distributed according to the distribution `p`, although it may not be simulated from it immediately, or ever, according to subsequent statements.

### Overloading

The action of standard operators is defined by overloads, declared using the `operator` statement. Only the standard operators may be overloaded. All other operators have in-built behavior as described above.

!!! info
    It is still possible to manipulate the behavior of some operators that cannot be overloaded. For example, the behavior of the assignment operator `<-` can be manipulated by declaring assignments and conversions in class declarations.

A binary operator `+` with two operands `a:A` and `b:B`, and return type `C`, is declared as:

    operator (a:A + b:B) -> C {
      c:C;
      // do something
      return c;
    }

Any of the standard binary operators may be used in place of `+`.

A unary operator `+` with one operand `a:A`, and return type `C`, is declared as:

    operator (+a:A) -> C {
      c:C;
      return c;
    }

Any of the standard unary operators may be used in place of `+`.

Operators always have a return type. It is not possible to manipulate operator precedence.
