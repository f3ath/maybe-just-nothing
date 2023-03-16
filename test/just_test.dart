import 'dart:async';

import 'package:maybe_just_nothing/maybe_just_nothing.dart';
import 'package:test/test.dart';

void main() {
  test('Generics', () {
    expect(Nothing<num>(), isA<Nothing<num>>());
    expect(Nothing<num?>(), isA<Nothing<num?>>());
    expect(Nothing<void>(), isA<Nothing<void>>());

    expect(Nothing<void>(), isA<Maybe<void>>());
    expect(Just(null), isA<Maybe<void>>());
  });

  test('Const values', () {
    expect(const Nothing<num>(), isA<Maybe<num>>());
    expect(const Just(null), isA<Maybe<void>>());
    expect(const Just('foo'), isA<Maybe<String>>());
  });

  test('Basic getters', () async {
    Maybe<int> oddTimes3(number) =>
        Just(number).type<int>().where((_) => _.isOdd).map((_) => _ * 3);

    expect(oddTimes3(5).orThrow(() => 'Oops'), 15);
    expect(await oddTimes3(5).orGetAsync(() => Future.value(100)), 15);
    expect(await oddTimes3(5).orAsync(Future.value(100)), 15);

    expect(oddTimes3(null).or(100), 100);
    expect(oddTimes3(2).orGet(() => 100), 100);
    expect(await oddTimes3(2).orGetAsync(() => Future.value(100)), 100);
    expect(await oddTimes3(2).orAsync(Future.value(100)), 100);
  });

  test('Map', () {
    expect(Just(2).map((_) => _ * 2).orThrow(() => 'Oops'), 4);
    expect(Nothing<int>().map((_) => _ * 2), isA<Nothing<int>>());
  });

  test('TryMap', () {
    T single<T>(List<T> list) => list.single;
    expect(Just([]).tryMap(single), isA<Nothing>());
    expect(Just([2]).tryMap(single).orThrow(() => 'Oops'), 2);
    expect(Just([1, 2]).tryMap(single), isA<Nothing<int>>());
    expect(Nothing<List>().tryMap(single), isA<Nothing>());
  });

  test('Merge', () {
    int add(int a, int b) => a + b;
    expect(Just(2).merge(Just(3), add).orThrow(() => 'Oops'), 5);
    expect(Nothing<int>().merge(Just(3), add), isA<Nothing<num>>());
    expect(Just(2).merge(Nothing<int>(), add), isA<Nothing<num>>());
  });

  test('Merge2', () {
    int add(int a, int b, int c) => a + b + c;
    expect(Just(2).merge2(Just(3), Just(4), add).orThrow(() => 'Oops'), 9);
    expect(Nothing<int>().merge2(Just(3), Just(4), add), isA<Nothing<num>>());
    expect(Just(2).merge2(Nothing<int>(), Just(4), add), isA<Nothing<num>>());
    expect(Just(2).merge2(Just(4), Nothing<int>(), add), isA<Nothing<num>>());
  });

  test('FlatMap', () {
    expect(Just(2).flatMap((_) => Just(_ * 2)).orThrow(() => 'Oops'), 4);
    expect(Nothing<int>().flatMap((_) => Just(_ * 2)), isA<Nothing<int>>());
  });

  test('Filtering', () {
    expect(Just(2).where((_) => _.isEven).orThrow(() => 'Oops'), 2);
    expect(Nothing<int>().where((_) => _.isEven), isA<Nothing<int>>());
  });

  test('Default value', () {
    expect(Just(2).or(1), 2);
    expect(Nothing<int>().or(1), 1);
  });

  test('Cast', () {
    dynamic a = 2;
    expect(Just(a).type<int>(), isA<Just<int>>());
    expect(Just(a).type<String>(), isA<Nothing<String>>());
    expect(Just(a).type<int>().orThrow(() => 'Oops'), 2);
    a = null;
    expect(Just(a).type<int>(), isA<Nothing<int>>());
    expect(Just(a).type<bool>(), isA<Nothing<bool>>());
    expect(Nothing<int>().type<bool>(), isA<Nothing<bool>>());
  });

  test('Default value producer', () {
    expect(Just(2).orGet(() => 1), 2);
    expect(Nothing<int>().orGet(() => 1), 1);
  });

  test('Throwing exceptions', () {
    expect(() => Nothing<int>().orThrow(() => 'Oops'), throwsA('Oops'));
  });

  test('Consumers', () {
    void throwUp() {
      throw Exception();
    }

    int? number;
    void saveNumber(int n) => number = n;
    Nothing<int>().ifPresent(saveNumber);
    expect(number, isNull);
    Just(42).ifPresent(saveNumber);
    expect(number, 42);
    Just(42).ifNothing(throwUp);
    expect(() => Nothing<int>().ifNothing(throwUp), throwsException);
  });

  test('Fallback', () {
    expect(Nothing<int>().fallback(() => Just(2)).or(42), 2);
    expect(Just(1).fallback(() => Just(2)).or(42), 1);
  });

  test('Chain', () {
    expect(Nothing<int>().chain(Just(2)).or(42), 2);
    expect(Just(1).chain(Just(2)).or(42), 1);
  });

  test('As', () {
    expect(Just<Object>(2).as<int>().orThrow(() => 'oops'), isA<int>());
    expect(Nothing<Object>().as<int>().or(2), isA<int>());
  });

  test('Equality', () {
    dynamic d;
    d = 1;
    expect(Just(1) == Just(1), isTrue);
    expect(Just(1) == Just(2), isFalse);
    // ignore: unrelated_type_equality_checks
    expect(Just(1) == Nothing<int>(), isFalse);
    // ignore: unrelated_type_equality_checks
    expect(Just(1) == Nothing(), isFalse);
    // ignore: unrelated_type_equality_checks
    expect(Just(d) == Nothing(), isFalse);
    // ignore: unrelated_type_equality_checks
    expect(Nothing<int>() == Just(1), isFalse);
    // ignore: unrelated_type_equality_checks
    expect(Nothing() == Just(1), isFalse);
    expect(Nothing<int>() == Nothing<int>(), isTrue);
    expect(Nothing() == Nothing(), isTrue);
    expect(Nothing<int>() == Nothing(), isFalse);
    expect(Nothing() == Nothing<String>(), isFalse);
    // ignore: unrelated_type_equality_checks
    expect(Nothing() == Just(d), isFalse);

    int? a;
    String? b;
    // ignore: unrelated_type_equality_checks
    expect(Just(a) == Just(b), isFalse);
  });

  test('HashCode', () {
    dynamic d;
    d = 1;
    expect(Just(1).hashCode == Just(1).hashCode, isTrue);
    expect(Just(1).hashCode == Just(2).hashCode, isFalse);
    expect(Just(1).hashCode == Nothing<int>().hashCode, isFalse);
    expect(Just(1).hashCode == Nothing().hashCode, isFalse);
    expect(Just(d).hashCode == Nothing().hashCode, isFalse);
    expect(Nothing<int>().hashCode == Just(1).hashCode, isFalse);
    expect(Nothing().hashCode == Just(1).hashCode, isFalse);
    expect(Nothing<int>().hashCode == Nothing<int>().hashCode, isTrue);
    expect(Nothing().hashCode == Nothing().hashCode, isTrue);
    expect(Nothing<int>().hashCode == Nothing().hashCode, isFalse);
    expect(Nothing().hashCode == Nothing<String>().hashCode, isFalse);
    expect(Nothing().hashCode == Just(d).hashCode, isFalse);

    int? a;
    String? b;
    expect(Just(a).hashCode == Just(b).hashCode, isTrue);
  });
}
