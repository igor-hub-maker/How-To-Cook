import 'package:how_to_cook/models/category.dart';
import 'package:how_to_cook/models/meal.dart';

abstract class MealOfDayManager {
  Future<Meal> getMealOfDay();
  Future<Category> getCategoryOfDay();
}
