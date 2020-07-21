import 'dart:async';

/// A variation of the Maybe monad with eager execution.
abstract class Maybe<T> {
  /// Creates an instance of the monadic value.
  factory Maybe(T value) => value == null ? Nothing<T>() : Just(value);

  /// Maps the value to P. The [mapper] function must not return null.
  Maybe<P> map<P>(P Function(T _) mapper);

  /// Maps the value to P.
  Maybe<P> flatMap<P>(Maybe<P> Function(T _) mapper);

  /// Filter the value using the [predicate].
  Maybe<T> where(bool Function(T _) predicate);

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
  Maybe<T> ifPresent(void Function(T _) consumer, {void Function() otherwise});

  /// Calls the [callback] function if the wrapped value is not present.
  Maybe<T> ifNothing(void Function() callback);

  /// Narrows the type to P if the value is present and has actually the type of P.
  Maybe<P> type<P>();

  /// Merges the [other] value using the [merger] function.
  Maybe<V> merge<V, R>(Maybe<R> other, V Function(T a, R b) merger);

  /// Returns the result of [next] if this is empty.
  Maybe<T> fallback(Maybe<T> Function() next);

  /// Returns the [next] Maybe if this is empty.
  Maybe<T> chain(Maybe<T> next);
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
  Maybe<P> map<P>(P Function(T _) mapper) => Maybe(mapper(value));

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
  Just<T> ifPresent(void Function(T _) consumer, {void Function() otherwise}) {
    consumer(value);
    return this;
  }

  @override
  Just<T> ifNothing(void Function() callback) => this;

  @override
  Maybe<T> where(bool Function(T _) predicate) =>
      predicate(value) ? this : Nothing<T>();

  @override
  Maybe<P> type<P>() => value is P ? Just(value as P) : Nothing<P>();

  @override
  Maybe<V> merge<V, R>(Maybe<R> other, V Function(T a, R b) merger) =>
      flatMap((a) => other.map((b) => merger(a, b)));

  @override
  Maybe<T> fallback(Maybe<T> Function() next) => this;

  @override
  Maybe<T> chain(Maybe<T> next) => this;

  @override
  bool operator ==(other) => other is Just<T> && other.value == value;

  @override
  int get hashCode => value.hashCode;
}

/// Represents a non-existing value of type T.
class Nothing<T> implements Maybe<T> {
  const Nothing();

  @override
  Nothing<P> map<P>(P Function(T _) mapper) => Nothing<P>();

  @override
  Nothing<P> flatMap<P>(Maybe<P> Function(T _) mapper) => Nothing<P>();

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
  Nothing<T> ifPresent(void Function(T _) consumer,
      {void Function() otherwise}) {
    otherwise?.call();
    return this;
  }

  @override
  Nothing<T> ifNothing(void Function() callback) {
    callback();
    return this;
  }

  @override
  Nothing<T> where(bool Function(T _) predicate) => this;

  @override
  Nothing<P> type<P>() => Nothing<P>();

  @override
  Nothing<V> merge<V, R>(Maybe<R> other, V Function(T a, R b) merger) =>
      Nothing<V>();

  @override
  Maybe<T> fallback(Maybe<T> Function() next) => next();

  @override
  Maybe<T> chain(Maybe<T> next) => next;

  @override
  bool operator ==(other) => other.runtimeType == runtimeType;

  @override
  int get hashCode => runtimeType.hashCode;
}
