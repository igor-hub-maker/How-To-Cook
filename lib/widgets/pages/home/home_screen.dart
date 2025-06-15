import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:how_to_cook/common/fonts.dart';
import 'package:how_to_cook/generated/locale_keys.g.dart';
import 'package:how_to_cook/widgets/pages/home/home_cubit.dart';
import 'package:how_to_cook/widgets/pages/home/home_state.dart';
import 'package:how_to_cook/widgets/views/%20category_item_view.dart';
import 'package:how_to_cook/widgets/views/loading_indicator.dart';
import 'package:how_to_cook/widgets/views/meal_item_view.dart';

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
    return FocusDetector(
      onFocusGained: () {
        if (!screenCubit.state.isLoading) {
          screenCubit.updateData();
        }
      },
      child: Scaffold(
        body: BlocConsumer<HomeCubit, HomeState>(
          bloc: screenCubit,
          listener: (BuildContext context, HomeState state) {
            if (state.error != null) {
              log(state.error.toString());
            }
          },
          builder: (BuildContext context, HomeState state) {
            if (state.isLoading) {
              return const LoadingIndicator();
            }

            return buildBody(state);
          },
        ),
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
          MealItemView(
            meal: state.meal!,
          ),
          const SizedBox(height: 20),
          CategoryItemView(
            category: state.category!,
          ),
          const SizedBox(height: 20),
          if (state.history != null && state.history!.isNotEmpty) ...[
            Text(
              LocaleKeys.RecentlyViewed.tr(),
              style: const TextStyle(
                fontFamily: Fonts.Comfortaa,
                fontWeight: FontWeight.w700,
                fontSize: 24,
              ),
            ),
            const SizedBox(height: 6),
          ],
          for (var meal in state.history ?? [])
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              child: MealItemView(
                meal: meal,
              ),
            ),
        ],
      ),
    );
  }
}
