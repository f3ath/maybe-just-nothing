/// A variation of the Maybe monad with eager execution.
abstract class Maybe<T> {
  /// Creates an instance of the monadic value.
  factory Maybe(T value) => value == null ? Nothing<T>() : Just(value);

  /// Maps the value to P. The [mapper] function must not return null.
  Maybe<P> map<P>(P Function(T _) mapper);

  /// Maps the value to P.
  Maybe<P> flatMap<P>(Maybe<P> Function(T _) mapper);

  /// Filter the value using the [predicate].
  Maybe<T> filter(bool Function(T _) predicate);

  /// Returns the wrapped value (if present), or the [defaultValue] (otherwise).
  T or(T defaultValue);

  /// Returns a [Future] of the wrapped value (if present), or the [defaultValue] (otherwise).
  Future<T> orAsync(Future<T> defaultValue);

  /// Returns the wrapped value (if present), or the result of the [producer] (otherwise).
  T orGet(T Function() producer);

  /// Returns a [Future] of the wrapped value (if present), or the result of the [producer] (otherwise).
  Future<T> orGetAsync(Future<T> Function() producer);

  /// Returns the wrapped value (if present), or throws the result of the [producer] (otherwise).
  T orThrow(Object Function() producer);

  /// Calls the [consumer] if the wrapped value is present. If the value is not present,
  /// and the [otherwise] function is passed, calls it.
  void ifPresent(void Function(T _) consumer, {void Function() otherwise});

  /// Calls the [callback] function if the wrapped value is not present.
  void ifNothing(void Function() callback);

  /// Narrows the type to P if the value is present and has actually the type of P.
  Maybe<P> cast<P extends T>();

  /// Merges the [other] value using the [merger] function.
  Maybe<V> merge<V, R>(Maybe<R> other, V Function(T a, R b) merger);
}

/// Represents an existing non-null value of type T.
class Just<T> implements Maybe<T> {
  /// Throws an [ArgumentError] if the value is null.
  Just(this.value) {
    ArgumentError.checkNotNull(value);
  }

  /// The wrapped value. It is guaranteed to be non-null.
  final T value;

  @override
  Maybe<P> map<P>(P Function(T _) mapper) => Just(mapper(value));

  @override
  Maybe<P> flatMap<P>(Maybe<P> Function(T _) mapper) => mapper(value);

  @override
  T or(T defaultValue) => value;

  @override
  Future<T> orAsync(Future<T> defaultValue) async => value;

  @override
  T orGet(T Function() producer) => value;

  @override
  Future<T> orGetAsync(Future<T> Function() producer) async => value;

  @override
  T orThrow(Object Function() producer) => value;

  @override
  void ifPresent(void Function(T _) consumer, {void Function() otherwise}) =>
      consumer(value);

  @override
  void ifNothing(void Function() callback) {}

  @override
  Maybe<T> filter(bool Function(T _) predicate) =>
      predicate(value) ? this : Nothing<T>();

  @override
  Maybe<P> cast<P extends T>() => value is P ? Just(value) : Nothing<P>();

  @override
  Maybe<V> merge<V, R>(Maybe<R> other, V Function(T a, R b) merger) =>
      flatMap((a) => other.map((b) => merger(a, b)));
}

/// Represents a non-existing value of type T.
class Nothing<T> implements Maybe<T> {
  Nothing();

  @override
  Maybe<P> map<P>(P Function(T _) mapper) => Nothing<P>();

  @override
  Maybe<P> flatMap<P>(Maybe<P> Function(T _) mapper) => Nothing<P>();

  @override
  T or(T defaultValue) => defaultValue;

  @override
  Future<T> orAsync(Future<T> defaultValue) => defaultValue;

  @override
  T orGet(T Function() producer) => producer();

  @override
  Future<T> orGetAsync(Future<T> Function() producer) async => producer();

  @override
  T orThrow(Object Function() producer) => throw producer();

  @override
  void ifPresent(void Function(T _) consumer, {void Function() otherwise}) =>
      otherwise?.call();

  @override
  void ifNothing(void Function() callback) => callback();

  @override
  Maybe<T> filter(bool Function(T _) predicate) => this;

  @override
  Maybe<P> cast<P extends T>() => Nothing<P>();

  @override
  Maybe<V> merge<V, R>(Maybe<R> other, V Function(T a, R b) merger) =>
      Nothing<V>();
}
