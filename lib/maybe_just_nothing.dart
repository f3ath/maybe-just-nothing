import 'dart:async';

/// A variation of the Maybe monad with eager execution.
abstract class Maybe<T extends Object?> {
  /// Maps the value to P.
  Maybe<P> map<P extends Object?>(P Function(T value) mapper);

  /// Maps the value to P.
  Maybe<P> flatMap<P extends Object?>(Maybe<P> Function(T value) mapper);

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
  void ifPresent(void Function(T value) consumer);

  /// Calls the [callback] function if the wrapped value is not present.
  void ifNothing(void Function() callback);

  /// Narrows the type to P if the value is present and has actually the type of P.
  Maybe<P> type<P extends Object?>();

  /// If this and the other are both [Just] values, merges them using the [merger] function and returns [Just]<V>.
  /// Otherwise returns [Nothing]<V>
  Maybe<R> merge<R extends Object, V extends Object?>(
      Maybe<V> other, Merger<R, T, V> merger);

  /// If this is [Nothing], returns the result of [next]. Otherwise return this..
  Maybe<T> fallback(Maybe<T> Function() next);

  /// If this is [Nothing], returns [next]. Otherwise return this..
  Maybe<T> chain(Maybe<T> next);
}

/// Represents an existing value of type T.
class Just<T extends Object?> implements Maybe<T> {
  Just(this.value);

  /// The wrapped value.
  final T value;

  @override
  Maybe<P> map<P extends Object?>(P Function(T value) mapper) =>
      Just<P>(mapper(value));

  @override
  Maybe<P> flatMap<P extends Object?>(Maybe<P> Function(T value) mapper) =>
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
  void ifPresent(void Function(T value) consumer) => consumer(value);

  @override
  void ifNothing(void Function() callback) {}

  @override
  Maybe<T> where(bool Function(T value) predicate) =>
      predicate(value) ? this : Nothing<T>();

  @override
  Maybe<P> type<P extends Object?>() =>
      value is P ? Just(value as P) : Nothing<P>();

  @override
  Maybe<R> merge<R extends Object, V extends Object?>(
          Maybe<V> other, Merger<R, T, V> merger) =>
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

typedef Merger<R, T, V> = R Function(T a, V b);

/// Represents a non-existing value of type T.
class Nothing<T extends Object?> implements Maybe<T> {
  const Nothing();

  @override
  Nothing<P> map<P extends Object?>(P Function(T value) mapper) => Nothing<P>();

  @override
  Nothing<P> flatMap<P extends Object?>(Maybe<P> Function(T value) mapper) =>
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
  void ifPresent(void Function(T value) consumer) {}

  @override
  void ifNothing(void Function() callback) => callback();

  @override
  Nothing<T> where(bool Function(T value) predicate) => this;

  @override
  Nothing<P> type<P extends Object?>() => Nothing<P>();

  @override
  Nothing<R> merge<R extends Object, V extends Object?>(
          Maybe<V> other, Merger<R, T, V> merger) =>
      Nothing<R>();

  @override
  Maybe<T> fallback(Maybe<T> Function() next) => next();

  @override
  Maybe<T> chain(Maybe<T> next) => next;

  @override
  bool operator ==(other) => other.runtimeType == runtimeType;

  @override
  int get hashCode => runtimeType.hashCode;
}
