import 'package:how_to_cook/models/meal.dart';

class MealDetailsState {
  final bool isLoading;
  final String? error;
  final Meal? meal;

  const MealDetailsState({
    this.isLoading = false,
    this.error,
    this.meal,
  });

  MealDetailsState copyWith({
    bool? isLoading,
    String? error,
    Meal? meal,
  }) {
    return MealDetailsState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      meal: meal ?? this.meal,
    );
  }
}
