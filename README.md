# Maybe Just Nothing
Yet another variation of the good old Maybe monad with eager execution written in Dart. Or maybe it\'s just nothing.
```dart
import 'package:maybe_just_nothing/maybe_just_nothing.dart';

Maybe<int> addTwoIntegers(dynamic a, dynamic b) =>
    Maybe(a).cast<int>().merge(Maybe(b).cast<int>(), (a, b) => a + b);

void main() {
  // Prints 42
  addTwoIntegers(40, 2).ifPresent(print);

  // Does nothing since one of the values is null.
  addTwoIntegers(40, null).ifPresent(print);

  // Does nothing since one of the values is not an integer.
  addTwoIntegers('Oops', 2).ifPresent(print);
}

````

## Classes: 
- `Maybe(nullableValue)` wraps a possibly null value
- `Just(42)` wraps a non null value (throws `ArgumentError` on null)
- `Nothing<T>()` represents a missing value of type `T`

## Methods
### map
Maps the value.
### flatMap
Maps the value.
### filter
Filters the value by the given predicate.
### or
Returns the wrapped value (if present), or the default value (otherwise).
### orAsync
Returns a `Future` of the wrapped value (if present), or the default value (otherwise).
### orGet
Returns the wrapped value (if present), or the result of the producer function (otherwise).
### orGetAsync
Returns a `Future` of the wrapped value (if present), or the result of the producer function (otherwise).
### orThrow
Returns the wrapped value (if present), or throws the result of the producer function (otherwise).
### ifPresent
Calls the consumer function if the wrapped value is present.
### ifNothing
Calls the callback function if the wrapped value is not present.
### cast
Narrows the type to P if the value is present and has actually the type of P.
### merge
Merges the other `Maybe` using the merger function.

### Q&amp;A
#### Where is `isPresent`?
It is not there by design. Most of the times using `ifPresent()` and `ifNothing()` should be sufficient. 
If thee is no choice but inline logic, use the type checks:
```dart
void fun(Maybe<int> score) {
  if (score is Just<int>) {
    doSomething(score.value); // Bonus! The score.value is available and guaranteed to be non-null.
  } else {
    // do something else
  }
}
```
