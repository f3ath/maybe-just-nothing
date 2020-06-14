import 'package:maybe_just_nothing/maybe_just_nothing.dart';
import 'package:test/test.dart';

void main() {
  test('Basic getters', () async {
    Maybe<int> oddTimes3(int number) =>
        Maybe(number).where((_) => _.isOdd).map((_) => _ * 3);

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

  test('Merge', () {
    expect(Just(2).merge(Just(3), (a, b) => a * b).orThrow(() => 'Oops'), 6);
    expect(Nothing<int>().merge(Just(3), (a, b) => a * b), isA<Nothing<num>>());
    expect(Just(2).merge(Nothing<int>(), (a, b) => a * b), isA<Nothing<num>>());
  });

  test('FlatMap', () {
    expect(Just(2).flatMap((_) => Maybe(_ * 2)).orThrow(() => 'Oops'), 4);
    expect(Nothing<int>().flatMap((_) => Maybe(_ * 2)), isA<Nothing<int>>());
  });

  test('Filtering', () {
    expect(Just(2).where((_) => _.isEven).orThrow(() => 'Oops'), 2);
    expect(Nothing<int>().where((_) => _.isEven), isA<Nothing<int>>());

    expect(Just(2).filter((_) => _.isEven).orThrow(() => 'Oops'), 2);
    expect(Nothing<int>().filter((_) => _.isEven), isA<Nothing<int>>());
  });

  test('Default value', () {
    expect(Just(2).or(1), 2);
    expect(Nothing<int>().or(1), 1);
  });

  test('Cast', () {
    dynamic a = 2;
    expect(Maybe(a).cast<int>(), isA<Just<int>>());
    expect(Maybe(a).cast<String>(), isA<Nothing<String>>());
    expect(Maybe(a).cast<int>().orThrow(() => 'Oops'), 2);
    a = null;
    expect(Maybe(a).cast<int>(), isA<Nothing<int>>());
    expect(Maybe(a).cast<bool>(), isA<Nothing<bool>>());
  });

  test('Default value producer', () {
    expect(Just(2).orGet(() => 1), 2);
    expect(Nothing<int>().orGet(() => 1), 1);
  });

  test('Throwing exceptions', () {
    expect(() => Nothing<int>().orThrow(() => 'Oops'), throwsA('Oops'));
  });

  test('Consumers', () {
    int number;
    void saveNumber(int n) => number = n;
    Nothing<int>().ifPresent(saveNumber);
    expect(number, isNull);
    Just(42).ifPresent(saveNumber);
    expect(number, 42);
  });

  test('Just(null) throws', () {
    expect(() => Just(null), throwsArgumentError);
  });
}
