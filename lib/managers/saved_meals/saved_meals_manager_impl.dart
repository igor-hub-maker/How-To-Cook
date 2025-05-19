import 'package:how_to_cook/common/local_db_constants.dart';
import 'package:how_to_cook/common/rest/body_parameters.dart';
import 'package:how_to_cook/managers/saved_meals/saved_meals_manager.dart';
import 'package:how_to_cook/models/meal.dart';
import 'package:how_to_cook/services/local_db/local_db_service.dart';
import 'package:injector/injector.dart';

class SavedMealsManagerImpl implements SavedMealsManager {
  final LocalDbService localDbService = Injector.appInstance.get<LocalDbService>();

  @override
  Future<void> saveMeal(Meal meal) async {
    final isSaved = await checkIsMealSaved(meal.id);
    if (isSaved) {
      return Future.value();
    }

    await localDbService.db.insert(LocalDbConstants.SavedMeals, meal.toJson());
  }

  @override
  Future<void> removeMeal(String mealId) {
    return localDbService.db.delete(
      LocalDbConstants.SavedMeals,
      where: "${BodyParameters.idMeal} = ?",
      whereArgs: [mealId],
    );
  }

  @override
  Future<List<Meal>> getSavedMeals() async {
    final json = await localDbService.db.query(
      LocalDbConstants.SavedMeals,
    );

    return json.map((e) => Meal.fromJson(e)).toList();
  }

  @override
  Future<bool> checkIsMealSaved(String mealId) async {
    final json = await localDbService.db.query(
      LocalDbConstants.SavedMeals,
      where: "${BodyParameters.idMeal} = ?",
      whereArgs: [mealId],
    );

    return json.isNotEmpty;
  }
}
