class MoreState {
	final bool isLoading;
	final String? error;
	  
	const MoreState({
		this.isLoading = false,
		this.error,
	});
	  
	MoreState copyWith({
		bool? isLoading,
		String? error,
	}) {
		return MoreState(
			isLoading: isLoading ?? this.isLoading,
			error: error ?? this.error,
		);
	}
}
