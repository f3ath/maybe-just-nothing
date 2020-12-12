# Maybe Just Nothing
Yet another variation of the good old Maybe monad with eager execution written in Dart. 
Or maybe it\'s just nothing?

## Creating maybe-values
The most common scenario is to create a `Maybe` from a nullable value:
```dart
int nullableValue;
final val = Maybe(nullableValue); // Creates an instance of Maybe<int>
final doubled = val.map((x) => x * 2);
doubled.ifPresent(print); // would print the doubled value of nullableValue if it's not null
```

Internally, `Maybe` is an abstract class with two implementations: `Just` and `Nothing`. 
Both can be instantiated directly. Direct instantiation gives more precise type inference in certain cases.

`Just` does not accept null values:

```dart
Just(null); // throws ArgumentError
```

## Mapping values
Mapping means transformation of the wrapped value by applying a function. 
Since `Maybe` itself is immutable, mapping operations do not actually modify the value.
Instead, they always return another `Maybe`. 
```dart
Maybe(2).map((x) => x * 2).ifPresent(print); // prints "4"
```

If the mapping function also returns a `Maybe`, use `flatMap()`:
```dart
Maybe<int> triple(int x) => Maybe(x).map((x) => x * 3);

Maybe(2).flatMap(triple).ifPresent(print); // prints "6"
```

An operation on two maybe-values can be performed using `merge()`:
```dart
final two = Maybe(2);
final three = Maybe(3);

two.merge(three, (x, y) => x + y).ifPresent(print); // prints "5"
```

## Filtering values
Filtering is checking whether the maybe-value satisfies a certain condition. If it does, 
the value remains intact, otherwise `Nothing` is returned. 

To filter bu the value itself, use the `where()`: 
```dart
Maybe(2).where((x) => x.isEven).ifPresent(print); // prints "2"
Maybe(3).where((x) => x.isEven).ifPresent(print); // 3 is odd, so nothing happens
```

To filter by the type, use `type<T>()`:
```dart
final maybeInt = Maybe(2).type<int>(); // Just<int>
final maybeString = Maybe(2).type<String>(); // Nothing<String>
```

## Fallback chain
The `chain()` method implements the [Chain of Responsibility] design pattern. It accepts another
maybe-value of the same type. If the current value is empty, the next value in the chain gets returned.

Another way to implement the same idea is to use the `fallback()` method. It accepts a "fallback" 
function which returns another maybe-value of the same type. If the current value is nothing, 
this fallback function will be called and its result will be returned. You can provide several fallback functions. 
They will be called in sequence until a non-empty value is received.


```dart
int a;
int b;
int c;
b = 2;
c = 3;

Maybe(a) // this one if empty
  .chain(Maybe(b)) // this value is not empty, so it will be used
  .chain(Maybe(c)) // this value will NOT be used
  .ifPresent(print); // prints "2"

// Same with fallback()
Maybe(a) // this one if empty
  .fallback(() => Maybe(b)) // this function returns a non-empty value
  .fallback(() => Maybe(c)) // this function will NOT be called
  .ifPresent(print); // prints "2"
```

## Consuming the value
The intention of `Maybe` is to give it the consumer function instead of retrieving the value.
This is the most concise and clear way if using it.
```dart
int a;
Maybe(a).ifPresent(print).ifNothing(() {/* do something else*/});
```

## Reading the value
Sometimes, however, you need the actual value. In such cases you'll have to provide the default value as well. 

In the simplest scenario, use `or()`:

```dart
int a;
final value = Maybe(a).or(0); // value is 0
final valueFromFuture = await Maybe(a).orAsync(Future.value(0)); // value is 0
```

A provider function can be specified instead of the default value:

```dart
int a;
final value = Maybe(a).orGet(() => 0); // value is 0
final valueFromFuture = await Maybe(a).orGetAsync(() async => 0); // value is 0
```

If there is no default value, an exception can be thrown:

```dart
int a;
final value = Maybe(a).orThrow(() => 'Oops!');
```

In some rare cases, it can be convenient to check for emptiness directly:

```dart
int a;
final myInt = Maybe(a);

if (myInt is Just<int>) {
  print(myInt.value); // .value is guaranteed to be non-null
}

if (myInt is Nothing) {
  print('The value is missing');
}
```

[Chain of Responsibility]: https://refactoring.guru/design-patterns/chain-of-responsibility