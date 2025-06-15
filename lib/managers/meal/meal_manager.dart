import 'package:how_to_cook/common/enums/meal_filtering_type.dart';
import 'package:how_to_cook/models/area.dart';
import 'package:how_to_cook/models/meal.dart';
import 'package:how_to_cook/models/category.dart';
import 'package:how_to_cook/models/meal_short.dart';

abstract class MealManager {
  Future<Meal> getRandomMeal();

  Future<List<Category>> getAllCategories();

  Future<Category> getRandomCategory();

  Future<List<Area>> getAllAreas();

  // TODO: Implement this method when needed
  // Future<List<Ingredient>> getAllIngredients();

  Future<Meal> getMealDetails(String mealId);

  Future<List<MealShort>> getMealsByFilter(String filter, MealFilteringType mealFilteringType);

  Future<Meal> translateMeal(Meal meal, String locale);

  Future<Category> translateCategory(Category meal, String locale);

  Future<void> saveMealToLocalIfNeeded(Meal meal);

  Future<Meal?> getMealFromLocal(String mealId);

  Future<List<Meal>> getMealsFromLocal(List<String> mealIds);
}
