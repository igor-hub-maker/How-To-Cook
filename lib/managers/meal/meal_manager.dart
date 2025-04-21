import 'package:how_to_cook/common/enums/meal_filtering_type.dart';
import 'package:how_to_cook/models/area.dart';
import 'package:how_to_cook/models/ingredient.dart';
import 'package:how_to_cook/models/meal.dart';
import 'package:how_to_cook/models/category.dart';
import 'package:how_to_cook/models/meal_short.dart';

abstract class MealManager {
  Future<Meal> getRandomMeal([String? locale]);

  Future<List<Category>> getAllCategories([String? locale]);

  Future<Category> getRandomCategory([String? locale]);

  Future<List<Area>> getAllAreas([String? locale]);

  Future<List<Ingredient>> getAllIngredients([String? locale]);

  Future<Meal> getMealDetails(
    String mealId, [
    String? locale,
  ]);

  Future<List<MealShort>> getMealsByFilter(
    String filter,
    MealFilteringType mealFilteringType, [
    String? locale,
  ]);
}
