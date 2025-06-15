import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:how_to_cook/common/app_colors.dart';
import 'package:how_to_cook/common/enums/meal_filtering_type.dart';
import 'package:how_to_cook/common/fonts.dart';
import 'package:how_to_cook/generated/locale_keys.g.dart';
import 'package:how_to_cook/widgets/pages/filtered_meals/filtered_meals_screen.dart';
import 'package:how_to_cook/widgets/pages/search/items/list_item_component.dart';
import 'package:how_to_cook/widgets/pages/search/search_cubit.dart';
import 'package:how_to_cook/widgets/pages/search/search_state.dart';
import 'package:how_to_cook/widgets/views/loading_indicator.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> with TickerProviderStateMixin {
  final screenCubit = SearchCubit();
  // final searchController = TextEditingController();

  late final tabController = TabController(length: 2, vsync: this);

  late String currentLocale = context.locale.toString();

  // bool isSearchExpanded = false;

  @override
  void initState() {
    screenCubit.loadInitialData(context);
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    // searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FocusDetector(
      onFocusGained: () {
        final newLocale = context.locale.toString();
        if (currentLocale == newLocale) {
          return;
        }
        log('SearchScreen onFocusGained');
      },
      child: BlocConsumer<SearchCubit, SearchState>(
        bloc: screenCubit,
        listener: (BuildContext context, SearchState state) {
          if (state.error != null) {
            log(state.error!);
          }
        },
        builder: (BuildContext context, SearchState state) {
          if (state.isLoading) {
            return const Scaffold(body: LoadingIndicator());
          }

          return Scaffold(
            body: buildBody(state),
            appBar: buildAppBar(state),
          );
        },
      ),
    );
  }

  PreferredSizeWidget buildAppBar(SearchState state) {
    return AppBar(
      centerTitle: false,
      actionsIconTheme: IconThemeData(
        size: 30,
        color: AppColors.colorScheme.onSecondary,
      ),
      title: Text(LocaleKeys.Search.tr()),
      titleTextStyle: TextStyle(
        fontFamily: Fonts.Comfortaa,
        fontSize: 32,
        fontWeight: FontWeight.w700,
        color: AppColors.colorScheme.primary,
      ),
      // TODO add searching
      // actions: [
      //   AnimatedContainer(
      //     duration: const Duration(milliseconds: 300),
      //     width: isSearchExpanded ? context.screenWidth - 40 : 48,
      //     child: Stack(
      //       alignment: Alignment.centerRight,
      //       children: [
      //         TextField(
      //           controller: searchController,
      //           decoration: InputDecoration(
      //             filled: true,
      //             contentPadding: const EdgeInsets.only(left: 16),
      //             constraints: const BoxConstraints(maxHeight: 48),
      //             suffixIcon: Padding(
      //               padding: const EdgeInsets.only(right: 50),
      //               child: IconButton(
      //                 onPressed: () {
      //                   if (searchController.text.isNotEmpty) {
      //                     searchController.clear();
      //                     return;
      //                   }

      //                   setState(() {
      //                     isSearchExpanded = false;
      //                   });
      //                   FocusScope.of(context).unfocus();
      //                 },
      //                 icon: const Icon(Icons.close),
      //               ),
      //             ),
      //             hintText: "Search",
      //             hintStyle: const TextStyle(
      //               fontFamily: Fonts.Comfortaa,
      //               fontSize: 16,
      //               fontWeight: FontWeight.w400,
      //             ),
      //             border: OutlineInputBorder(
      //               borderRadius: BorderRadius.circular(100),
      //               borderSide: BorderSide(
      //                 color: AppColors.colorScheme.onSecondary,
      //                 width: 1,
      //               ),
      //             ),
      //           ),
      //         ),
      //         IconButton.filled(
      //           onPressed: () {
      //             if (isSearchExpanded) {
      //               log("message");
      //             } else {
      //               setState(() {
      //                 isSearchExpanded = !isSearchExpanded;
      //               });
      //             }
      //           },
      //           icon: const Icon(Icons.search),
      //         ),
      //       ],
      //     ),
      //   ),
      //   const SizedBox(
      //     width: 16,
      //   )
      // ],
      bottom: TabBar(
        controller: tabController,
        tabs: [
          Tab(
            text: LocaleKeys.Category.tr(),
          ),
          Tab(
            text: LocaleKeys.Area.tr(),
          ),
        ],
      ),
    );
  }

  Widget buildBody(SearchState state) {
    return TabBarView(controller: tabController, children: [
      buildCategories(state),
      buildAreas(state),
    ]);
  }

  Widget buildCategories(SearchState state) {
    return ListView.builder(
      itemCount: state.categories?.length ?? 0,
      itemBuilder: (context, index) => ListItemComponent(
        title: state.categories![index].name,
        description: state.categories![index].description,
        image: state.categories![index].imageUrl,
        openBuilder: (context, action) => FilteredMealsScreen(
          mealFilteringType: MealFilteringType.category,
          filter: state.categories![index].originalName,
          name: state.categories![index].name,
          description: state.categories![index].description,
        ),
      ),
    );
  }

  Widget buildAreas(SearchState state) {
    return ListView.builder(
      itemCount: state.areas?.length ?? 0,
      itemBuilder: (context, index) => ListItemComponent(
        title: state.areas![index].localizedName,
        openBuilder: (context, action) => FilteredMealsScreen(
          mealFilteringType: MealFilteringType.area,
          filter: state.areas![index].name,
          name: state.areas![index].localizedName,
        ),
      ),
    );
  }
}
