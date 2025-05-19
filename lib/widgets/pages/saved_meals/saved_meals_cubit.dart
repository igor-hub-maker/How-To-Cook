import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:how_to_cook/managers/saved_meals/saved_meals_manager.dart';
import 'package:how_to_cook/widgets/pages/saved_meals/saved_meals_state.dart';
import 'package:injector/injector.dart';

class SavedMealsCubit extends Cubit<SavedMealsState> {
  SavedMealsCubit() : super(const SavedMealsState(isLoading: true));

  late final SavedMealsManager savedMealsManager;

  Future<void> loadInitialData() async {
    final stableState = state;
    try {
      emit(state.copyWith(isLoading: true));

      final injector = Injector.appInstance;
      savedMealsManager = injector.get<SavedMealsManager>();

      await updateData();
      emit(state.copyWith(isLoading: false));
    } catch (error) {
      emit(state.copyWith(error: error.toString()));
      emit(stableState.copyWith(isLoading: false));
    }
  }

  Future<void> updateData([bool showLoader = false]) async {
    emit(state.copyWith(isLoading: showLoader));

    final meals = await savedMealsManager.getSavedMeals();

    emit(state.copyWith(isLoading: false, meals: meals));
  }
}
