import 'package:maybe_just_nothing/merger.dart';

/// A variation of the Maybe monad with eager execution.
abstract class Maybe<T> {
  /// Maps the value to P.
  Maybe<P> map<P>(P Function(T value) mapper);

  /// Tries to map value to P. If the [mapper] throws anything
  /// (not just an [Exception]), returns `Nothing<P>`.
  Maybe<P> tryMap<P>(P Function(T value) mapper);

  /// Maps the value to P.
  Maybe<P> flatMap<P>(Maybe<P> Function(T value) mapper);

  /// Filter the value using the [predicate].
  Maybe<T> where(bool Function(T value) predicate);

  /// Returns the wrapped value (if present), or the [defaultValue].
  T or(T defaultValue);

  /// Returns a [Future] of the wrapped value (if present), or the [defaultValue].
  Future<T> orAsync(Future<T> defaultValue);

  /// Returns the wrapped value (if present), or the result of the [producer].
  T orGet(T Function() producer);

  /// Returns a [Future] of the wrapped value (if present), or the result of the [producer].
  Future<T> orGetAsync(Future<T> Function() producer);

  /// Returns the wrapped value (if present), or throws the result of the [producer].
  T orThrow(Object Function() producer);

  /// Calls the [consumer] if the wrapped value is present.
  void ifPresent(void Function(T value) consumer);

  /// Calls the [callback] function if the wrapped value is not present.
  void ifNothing(void Function() callback);

  /// Narrows the type to P if the value is present and has actually the type of P.
  Maybe<P> type<P>();

  /// If this and the [other] are both [Just] values, merges them using the [merger] function and returns [Just]<V>.
  /// Otherwise returns [Nothing]<V>
  Maybe<R> merge<R, V>(Maybe<V> other, Merger<R, T, V> merger);

  /// Same as [merge], but with 2 arguments.
  Maybe<R> merge2<R, V1, V2>(
      Maybe<V1> v1, Maybe<V2> v2, Merger2<R, T, V1, V2> merger);

  /// If this is [Nothing], returns the result of [next]. Otherwise return this..
  Maybe<T> fallback(Maybe<T> Function() next);

  /// If this is [Nothing], returns [next]. Otherwise return this..
  Maybe<T> chain(Maybe<T> next);
}
