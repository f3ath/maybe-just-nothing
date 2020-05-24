/// A variation of the Maybe monad with eager execution.
abstract class Maybe<T> {
  /// Creates an instance of the monadic value.
  factory Maybe(T value) => value == null ? Nothing<T>() : Just(value);

  /// Maps the value
  Maybe<P> map<P>(P Function(T _) mapper);

  /// Filter the value using the [predicate].
  Maybe<T> filter(bool Function(T _) predicate);

  /// Returns the wrapped value (if present) or the [defaultValue] (otherwise).
  T or(T defaultValue);

  /// Returns the wrapped value (if present) or the result of the [producer] (otherwise).
  T orGet(T Function() producer);

  /// Returns the wrapped value (if present) or throws the result of the [producer] (otherwise).
  T orThrow(Object Function() producer);

  /// Calls the [consumer] if the wrapped value is present.
  void ifPresent(void Function(T _) consumer);
}

class Just<T> implements Maybe<T> {
  /// Throws an [ArgumentError] if the value is null.
  Just(this.value) {
    ArgumentError.checkNotNull(value);
  }

  final T value;

  @override
  Maybe<P> map<P>(P Function(T _) f) => Maybe(f(value));

  @override
  T or(T defaultValue) => value;

  @override
  T orGet(T Function() producer) => value;

  @override
  T orThrow(Object Function() producer) => value;

  @override
  void ifPresent(void Function(T _) consumer) => consumer(value);

  @override
  Maybe<T> filter(bool Function(T _) predicate) =>
      predicate(value) ? this : Nothing<T>();
}

class Nothing<T> implements Maybe<T> {
  Nothing();

  @override
  Maybe<P> map<P>(P Function(T _) map) => Nothing<P>();

  @override
  T or(T defaultValue) => defaultValue;

  @override
  T orGet(T Function() producer) => producer();

  @override
  T orThrow(Object Function() producer) => throw producer();

  @override
  void ifPresent(void Function(T _) consumer) {}

  @override
  Maybe<T> filter(bool Function(T _) predicate) => this;
}
