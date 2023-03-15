import 'package:maybe_just_nothing/maybe.dart';
import 'package:maybe_just_nothing/merger.dart';
import 'package:maybe_just_nothing/nothing.dart';

/// Represents an existing value of type T.
class Just<T> implements Maybe<T> {
  const Just(this.value);

  /// The wrapped value.
  final T value;

  @override
  Maybe<P> map<P>(P Function(T value) mapper) => Just(mapper(value));

  @override
  Maybe<P> tryMap<P>(P Function(T value) mapper) {
    try {
      return Just(mapper(value));
    } catch (_) {
      return Nothing();
    }
  }

  @override
  Maybe<P> flatMap<P>(Maybe<P> Function(T value) mapper) => mapper(value);

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
      predicate(value) ? this : Nothing();

  @override
  Maybe<P> type<P>() => value is P ? Just(value as P) : Nothing();

  @override
  Maybe<R> merge<R, V>(Maybe<V> other, Merger<R, T, V> merger) =>
      flatMap((a) => other.map((b) => merger(a, b)));

  @override
  Maybe<R> merge2<R, V1, V2>(
          Maybe<V1> v1, Maybe<V2> v2, Merger2<R, T, V1, V2> merger) =>
      flatMap((a) => v1.flatMap((b) => v2.map((c) => merger(a, b, c))));

  @override
  Maybe<T> fallback(Maybe<T> Function() next) => this;

  @override
  Maybe<T> chain(Maybe<T> next) => this;

  @override
  bool operator ==(other) => other is Just<T> && other.value == value;

  @override
  int get hashCode => value.hashCode;
}
