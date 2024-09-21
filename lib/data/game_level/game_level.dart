import 'dart:math';

abstract class GameLevel {
  int maxTries();

  int maxRandomValue();

  int minRandomValue() => 1;

  // https://api.dart.dev/stable/3.5.3/dart-math/Random-class.html
  int getRandomNumber() => Random.secure().nextInt(maxRandomValue() + 1) + minRandomValue();
}