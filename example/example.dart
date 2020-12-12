import 'package:maybe_just_nothing/maybe_just_nothing.dart';

Maybe<int> addTwoIntegers(dynamic a, dynamic b) =>
    Maybe(a).type<int>().merge(Maybe(b).type<int>(), (int a, int b) => a + b);

void main() {
  // Prints 42
  addTwoIntegers(40, 2).ifPresent(print);

  // Does nothing since one of the values is null.
  addTwoIntegers(40, null).ifPresent(print);

  // Does nothing since one of the values is not an integer.
  addTwoIntegers('Oops', 2).ifPresent(print);
}
