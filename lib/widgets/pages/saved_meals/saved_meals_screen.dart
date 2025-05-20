import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:how_to_cook/common/app_colors.dart';
import 'package:how_to_cook/common/fonts.dart';
import 'package:how_to_cook/extensions/context_extension.dart';
import 'package:how_to_cook/models/meal.dart';
import 'package:how_to_cook/widgets/pages/saved_meals/saved_meals_cubit.dart';
import 'package:how_to_cook/widgets/pages/saved_meals/saved_meals_state.dart';
import 'package:how_to_cook/widgets/views/empty_state_view.dart';
import 'package:how_to_cook/widgets/views/expandable_search_button.dart';
import 'package:how_to_cook/widgets/views/meal_item_view.dart';

class SavedMealsScreen extends StatefulWidget {
  const SavedMealsScreen({Key? key}) : super(key: key);

  @override
  _SavedMealsScreenState createState() => _SavedMealsScreenState();
}

class _SavedMealsScreenState extends State<SavedMealsScreen> {
  final screenCubit = SavedMealsCubit();

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
      child: BlocConsumer<SavedMealsCubit, SavedMealsState>(
        bloc: screenCubit,
        listener: (BuildContext context, SavedMealsState state) {
          if (state.error != null) {
            log("ProductsCartScreen: ${state.error}");
          }
        },
        builder: (BuildContext context, SavedMealsState state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return Scaffold(
            appBar: buildAppBar(),
            body: buildBody(
              state,
            ),
          );
        },
      ),
    );
  }

  PreferredSizeWidget buildAppBar() {
    return AppBar(
      centerTitle: false,
      title: Text('Saved Meals'),
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
        ExpandableSearchButton(
            onChanged: (value) => setState(() {
                  filter = value;
                })),
        const SizedBox(width: 16),
      ],
    );
  }

  Widget buildBody(SavedMealsState state) {
    if (state.meals == null || state.meals!.isEmpty) {
      return const EmptyStateView(
        message: "No saved meals available",
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: state.meals?.length ?? 0,
      itemBuilder: (context, index) {
        final meal = state.meals![index];
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          child: buildMealItem(meal),
        );
      },
    );
  }

  Widget buildMealItem(Meal meal) {
    if (filter.isNotEmpty && !meal.name.toLowerCase().contains(filter.toLowerCase())) {
      return const SizedBox.shrink();
    }

    return MealItemView(
      meal: meal,
    );
  }
}
