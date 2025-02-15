import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:how_to_cook/managers/meal/meal_manager.dart';
import 'package:injector/injector.dart';

import 'meal_details_state.dart';

class MealDetailsCubit extends Cubit<MealDetailsState> {
  MealDetailsCubit() : super(const MealDetailsState(isLoading: true));

  Future<void> loadInitialData() async {
    late final MealManager mealManager;

    final stableState = state;
    try {
      emit(state.copyWith(isLoading: true));

      final injector = Injector.appInstance;

      emit(state.copyWith(isLoading: false));
      mealManager = injector.get<MealManager>();
    } catch (error) {
      emit(state.copyWith(error: error.toString()));
      emit(stableState.copyWith(isLoading: false));
    }
  }
}
