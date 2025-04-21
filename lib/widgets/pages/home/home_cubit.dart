import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:how_to_cook/managers/meal/meal_manager.dart';
import 'package:how_to_cook/managers/meal_of_day/meal_of_day_manager.dart';
import 'package:how_to_cook/models/category.dart';
import 'package:how_to_cook/models/meal.dart';
import 'package:how_to_cook/widgets/pages/home/home_state.dart';
import 'package:injector/injector.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(const HomeState(isLoading: true));

  late final MealManager _mealManager;
  late final MealOfDayManager _mealOfDayManager;

  Future<void> loadInitialData(BuildContext context) async {
    final stableState = state;
    try {
      emit(state.copyWith(isLoading: true));
      await Future.delayed(const Duration(seconds: 1));

      final injector = Injector.appInstance;
      _mealManager = injector.get<MealManager>();
      _mealOfDayManager = injector.get<MealOfDayManager>();

      final [meal, category] = await Future.wait([
        _mealOfDayManager.getMealOfDay(),
        _mealOfDayManager.getCategoryOfDay(),
      ]);

      emit(
        state.copyWith(
          isLoading: false,
          meal: meal as Meal,
          category: category as Category,
        ),
      );
    } catch (error) {
      emit(state.copyWith(error: error.toString()));
      emit(stableState.copyWith(isLoading: false));
    }
  }
}
