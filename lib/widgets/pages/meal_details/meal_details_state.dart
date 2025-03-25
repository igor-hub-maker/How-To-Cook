class MealDetailsState {
  final bool isLoading;
  final String? error;

  const MealDetailsState({
    this.isLoading = false,
    this.error,
  });

  MealDetailsState copyWith({
    bool? isLoading,
    String? error,
  }) {
    return MealDetailsState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}
