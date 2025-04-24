import 'package:how_to_cook/models/meal.dart';

abstract class HistoryManager {
  Future<void> addToHistory(Meal meal);

  Future<List<Meal>> getHistory([int limit = 3]);

  Future<void> clearHistory();
}
