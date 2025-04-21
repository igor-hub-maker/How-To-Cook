import 'package:how_to_cook/managers/meal/meal_manager.dart';
import 'package:how_to_cook/managers/meal/meal_manager_impl.dart';
import 'package:how_to_cook/managers/meal_of_day/meal_of_day_manager.dart';
import 'package:how_to_cook/managers/meal_of_day/meal_of_day_manager_impl.dart';
import 'package:how_to_cook/services/meal_db/meal_db_service.dart';
import 'package:how_to_cook/services/meal_db/meal_db_service_impl.dart';
import 'package:how_to_cook/services/shared_preferences/shared_preferences_service.dart';
import 'package:how_to_cook/services/shared_preferences/shared_preferences_service_imp.dart';
import 'package:injector/injector.dart';

class CompositionRoot {
  static final injector = Injector.appInstance;

  static void initialize() {
    registerServices();
    registerManagers();
    registerProviders();
  }

  static void registerServices() {
    injector.registerDependency<SharedPreferencesService>(() => SharedPreferencesServiceImpl());
    injector.registerDependency<MealDbService>(() => MealDbServiceImpl());
  }

  static void registerManagers() {
    injector.registerDependency<MealManager>(() => MealManagerImpl());
    injector.registerDependency<MealOfDayManager>(() => MealOfDayManagerImpl());
  }

  static void registerProviders() {}
}
