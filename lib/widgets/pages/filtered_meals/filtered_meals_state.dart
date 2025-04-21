import 'package:how_to_cook/models/meal_short.dart';

class FilteredMealsState {
  final bool isLoading;
  final String? error;
  final List<MealShort>? meals;

  const FilteredMealsState({
    this.isLoading = false,
    this.error,
    this.meals,
  });

  FilteredMealsState copyWith({
    bool? isLoading,
    String? error,
    List<MealShort>? meals,
  }) {
    return FilteredMealsState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      meals: meals ?? this.meals,
    );
  }
}
