import 'package:maybe_just_nothing/maybe_just_nothing.dart';

Maybe<int> oddTimes3(int number) =>
    Maybe(number).filter((_) => _.isOdd).map((_) => _ * 3);

void main() {
  oddTimes3(5).ifPresent(print); // Prints 15
  oddTimes3(2).ifPresent(print); // Does nothing
}
