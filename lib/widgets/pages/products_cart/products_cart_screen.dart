import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:how_to_cook/common/app_colors.dart';
import 'package:how_to_cook/common/fonts.dart';
import 'package:how_to_cook/extensions/context_extension.dart';
import 'package:how_to_cook/models/product.dart';
import 'package:how_to_cook/widgets/pages/products_cart/items/product_cart_item_component.dart';
import 'package:how_to_cook/widgets/pages/products_cart/products_cart_cubit.dart';
import 'package:how_to_cook/widgets/pages/products_cart/products_cart_state.dart';
import 'package:how_to_cook/widgets/views/expandable_search_button.dart';

class ProductsCartScreen extends StatefulWidget {
  const ProductsCartScreen({Key? key}) : super(key: key);

  @override
  _ProductsCartScreenState createState() => _ProductsCartScreenState();
}

class _ProductsCartScreenState extends State<ProductsCartScreen> {
  final screenCubit = ProductsCartCubit();

  String filter = "";

  @override
  void initState() {
    screenCubit.loadInitialData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FocusDetector(
      onFocusGained: () {
        if (!screenCubit.state.isLoading) {
          screenCubit.updateData();
        }
      },
      child: BlocConsumer<ProductsCartCubit, ProductsCartState>(
        bloc: screenCubit,
        listener: (BuildContext context, ProductsCartState state) {
          if (state.error != null) {
            log("ProductsCartScreen: ${state.error}");
          }
        },
        builder: (BuildContext context, ProductsCartState state) {
          final containsSelectedItems =
              screenCubit.state.products?.any((product) => product.isMarked);

          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return Scaffold(
            appBar: buildAppBar(),
            floatingActionButton: buildFloatingActionButton(containsSelectedItems ?? false),
            body: buildBody(state, containsSelectedItems ?? false),
          );
        },
      ),
    );
  }

  Widget? buildFloatingActionButton(bool containsSelectedItems) {
    if (!containsSelectedItems) {
      return null;
    }

    return FloatingActionButton(
      onPressed: onFloatingButtonTap,
      backgroundColor: AppColors.colorScheme.primary,
      child: const Icon(Icons.delete_forever_rounded, size: 30),
    );
  }

  PreferredSizeWidget buildAppBar() {
    return AppBar(
      centerTitle: false,
      title: Text('Products Cart'),
      titleTextStyle: TextStyle(
        fontFamily: Fonts.Comfortaa,
        fontSize: 32,
        fontWeight: FontWeight.w700,
        color: AppColors.colorScheme.primary,
      ),
      actionsIconTheme: IconThemeData(
        size: 30,
        color: AppColors.colorScheme.onSecondary,
      ),
      actions: [
        ExpandableSearchButton(onChanged: (filterChanged) {
          setState(() {
            filter = filterChanged;
          });
        }),
        const SizedBox(width: 16),
      ],
    );
  }

  Widget buildBody(ProductsCartState state, bool containsSelectedItems) {
    return ListView(
      children: [
        ListView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: List.generate(
            state.products?.length ?? 0,
            (index) => buildCartItem(state.products![index], false),
          ),
        ),
        AnimatedOpacity(
          opacity: containsSelectedItems ? 1 : 0,
          duration: Durations.short3,
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Divider(),
          ),
        ),
        ListView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: List.generate(
            state.products?.length ?? 0,
            (index) => buildCartItem(state.products![index], true),
          ),
        ),
        if (containsSelectedItems) const SizedBox(height: 100),
      ],
    );
  }

  Widget buildCartItem(Product product, bool markedValueToShow) {
    if (filter.isNotEmpty && !product.name.toLowerCase().contains(filter.toLowerCase())) {
      return const SizedBox.shrink();
    }

    return ProductCartItemComponent(
      product: product,
      onItemMarked: (product) => onItemMarked(product),
      markedValueToShow: markedValueToShow,
    );
  }

  Future<void> onItemMarked(Product product) async {
    await screenCubit.productsCartManager.markCartItem(product.id!, product.isMarked);
    setState(() {});
  }

  void onFloatingButtonTap() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Are you sure you want to delete all selected items?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              screenCubit.clearSelected();
              Navigator.pop(context);
            },
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }
}
