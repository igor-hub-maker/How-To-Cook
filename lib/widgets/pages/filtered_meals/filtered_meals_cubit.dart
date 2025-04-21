import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:how_to_cook/common/enums/meal_filtering_type.dart';
import 'package:how_to_cook/managers/meal/meal_manager.dart';
import 'package:how_to_cook/models/meal_short.dart';
import 'package:how_to_cook/widgets/pages/filtered_meals/filtered_meals_state.dart';
import 'package:how_to_cook/widgets/pages/meal_details/meal_details_screen.dart';
import 'package:injector/injector.dart';

class FilteredMealsCubit extends Cubit<FilteredMealsState> {
  FilteredMealsCubit() : super(FilteredMealsState(isLoading: true));

  late final MealManager mealManager;

  Future<void> loadInitialData(String filter, MealFilteringType mealFilteringType) async {
    final stableState = state;
    try {
      emit(state.copyWith(isLoading: true));

      final injector = Injector.appInstance;
      mealManager = injector.get<MealManager>();

      final meals = await mealManager.getMealsByFilter(filter, mealFilteringType);

      emit(state.copyWith(isLoading: false, meals: meals));
    } catch (error) {
      emit(state.copyWith(error: error.toString()));
      emit(stableState.copyWith(isLoading: false));
    }
  }

  Future<void> openMealDetails(MealShort meal, BuildContext context) async {
    final mealDetails = await mealManager.getMealDetails(meal.id);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MealDetailsScreen(meal: mealDetails),
      ),
    );
  }
}
