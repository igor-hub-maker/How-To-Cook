import 'dart:math';

class Animations {
  static const animations = [
    "assets/animations/boiling-2.json",
    "assets/animations/boiling.json",
    "assets/animations/frying-2.json",
    "assets/animations/frying.json",
    "assets/animations/mixing.json"
  ];

  static String get getRandomAnimation => animations[Random().nextInt(animations.length)];
}
