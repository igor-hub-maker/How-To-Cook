import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:how_to_cook/common/enums/meal_filtering_type.dart';
import 'package:how_to_cook/common/fonts.dart';
import 'package:how_to_cook/generated/locale_keys.g.dart';
import 'package:how_to_cook/widgets/pages/filtered_meals/filtered_meals_cubit.dart';
import 'package:how_to_cook/widgets/pages/filtered_meals/filtered_meals_state.dart';
import 'package:how_to_cook/widgets/views/loading_indicator.dart';
import 'package:how_to_cook/widgets/views/meal_item_view.dart';

class FilteredMealsScreen extends StatefulWidget {
  const FilteredMealsScreen({
    super.key,
    required this.mealFilteringType,
    required this.filter,
    required this.name,
    this.description,
  });

  final String filter;
  final String name;
  final String? description;
  final MealFilteringType mealFilteringType;

  @override
  State<FilteredMealsScreen> createState() => _FilteredMealsScreenState();
}

class _FilteredMealsScreenState extends State<FilteredMealsScreen> {
  final screenCubit = FilteredMealsCubit();

  @override
  void initState() {
    screenCubit.loadInitialData(widget.filter, widget.mealFilteringType);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: BlocConsumer<FilteredMealsCubit, FilteredMealsState>(
        bloc: screenCubit,
        listener: (BuildContext context, FilteredMealsState state) {
          if (state.error != null) {
            log("filtered meals screen:", error: state.error.toString());
          }
        },
        builder: (BuildContext context, FilteredMealsState state) {
          if (state.isLoading) {
            return const LoadingIndicator();
          }

          return buildBody(state);
        },
      ),
    );
  }

  Widget buildBody(FilteredMealsState state) {
    return SafeArea(
      child: ListView(
        children: [
          if (widget.description != null)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                ),
              ),
              child: ExpandableText(
                widget.description!,
                style: const TextStyle(
                  fontFamily: Fonts.Comfortaa,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
                expandText: LocaleKeys.ReadMore.tr(),
                collapseText: LocaleKeys.ReadLess.tr(),
                animation: true,
                maxLines: 3,
              ),
            ),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            itemCount: state.meals?.length ?? 0,
            itemBuilder: (context, index) => MealItemView(
              meal: state.meals![index],
            ),
            separatorBuilder: (context, index) => const SizedBox(height: 16),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget buildAppBar() {
    return AppBar(
      centerTitle: false,
      title: Text(
        widget.name,
        style: const TextStyle(
          fontFamily: Fonts.Comfortaa,
          fontSize: 26,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
