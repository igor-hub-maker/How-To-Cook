import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:how_to_cook/managers/meal/meal_manager.dart';
import 'package:how_to_cook/models/category.dart';
import 'package:how_to_cook/models/meal.dart';
import 'package:how_to_cook/widgets/pages/home/home_state.dart';
import 'package:injector/injector.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(const HomeState(isLoading: true));

  late final MealManager _mealManager;
  late final Meal meal;
  late final Category category;

  Future<void> loadInitialData(BuildContext context) async {
    final stableState = state;
    try {
      emit(state.copyWith(isLoading: true));
      await Future.delayed(const Duration(seconds: 1));

      final injector = Injector.appInstance;
      _mealManager = injector.get<MealManager>();

      await Future.wait([
        _mealManager.getRandomMeal(context.locale.languageCode).then(
              (meal) => this.meal = meal,
            ),
        _mealManager.getRandomCategory(context.locale.languageCode).then(
              (category) => this.category = category,
            ),
      ]);

      emit(state.copyWith(isLoading: false));
    } catch (error) {
      emit(state.copyWith(error: error.toString()));
      emit(stableState.copyWith(isLoading: false));
    }
  }
}
