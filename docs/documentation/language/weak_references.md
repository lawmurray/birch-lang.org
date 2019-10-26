Birch uses reference counting to determine when objects should be destroyed. Some usage patterns create reference cycles that prevent object destruction. To break these cycles, weak references may be used. A weak reference is marked by placing an ampersand (`&`) immediately after a class type:

    a:A&;

An object is destroyed as soon it has no references to it besides weak references.

The behavior of Birch differs from some other languages in its handling of weak references. In Birch, **a weak reference must always be valid**, and it is the programmer's responsibility to ensure so. The purpose of a weak reference is solely to eliminate reference cycles, and not to facilitate null values. If the possibility of null values is required, an optional should be used instead.

This differs from other languages where it is usual to promote a weak reference to a shared reference to check validity before use.
