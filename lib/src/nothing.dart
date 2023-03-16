import 'package:maybe_just_nothing/src/maybe.dart';
import 'package:maybe_just_nothing/src/merger.dart';

/// Represents a non-existing value of type T.
class Nothing<T> implements Maybe<T> {
  const Nothing();

  @override
  Nothing<P> map<P>(P Function(T value) mapper) => Nothing();

  @override
  Nothing<P> tryMap<P>(P Function(T value) mapper) => Nothing();

  @override
  Nothing<P> flatMap<P>(Maybe<P> Function(T value) mapper) => Nothing();

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
  Nothing<P> type<P>() => Nothing();

  @override
  Nothing<R> merge<R, V>(Maybe<V> other, Merger<R, T, V> merger) => Nothing();

  @override
  Nothing<R> merge2<R, V1, V2>(
          Maybe<V1> v1, Maybe<V2> v2, Merger2<R, T, V1, V2> merger) =>
      Nothing();

  @override
  Maybe<T> fallback(Maybe<T> Function() next) => next();

  @override
  Maybe<T> chain(Maybe<T> next) => next;

  @override
  Nothing<R> as<R>() => Nothing();

  @override
  bool operator ==(other) => other.runtimeType == runtimeType;

  @override
  int get hashCode => runtimeType.hashCode;
}
