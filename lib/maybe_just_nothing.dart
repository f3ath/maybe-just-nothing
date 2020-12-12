import 'dart:async';

/// A variation of the Maybe monad with eager execution.
abstract class Maybe<T extends Object> {
  /// Creates an instance of the monadic value.
  factory Maybe(T? value) => value != null ? Just(value) : Nothing<T>();

  /// Maps the value to P.
  Maybe<P> map<P extends Object>(P Function(T value) mapper);

  /// Maps the value to P.
  Maybe<P> flatMap<P extends Object>(Maybe<P> Function(T value) mapper);

  /// Filter the value using the [predicate].
  Maybe<T> where(bool Function(T value) predicate);

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

  /// Calls the [consumer] if the wrapped value is present.
  Maybe<T> ifPresent(void Function(T value) consumer);

  /// Calls the [callback] function if the wrapped value is not present.
  Maybe<T> ifNothing(void Function() callback);

  /// Narrows the type to P if the value is present and has actually the type of P.
  Maybe<P> type<P extends Object>();

  /// If this and the other are both [Just] values, merges them using the [merger] function and returns [Just]<V>.
  /// Otherwise returns [Nothing]<V>
  Maybe<V> merge<R extends Object, V extends Object>(
      Maybe<R> other, Merger<V, T, R> merger);

  /// If this is [Nothing], returns the result of [next]. Otherwise return this..
  Maybe<T> fallback(Maybe<T> Function() next);

  /// If this is [Nothing], returns [next]. Otherwise return this..
  Maybe<T> chain(Maybe<T> next);
}

/// Represents an existing non-null value of type T.
class Just<T extends Object> implements Maybe<T> {
  /// Throws an [ArgumentError] if the value is null.
  Just(this.value);

  /// The wrapped value. It is guaranteed to be non-null.
  final T value;

  @override
  Maybe<P> map<P extends Object>(P Function(T value) mapper) =>
      Maybe(mapper(value));

  @override
  Maybe<P> flatMap<P extends Object>(Maybe<P> Function(T value) mapper) =>
      mapper(value);

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
  Just<T> ifPresent(void Function(T value) consumer) {
    consumer(value);
    return this;
  }

  @override
  Just<T> ifNothing(void Function() callback) => this;

  @override
  Maybe<T> where(bool Function(T value) predicate) =>
      predicate(value) ? this : Nothing<T>();

  @override
  Maybe<P> type<P extends Object>() =>
      value is P ? Just(value as P) : Nothing<P>();

  @override
  Maybe<V> merge<R extends Object, V extends Object>(
          Maybe<R> other, Merger<V, T, R> merger) =>
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

typedef Merger<V extends Object, T extends Object, R extends Object> = V
    Function(T a, R b);

/// Represents a non-existing value of type T.
class Nothing<T extends Object> implements Maybe<T> {
  const Nothing();

  @override
  Nothing<P> map<P extends Object>(P Function(T value) mapper) => Nothing<P>();

  @override
  Nothing<P> flatMap<P extends Object>(Maybe<P> Function(T value) mapper) =>
      Nothing<P>();

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
  Nothing<T> ifPresent(void Function(T value) consumer) => this;

  @override
  Nothing<T> ifNothing(void Function() callback) {
    callback();
    return this;
  }

  @override
  Nothing<T> where(bool Function(T value) predicate) => this;

  @override
  Nothing<P> type<P extends Object>() => Nothing<P>();

  @override
  Nothing<V> merge<R extends Object, V extends Object>(
          Maybe<R> other, Merger<V, T, R> merger) =>
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
