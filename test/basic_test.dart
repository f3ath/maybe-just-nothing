import 'package:maybe_just_nothing/maybe_just_nothing.dart';
import 'package:test/test.dart';

void main() {
  test('Basic use cases', () {
    Maybe<int> oddTimes3(int number) =>
        Maybe(number).filter((_) => _.isOdd).map((_) => _ * 3);

    expect(oddTimes3(5).orThrow(() => 'Oops'), 15);
    expect(oddTimes3(null).or(100), 100);
    expect(oddTimes3(2).orGet(() => 100), 100);
  });

  test('Mapping', () {
    expect(Just(2).map((_) => _ * 2).orThrow(() => 'Oops'), 4);
    expect(Nothing<int>().map((_) => _ * 2), isA<Nothing<int>>());
  });

  test('Filtering', () {
    expect(Just(2).filter((_) => _.isEven).orThrow(() => 'Oops'), 2);
    expect(Nothing<int>().filter((_) => _.isEven), isA<Nothing<int>>());
  });

  test('Default value', () {
    expect(Just(2).or(1), 2);
    expect(Nothing<int>().or(1), 1);
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
