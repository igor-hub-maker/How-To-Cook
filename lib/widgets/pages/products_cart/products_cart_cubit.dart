import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:how_to_cook/managers/products_cart/products_cart_manager.dart';
import 'package:how_to_cook/models/product.dart';
import 'package:how_to_cook/widgets/pages/products_cart/products_cart_state.dart';
import 'package:injector/injector.dart';

class ProductsCartCubit extends Cubit<ProductsCartState> {
  ProductsCartCubit() : super(const ProductsCartState(isLoading: true));

  late final ProductsCartManager productsCartManager;

  Future<void> loadInitialData() async {
    final stableState = state;
    try {
      emit(state.copyWith(isLoading: true));

      final injector = Injector.appInstance;
      productsCartManager = injector.get<ProductsCartManager>();

      updateData(true);
    } catch (error) {
      emit(state.copyWith(error: error.toString()));
      emit(stableState.copyWith(isLoading: false));
    }
  }

  Future<void> updateData([bool showLoader = false]) async {
    emit(state.copyWith(isLoading: showLoader));

    final List<Product> products = await productsCartManager.getCartItems();

    emit(state.copyWith(isLoading: false, products: products));
  }

  Future<void> clearSelected() async {
    final selectedProducts =
        state.products?.where((product) => product.isMarked).map((product) => product.id!).toList();

    await productsCartManager.removeFromCartMany(selectedProducts ?? []);

    await updateData();
  }
}
