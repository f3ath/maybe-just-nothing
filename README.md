# Maybe Just Nothing
Yet another variation of the good old Maybe monad with eager execution written in Dart. 
Or maybe it\'s just nothing?

## Creating maybe-values
Internally, `Maybe` is an abstract class with two implementations: `Just` and `Nothing`.
Both can be instantiated directly.

The most common scenario is discarding null from nullable values:
```dart
int? nullableValue;
final val = Just(nullableValue).type<int>(); // val is either Just<int> or Nothing<int>
final doubled = val.map((x) => x * 2);
doubled.ifPresent(print); // would print the doubled value of nullableValue if it's not null
```

Nullable values can also be wrapped in `Just`:
```dart
int? nullableValue;
final val = Just(nullableValue); // val is Just<int?>
final justNull = Maybe(null); // creates Just<Null>
```

The `Nothing` value may be created either typed or untyped:
```dart
final nothing1 = Nothing(); // Nothing<Object?>
final nothing2 = Nothing<int>(); // Nothing<int>
final nothing3 = Nothing<String?>(); // Nothing<String?>
```

You may even distinguish between presence and absence of `null`s themselves:
```dart
Maybe<Null> yay = Just(null); // Just<Null>
Maybe<Null> nay = Nothing<Null>(); // Nothing<Null>
```

## Mapping values
Mapping means transformation of the wrapped value by applying a function. 
Since `Maybe` itself is immutable, mapping operations do not actually modify the value.
Instead, they always return another `Maybe`. 
```dart
Just(2).map((x) => x * 2).ifPresent(print); // prints "4"
```

If the mapping function also returns a `Maybe`, use `flatMap()`:
```dart
Maybe<int> triple(int x) => Just(x).map((x) => x * 3);

Just(2).flatMap(triple).ifPresent(print); // prints "6"
```

An operation on two maybe-values can be performed using `merge()`:
```dart
final two = Just(2);
final three = Just(3);

two.merge(three, (x, y) => x + y).ifPresent(print); // prints "5"
```

## Filtering values
Filtering is checking whether the maybe-value satisfies a certain condition. If it does, 
the value remains intact, otherwise `Nothing` is returned. 

To filter by the value itself, use the `where()`: 
```dart
Just(2).where((x) => x.isEven).ifPresent(print); // prints "2"
Just(3).where((x) => x.isEven).ifPresent(print); // 3 is odd, so nothing happens
```

To filter by type, use `type<T>()`:
```dart
final maybeInt = Just(2).type<int>(); // Just<int>
final maybeString = Just(2).type<String>(); // Nothing<String>
```

## Fallback chain
The `chain()` method implements the [Chain of Responsibility] design pattern. It accepts another
maybe-value of the same type. If the current value is `Nothing`, the next value in the chain gets returned.

Another way to implement the same idea is to use the `fallback()` method. It accepts a "fallback" 
function which returns another maybe-value of the same type. If the current value is `Nothing`, 
this fallback function will be called and its result will be returned. You can provide several fallback functions. 
They will be called in sequence until a `Just` value is received.


```dart

Nothing<int>()
  .chain(Nothing<int>()) // this will be skipped
  .chain(Just(2)) // this value is not empty, so it will be used
  .chain(Just(3)) // this value will NOT be used
  .ifPresent(print); // prints "2"

// Same with fallback()
Nothing<int>()
  .fallback(() => Nothing<int>()) // this result will be skipped
  .fallback(() => Just(2)) // this function returns a non-empty value
  .fallback(() => Just(3)) // this function will NOT be called
  .ifPresent(print); // prints "2"
```

## Consuming the value
The intention of `Maybe` is to give it the consumer function instead of retrieving the value.
This is the most concise and clear way of using it.
```dart
Maybe a;
a
  ..ifPresent(print)
  ..ifNothing(() {/* do something else*/});
```

## Reading the value
Sometimes, however, you need the actual value. In such cases you'll have to provide the default value as well. 

In the simplest scenario, use `or()`:

```dart
Maybe<int> a;
final value = a.or(0); // value is 0
final valueFromFuture = await a.orAsync(Future.value(0)); // value is 0
```

A provider function can be specified instead of the default value:

```dart
Maybe<int> a;
final value = a.orGet(() => 0); // value is 0
final valueFromFuture = await a.orGetAsync(() async => 0); // value is 0
```

If there is no default value, an exception can be thrown:

```dart
Maybe<int> a;
final value = a.orThrow(() => 'Oops!');
```

In some rare cases, it can be convenient to check for emptiness directly:

```dart
Maybe<int> myInt;

if (myInt is Just<int>) {
  print(myInt.value); // .value is guaranteed to be non-null
}

if (myInt is Nothing) {
  print('The value is missing');
}
```

[Chain of Responsibility]: https://refactoring.guru/design-patterns/chain-of-responsibility