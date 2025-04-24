import 'package:how_to_cook/models/category.dart';
import 'package:how_to_cook/models/meal.dart';

class HomeState {
  final bool isLoading;
  final String? error;
  final Meal? meal;
  final Category? category;
  final List<Meal>? history;

  const HomeState({
    this.isLoading = false,
    this.error,
    this.meal,
    this.category,
    this.history,
  });

  HomeState copyWith({
    bool? isLoading,
    String? error,
    Meal? meal,
    Category? category,
    List<Meal>? history,
  }) {
    return HomeState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      meal: meal ?? this.meal,
      category: category ?? this.category,
      history: history ?? this.history,
    );
  }
}
