import 'package:how_to_cook/managers/history/history_manager.dart';
import 'package:how_to_cook/managers/history/history_manager_impl.dart';
import 'package:how_to_cook/managers/meal/meal_manager.dart';
import 'package:how_to_cook/managers/meal/meal_manager_impl.dart';
import 'package:how_to_cook/managers/meal_of_day/meal_of_day_manager.dart';
import 'package:how_to_cook/managers/meal_of_day/meal_of_day_manager_impl.dart';
import 'package:how_to_cook/managers/products_cart/products_cart_manager.dart';
import 'package:how_to_cook/managers/products_cart/products_cart_manager_impl.dart';
import 'package:how_to_cook/managers/saved_meals/saved_meals_manager.dart';
import 'package:how_to_cook/managers/saved_meals/saved_meals_manager_impl.dart';
import 'package:how_to_cook/services/local_db/local_db_service.dart';
import 'package:how_to_cook/services/local_db/local_db_service_impl.dart';
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
    injector.registerSingleton<LocalDbService>(() => LocalDbServiceImpl());
  }

  static void registerManagers() {
    injector.registerDependency<MealManager>(() => MealManagerImpl());
    injector.registerDependency<MealOfDayManager>(() => MealOfDayManagerImpl());
    injector.registerDependency<HistoryManager>(() => HistoryManagerImpl());
    injector.registerDependency<ProductsCartManager>(() => ProductsCartManagerImpl());
    injector.registerDependency<SavedMealsManager>(() => SavedMealsManagerImpl());
  }

  static void registerProviders() {}
}
