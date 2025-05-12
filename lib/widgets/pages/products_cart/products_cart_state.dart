import 'package:how_to_cook/models/product.dart';

class ProductsCartState {
  final bool isLoading;
  final String? error;
  final List<Product>? products;

  const ProductsCartState({
    this.isLoading = false,
    this.error,
    this.products,
  });

  ProductsCartState copyWith({
    bool? isLoading,
    String? error,
    List<Product>? products,
  }) {
    return ProductsCartState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      products: products ?? this.products,
    );
  }
}
