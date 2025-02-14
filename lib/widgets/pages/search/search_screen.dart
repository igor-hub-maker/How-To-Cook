import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:how_to_cook/common/app_colors.dart';
import 'package:how_to_cook/common/fonts.dart';
import 'package:how_to_cook/widgets/pages/search/items/list_item_component.dart';
import 'package:how_to_cook/widgets/pages/search/search_cubit.dart';
import 'package:how_to_cook/widgets/pages/search/search_state.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> with TickerProviderStateMixin {
  final screenCubit = SearchCubit();

  late final tabController = TabController(length: 3, vsync: this);

  @override
  void initState() {
    screenCubit.loadInitialData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SearchCubit, SearchState>(
      bloc: screenCubit,
      listener: (BuildContext context, SearchState state) {
        if (state.error != null) {
          log(state.error!);
        }
      },
      builder: (BuildContext context, SearchState state) {
        if (state.isLoading) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        return Scaffold(
          body: buildBody(state),
          appBar: buidAppBar(state),
        );
      },
    );
  }

  PreferredSizeWidget buidAppBar(SearchState state) {
    return AppBar(
      centerTitle: false,
      actionsIconTheme: IconThemeData(
        size: 30,
        color: AppColors.colorScheme.onSecondary,
      ),
      title: Text("Пошук"),
      titleTextStyle: TextStyle(
        fontFamily: Fonts.Comfortaa,
        fontSize: 32,
        fontWeight: FontWeight.w700,
        color: AppColors.colorScheme.primary,
      ),
      actions: [
        IconButton.filled(
          onPressed: () {},
          icon: const Icon(Icons.search),
        ),
        const SizedBox(
          width: 16,
        )
      ],
      bottom: TabBar(
        controller: tabController,
        tabs: [
          Tab(
            text: "Ingredient",
          ),
          Tab(
            text: "Category",
          ),
          Tab(
            text: "Area",
          ),
        ],
      ),
    );
  }

  Widget buildBody(SearchState state) {
    return TabBarView(controller: tabController, children: [
      ListView.builder(
        itemCount: state.ingredients?.length ?? 0,
        itemBuilder: (context, index) => ListItemComponent(
          title: state.ingredients![index].name,
          description: state.ingredients![index].description,
          type: state.ingredients![index].type,
        ),
      ),
      ListView.builder(
        itemCount: state.categories?.length ?? 0,
        itemBuilder: (context, index) => ListItemComponent(
          title: state.categories![index].name,
          description: state.categories![index].description,
        ),
      ),
      ListView.builder(
        itemCount: state.areas?.length ?? 0,
        itemBuilder: (context, index) => ListItemComponent(title: state.areas![index]),
      )
    ]);
  }
}
