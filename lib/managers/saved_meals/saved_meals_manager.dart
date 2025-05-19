import 'package:how_to_cook/models/meal.dart';

abstract class SavedMealsManager {
  Future<void> saveMeal(Meal meal);

  Future<void> removeMeal(String mealId);

  Future<bool> checkIsMealSaved(String mealId);

  Future<List<Meal>> getSavedMeals();
}
