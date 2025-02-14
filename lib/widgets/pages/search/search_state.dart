import 'package:how_to_cook/models/category.dart';
import 'package:how_to_cook/models/ingredient.dart';

class SearchState {
  final bool isLoading;
  final String? error;
  final List<String>? areas;
  final List<Category>? categories;
  final List<Ingredient>? ingredients;

  const SearchState({
    this.isLoading = false,
    this.error,
    this.areas,
    this.categories,
    this.ingredients,
  });

  SearchState copyWith({
    bool? isLoading,
    String? error,
    List<String>? areas,
    List<Category>? categories,
    List<Ingredient>? ingredients,
  }) {
    return SearchState(
        isLoading: isLoading ?? this.isLoading,
        error: error ?? this.error,
        areas: areas ?? this.areas,
        categories: categories ?? this.categories,
        ingredients: ingredients ?? this.ingredients);
  }
}
