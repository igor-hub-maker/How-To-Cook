import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:how_to_cook/managers/history/history_manager.dart';
import 'package:how_to_cook/managers/meal/meal_manager.dart';
import 'package:how_to_cook/models/meal.dart';
import 'package:injector/injector.dart';

import 'meal_details_state.dart';

class MealDetailsCubit extends Cubit<MealDetailsState> {
  MealDetailsCubit() : super(const MealDetailsState(isLoading: true));

  Future<void> loadInitialData(Meal meal) async {
    late final MealManager mealManager;
    late final HistoryManager historyManager;

    final stableState = state;
    try {
      emit(state.copyWith(isLoading: true));

      final injector = Injector.appInstance;
      mealManager = injector.get<MealManager>();
      historyManager = injector.get<HistoryManager>();

      historyManager.addToHistory(meal);

      emit(state.copyWith(isLoading: false));
    } catch (error) {
      emit(state.copyWith(error: error.toString()));
      emit(stableState.copyWith(isLoading: false));
    }
  }
}
