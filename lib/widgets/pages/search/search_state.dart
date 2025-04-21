import 'package:how_to_cook/models/area.dart';
import 'package:how_to_cook/models/category.dart';

class SearchState {
  final bool isLoading;
  final String? error;
  final List<Area>? areas;
  final List<Category>? categories;

  const SearchState({
    this.isLoading = false,
    this.error,
    this.areas,
    this.categories,
  });

  SearchState copyWith({
    bool? isLoading,
    String? error,
    List<Area>? areas,
    List<Category>? categories,
  }) {
    return SearchState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      areas: areas ?? this.areas,
      categories: categories ?? this.categories,
    );
  }
}
