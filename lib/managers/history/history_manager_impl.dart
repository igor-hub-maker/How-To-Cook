import 'package:how_to_cook/common/local_db_constants.dart';
import 'package:how_to_cook/common/rest/body_parameters.dart';
import 'package:how_to_cook/managers/history/history_manager.dart';
import 'package:how_to_cook/managers/meal/meal_manager.dart';
import 'package:how_to_cook/models/meal.dart';
import 'package:how_to_cook/services/local_db/local_db_service.dart';
import 'package:injector/injector.dart';

class HistoryManagerImpl implements HistoryManager {
  final injector = Injector.appInstance;
  late final LocalDbService _localDbService = injector.get<LocalDbService>();
  late final MealManager _mealManager = injector.get<MealManager>();

  @override
  Future<void> addToHistory(Meal meal) async {
    final history = await _localDbService.db.query(
      LocalDbConstants.MealsHistory,
      orderBy: "id DESC",
      limit: 1,
    );

    if (history.firstOrNull?[BodyParameters.idMeal] == meal.id) {
      return;
    }

    await _mealManager.saveMealToLocalIfNeeded(meal);

    await _localDbService.db.insert(
      LocalDbConstants.MealsHistory,
      {
        BodyParameters.idMeal: meal.id,
        BodyParameters.strMeal: meal.name,
      },
    );
  }

  @override
  Future<void> clearHistory() {
    return _localDbService.db.delete(LocalDbConstants.MealsHistory);
  }

  @override
  Future<List<Meal>> getHistory([int limit = 3]) async {
    final json = await _localDbService.db.query(
      LocalDbConstants.MealsHistory,
      orderBy: "id DESC",
      limit: limit,
    );

    final mealIds = json.map((e) => e[BodyParameters.idMeal].toString()).toList();
    final meals = await _mealManager.getMealsFromLocal(mealIds);

    meals.sort((a, b) {
      int indexA = mealIds.indexOf(a.id);
      int indexB = mealIds.indexOf(b.id);
      return indexA.compareTo(indexB);
    });

    return meals;
  }
}
