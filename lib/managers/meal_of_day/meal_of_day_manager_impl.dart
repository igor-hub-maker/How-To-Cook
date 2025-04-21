import 'dart:convert';

import 'package:how_to_cook/managers/meal/meal_manager.dart';
import 'package:how_to_cook/managers/meal_of_day/meal_of_day_manager.dart';
import 'package:how_to_cook/models/category.dart';
import 'package:how_to_cook/models/meal.dart';
import 'package:how_to_cook/services/shared_preferences/shared_preferences_service.dart';
import 'package:injector/injector.dart';

class MealOfDayManagerImpl implements MealOfDayManager {
  static const _categoryOfDayKey = 'categoryOfDay';
  static const _mealOfDayKey = 'mealOfDay';
  static const _updateDateKey = 'mealOfDayKey';

  final injector = Injector.appInstance;

  late final MealManager mealManager = injector.get<MealManager>();
  late final SharedPreferencesService sharedPreferencesService =
      injector.get<SharedPreferencesService>();

  @override
  Future<Category> getCategoryOfDay() async {
    await updateDataIfNeeded();

    final categoryString = await sharedPreferencesService.getString(_categoryOfDayKey);
    final categoryMap = jsonDecode(categoryString!) as Map<String, dynamic>;

    return Category.fromJson(categoryMap);
  }

  @override
  Future<Meal> getMealOfDay() async {
    await updateDataIfNeeded();

    final mealString = await sharedPreferencesService.getString(_mealOfDayKey);
    final mealMap = jsonDecode(mealString!) as Map<String, dynamic>;

    return Meal.fromJson(mealMap);
  }

  Future<void> updateDataIfNeeded() async {
    final now = DateTime.now();
    final lastUpdateDate = await sharedPreferencesService.getString(_updateDateKey);
    if (lastUpdateDate == null || DateTime.parse(lastUpdateDate).day != now.day) {
      await updateData();
      sharedPreferencesService.setString(_updateDateKey, now.toIso8601String());
    }
  }

  Future<void> updateData() async {
    final category = await mealManager.getRandomCategory();
    final meal = await mealManager.getRandomMeal();
    await sharedPreferencesService.setString(_categoryOfDayKey, jsonEncode(category.toJson()));
    await sharedPreferencesService.setString(_mealOfDayKey, jsonEncode(meal.toJson()));
  }
}
