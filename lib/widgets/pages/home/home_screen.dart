import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:how_to_cook/common/app_colors.dart';
import 'package:how_to_cook/common/fonts.dart';
import 'package:how_to_cook/generated/locale_keys.g.dart';
import 'package:how_to_cook/main.dart';
import 'package:how_to_cook/widgets/pages/home/home_cubit.dart';
import 'package:how_to_cook/widgets/pages/home/home_state.dart';
import 'package:how_to_cook/widgets/pages/home/items/item_view.dart';

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
              IconButton.filled(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Settings'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(
                          context.supportedLocales.length,
                          (index) {
                            final locale = context.supportedLocales[index];
                            return ListTile(
                              title: Text(locale.toLanguageTag()),
                              trailing: locale == context.locale ? const Icon(Icons.check) : null,
                              onTap: () {
                                context.setLocale(locale);
                                Navigator.pop(context);
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.settings_rounded),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ItemView(
            name: screenCubit.meal.name,
            count: screenCubit.meal.ingredients.length,
            tags: screenCubit.meal.tags,
            imageUrl: screenCubit.meal.imageUrl,
            country: screenCubit.meal.country,
          ),
          const SizedBox(height: 20),
          ItemView(
            name: screenCubit.category.name,
            imageUrl: screenCubit.category.imageUrl,
          ),
        ],
      ),
    );
  }
}
