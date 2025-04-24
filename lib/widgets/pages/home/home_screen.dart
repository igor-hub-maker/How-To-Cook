import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:how_to_cook/common/app_colors.dart';
import 'package:how_to_cook/common/enums/meal_filtering_type.dart';
import 'package:how_to_cook/common/fonts.dart';
import 'package:how_to_cook/generated/locale_keys.g.dart';
import 'package:how_to_cook/widgets/pages/filtered_meals/filtered_meals_cubit.dart';
import 'package:how_to_cook/widgets/pages/filtered_meals/filtered_meals_screen.dart';
import 'package:how_to_cook/widgets/pages/home/home_cubit.dart';
import 'package:how_to_cook/widgets/pages/home/home_state.dart';
import 'package:how_to_cook/widgets/views/%20category_item_view.dart';
import 'package:how_to_cook/widgets/views/meal_item_view.dart';
import 'package:how_to_cook/widgets/pages/meal_details/meal_details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final screenCubit = HomeCubit();

  @override
  void initState() {
    screenCubit.loadInitialData(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<HomeCubit, HomeState>(
        bloc: screenCubit,
        listener: (BuildContext context, HomeState state) {
          if (state.error != null) {
            log(state.error.toString());
          }
        },
        builder: (BuildContext context, HomeState state) {
          if (state.isLoading) {
            return Center(
              child: CircularProgressIndicator(
                color: AppColors.colorScheme.primary,
              ),
            );
          }

          return buildBody(state);
        },
      ),
    );
  }

  Widget buildBody(HomeState state) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  LocaleKeys.MainPageTitle.tr(),
                  style: const TextStyle(
                    fontFamily: Fonts.Comfortaa,
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              // TODO add localization
              // IconButton.filled(
              //   onPressed: () {
              //     showDialog(
              //       context: context,
              //       builder: (context) => AlertDialog(
              //         title: const Text('Settings'),
              //         content: Column(
              //           mainAxisSize: MainAxisSize.min,
              //           children: List.generate(
              //             context.supportedLocales.length,
              //             (index) {
              //               final locale = context.supportedLocales[index];
              //               return ListTile(
              //                 title: Text(locale.toLanguageTag()),
              //                 trailing: locale == context.locale ? const Icon(Icons.check) : null,
              //                 onTap: () {
              //                   context.setLocale(locale);
              //                   Navigator.pop(context);
              //                 },
              //               );
              //             },
              //           ),
              //         ),
              //       ),
              //     );
              //   },
              //   icon: const Icon(Icons.settings_rounded),
              // ),
            ],
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => MealDetailsScreen(
                  meal: state.meal!,
                ),
              ),
            ),
            child: MealItemView(
              meal: state.meal!,
            ),
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => FilteredMealsScreen(
                  filter: state.category!.originalName,
                  mealFilteringType: MealFilteringType.category,
                  name: state.category!.name,
                  description: state.category!.description,
                ),
              ),
            ),
            child: CategoryItemView(
              category: state.category!,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "Нещодавно переглянуте",
            style: TextStyle(
              fontFamily: Fonts.Comfortaa,
              fontWeight: FontWeight.w700,
              fontSize: 24,
            ),
          ),
          const SizedBox(height: 6),
          for (var meal in state.history ?? [])
            GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => MealDetailsScreen(
                    meal: meal,
                  ),
                ),
              ),
              child: Container(
                margin: const EdgeInsets.only(bottom: 10),
                child: MealItemView(
                  meal: meal,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
