// DO NOT EDIT. This is code generated via package:easy_localization/generate.dart

// ignore_for_file: prefer_single_quotes, avoid_renaming_method_parameters

import 'dart:ui';

import 'package:easy_localization/easy_localization.dart' show AssetLoader;

class CodegenLoader extends AssetLoader{
  const CodegenLoader();

  @override
  Future<Map<String, dynamic>?> load(String path, Locale locale) {
    return Future.value(mapLocales[locale.toString()]);
  }

  static const Map<String,dynamic> de = {
  "MainPageTitle": "Was werden wir heute kochen?",
  "Ingredients": {
    "zero": "{} Zutaten",
    "one": "{} Zutat",
    "two": "{} Zutaten",
    "few": "{} Zutaten",
    "many": "{} Zutaten",
    "other": "{} Zutaten"
  }
};
static const Map<String,dynamic> uk = {
  "MainPageTitle": "Що приготуємо сьогодні?",
  "Ingredients": {
    "zero": "{} Інгредієнтів",
    "one": "{} Інгредієнт",
    "two": "{} Інгредієнти",
    "few": "{} Інгредієнтів",
    "many": "{} Інгредієнтів",
    "other": "{} Інгредієнтів"
  }
};
static const Map<String,dynamic> en = {
  "MainPageTitle": "What will we cook today?",
  "Ingredients": {
    "zero": "{} Ingredients",
    "one": "{} Ingredient",
    "two": "{} Ingredients",
    "few": "{} Ingredients",
    "many": "{} Ingredients",
    "other": "{} Ingredients"
  }
};
static const Map<String, Map<String,dynamic>> mapLocales = {"de": de, "uk": uk, "en": en};
}
