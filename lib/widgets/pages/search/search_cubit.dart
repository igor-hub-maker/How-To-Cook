import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:how_to_cook/managers/meal/meal_manager.dart';
import 'package:how_to_cook/models/category.dart';
import 'package:how_to_cook/models/ingredient.dart';
import 'package:how_to_cook/widgets/pages/search/search_state.dart';
import 'package:injector/injector.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit() : super(SearchState(isLoading: true));

  Future<void> loadInitialData() async {
    late final MealManager mealManager;

    final stableState = state;
    try {
      emit(state.copyWith(isLoading: true));

      final injector = Injector.appInstance;
      mealManager = injector.get<MealManager>();

      final [areas, categories, ingredients] = await Future.wait([
        mealManager.getAllAreas(),
        mealManager.getAllCategories(),
        mealManager.getAllIngredients()
      ]);

      emit(state.copyWith(
        isLoading: false,
        areas: areas as List<String>,
        categories: categories as List<Category>,
        ingredients: ingredients as List<Ingredient>,
      ));
    } catch (error) {
      emit(state.copyWith(error: error.toString()));
      emit(stableState.copyWith(isLoading: false));
    }
  }
}
