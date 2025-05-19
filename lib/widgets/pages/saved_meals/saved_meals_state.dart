import 'package:how_to_cook/models/meal.dart';

class SavedMealsState {
  final bool isLoading;
  final String? error;
  final List<Meal>? meals;

  const SavedMealsState({
    this.isLoading = false,
    this.error,
    this.meals,
  });

  SavedMealsState copyWith({
    bool? isLoading,
    String? error,
    List<Meal>? meals,
  }) {
    return SavedMealsState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      meals: meals ?? this.meals,
    );
  }
}
