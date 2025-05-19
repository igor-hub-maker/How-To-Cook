import 'package:how_to_cook/models/meal.dart';

class MealDetailsState {
  final bool isLoading;
  final bool isSaved;
  final String? error;
  final Meal? meal;

  const MealDetailsState({
    this.isLoading = false,
    required this.isSaved,
    this.error,
    this.meal,
  });

  MealDetailsState copyWith({
    bool? isLoading,
    bool? isSaved,
    String? error,
    Meal? meal,
  }) {
    return MealDetailsState(
      isLoading: isLoading ?? this.isLoading,
      isSaved: isSaved ?? this.isSaved,
      error: error ?? this.error,
      meal: meal ?? this.meal,
    );
  }
}
