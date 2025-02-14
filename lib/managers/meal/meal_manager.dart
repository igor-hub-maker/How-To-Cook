import 'package:how_to_cook/models/ingredient.dart';
import 'package:how_to_cook/models/meal.dart';
import 'package:how_to_cook/models/category.dart';

abstract class MealManager {
  Future<Meal> getRandomMeal([String? locale]);

  Future<List<Category>> getAllCategories([String? locale]);

  Future<Category> getRandomCategory([String? locale]);

  Future<List<String>> getAllAreas([String? locale]);

  Future<List<Ingredient>> getAllIngredients([String? locale]);
}
