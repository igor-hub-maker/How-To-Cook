import 'package:how_to_cook/common/local_db_constants.dart';
import 'package:how_to_cook/common/rest/body_parameters.dart';
import 'package:how_to_cook/managers/history/history_manager.dart';
import 'package:how_to_cook/models/meal.dart';
import 'package:how_to_cook/services/local_db/local_db_service.dart';
import 'package:injector/injector.dart';

class HistoryManagerImpl implements HistoryManager {
  late final LocalDbService _localDbService = Injector.appInstance.get<LocalDbService>();

  @override
  Future<void> addToHistory(Meal meal) async {
    final history = await _localDbService.db.query(
      LocalDbConstants.MealsHistoryTable,
      orderBy: "id DESC",
      limit: 1,
    );
    if (history.firstOrNull?[BodyParameters.idMeal] == meal.id) {
      return;
    }

    await _localDbService.db.insert(LocalDbConstants.MealsHistoryTable, meal.toJson());
  }

  @override
  Future<void> clearHistory() {
    return _localDbService.db.delete(LocalDbConstants.MealsHistoryTable);
  }

  @override
  Future<List<Meal>> getHistory([int limit = 3]) async {
    final json = await _localDbService.db.query(
      LocalDbConstants.MealsHistoryTable,
      orderBy: "id DESC",
      limit: limit,
    );

    final meals = json.map((e) => Meal.fromJson(e)).toList();
    return meals;
  }
}
