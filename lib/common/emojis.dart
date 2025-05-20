import 'dart:math';

class Emojis {
  static const List<String> emojis = [
    "(⌐■_■)",
    "( •_•)",
    "( •_•)>",
    "凸(⊙▂⊙✖ )",
    "( ఠൠఠ )",
    "（ΦωΦ）",
    "(Θ︹Θ)ს",
    "⊙▂⊙",
  ];

  static String get getRandomEmoji {
    final randomIndex = Random().nextInt(emojis.length);
    return emojis[randomIndex];
  }
}
