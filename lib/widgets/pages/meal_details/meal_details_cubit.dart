import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:how_to_cook/generated/locale_keys.g.dart';
import 'package:how_to_cook/managers/history/history_manager.dart';
import 'package:how_to_cook/managers/meal/meal_manager.dart';
import 'package:how_to_cook/managers/products_cart/products_cart_manager.dart';
import 'package:how_to_cook/managers/saved_meals/saved_meals_manager.dart';
import 'package:how_to_cook/models/meal.dart';
import 'package:how_to_cook/models/meal_short.dart';
import 'package:injector/injector.dart';

import 'meal_details_state.dart';

class MealDetailsCubit extends Cubit<MealDetailsState> {
  MealDetailsCubit() : super(const MealDetailsState(isLoading: true, isSaved: false));
  late final MealManager mealManager;
  late final HistoryManager historyManager;
  late final ProductsCartManager productsCartManager;
  late final SavedMealsManager savedMealsManager;

  Future<void> loadInitialData(MealShort meal) async {
    final stableState = state;
    try {
      emit(state.copyWith(isLoading: true));

      final injector = Injector.appInstance;
      mealManager = injector.get<MealManager>();
      historyManager = injector.get<HistoryManager>();
      productsCartManager = injector.get<ProductsCartManager>();
      savedMealsManager = injector.get<SavedMealsManager>();

      if (meal is! Meal) {
        meal = await mealManager.getMealDetails(meal.id);
      }

      historyManager.addToHistory(meal);
      final isSaved = await savedMealsManager.checkIsMealSaved(meal.id);

      emit(state.copyWith(isLoading: false, meal: meal, isSaved: isSaved));
    } catch (error) {
      emit(state.copyWith(error: error.toString()));
      emit(stableState.copyWith(isLoading: false));
    }
  }

  Future<void> addProductsToCart() async {
    await productsCartManager.addOrUpdateToCartFromMealIngredientMany(state.meal!.ingredients);
    Fluttertoast.showToast(msg: LocaleKeys.AddedToCart.tr(), toastLength: Toast.LENGTH_LONG);
  }

  Future<void> saveMeal() async {
    if (state.isSaved) {
      await savedMealsManager.removeMeal(state.meal!.id);

      emit(state.copyWith(isSaved: false));
      return;
    }

    await savedMealsManager.saveMeal(state.meal!);
    emit(state.copyWith(isSaved: true));
  }
}
