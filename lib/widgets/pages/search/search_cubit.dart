import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:how_to_cook/managers/meal/meal_manager.dart';
import 'package:how_to_cook/models/area.dart';
import 'package:how_to_cook/models/category.dart';
import 'package:how_to_cook/widgets/pages/search/search_state.dart';
import 'package:injector/injector.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit() : super(const SearchState(isLoading: true));

  Future<void> loadInitialData(BuildContext context) async {
    late final MealManager mealManager;

    final stableState = state;
    try {
      emit(state.copyWith(isLoading: true));
      await Future.delayed(const Duration(seconds: 1));

      final injector = Injector.appInstance;
      mealManager = injector.get<MealManager>();

      final categories = await mealManager.getAllCategories();
      await Future.delayed(Durations.medium1);
      final areas = await mealManager.getAllAreas();

      emit(state.copyWith(
        isLoading: false,
        areas: areas,
        categories: categories,
      ));
    } catch (error) {
      emit(state.copyWith(error: error.toString()));
      emit(stableState.copyWith(isLoading: false));
    }
  }
}
