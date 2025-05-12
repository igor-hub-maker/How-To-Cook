import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:how_to_cook/common/app_colors.dart';
import 'package:how_to_cook/extensions/context_extension.dart';
import 'package:how_to_cook/models/meal.dart';
import 'package:how_to_cook/widgets/pages/meal_details/meal_details_cubit.dart';
import 'package:world_flags/world_flags.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:how_to_cook/common/fonts.dart';
import 'package:how_to_cook/widgets/pages/meal_details/meal_details_state.dart';

class MealDetailsScreen extends StatefulWidget {
  const MealDetailsScreen({super.key, required this.meal});

  final Meal meal;

  @override
  _MealDetailsScreenState createState() => _MealDetailsScreenState();
}

class _MealDetailsScreenState extends State<MealDetailsScreen> with TickerProviderStateMixin {
  final screenCubit = MealDetailsCubit();

  late final WorldCountry? countryData;

  @override
  void initState() {
    countryData = WorldCountry.list
        .where((e) => e.demonyms.any((ee) => ee.male == widget.meal.country))
        .firstOrNull;

    screenCubit.loadInitialData(widget.meal);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MealDetailsCubit, MealDetailsState>(
      bloc: screenCubit,
      listener: (BuildContext context, MealDetailsState state) {
        if (state.error != null) {
          log(state.error!);
        }
      },
      builder: (BuildContext context, MealDetailsState state) {
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

  PreferredSizeWidget buidAppBar(MealDetailsState state) {
    return AppBar();
  }

  Widget buildBody(MealDetailsState state) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 20,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.colorScheme.secondaryContainer,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(
                        20,
                      ),
                    ),
                    border: Border.all(
                      color: AppColors.colorScheme.secondary,
                      width: 3,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(
                        16,
                      ),
                    ),
                    child: Image.network(
                      widget.meal.imageUrl,
                      height: 180,
                      width: double.maxFinite,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Flexible(
                            child: RichText(
                                text: TextSpan(
                              style: TextStyle(
                                fontFamily: Fonts.Comfortaa,
                                fontSize: 24,
                                fontWeight: FontWeight.w500,
                                color: context.isDarkMode ? Colors.white : Colors.black,
                              ),
                              children: [
                                if (countryData != null)
                                  WidgetSpan(
                                    alignment: PlaceholderAlignment.middle,
                                    child: CountryFlag.simplified(
                                      countryData!,
                                      aspectRatio: 16 / 9,
                                      height: 16,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ),
                                  ),
                                if (countryData != null) const TextSpan(text: " · "),
                                TextSpan(
                                  text: widget.meal.name,
                                ),
                              ],
                            )),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Flexible(
                            child: Text(
                              widget.meal.category,
                              style: TextStyle(
                                fontFamily: Fonts.Comfortaa,
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: context.isDarkMode ? Colors.white : Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        alignment: WrapAlignment.start,
                        runSpacing: 10,
                        spacing: 10,
                        children: List.generate(
                          widget.meal.tags?.length ?? 0,
                          (index) => Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 5,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.colorScheme.primary,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Text(
                              widget.meal.tags![index],
                              style: TextStyle(
                                fontFamily: Fonts.Comfortaa,
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: context.isDarkMode ? Colors.black : Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "${widget.meal.ingredients.length} Products",
                            style: const TextStyle(
                              fontFamily: Fonts.Comfortaa,
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          TextButton.icon(
                            onPressed: screenCubit.addProductsToCart,
                            label: Text("Add to cart"),
                            icon: const Icon(Icons.add_shopping_cart_rounded),
                            iconAlignment: IconAlignment.end,
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        alignment: WrapAlignment.start,
                        runSpacing: 10,
                        spacing: 10,
                        children: List.generate(
                          widget.meal.ingredients.length,
                          (index) => Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 5,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: context.isDarkMode ? Colors.grey : Colors.white,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.meal.ingredients[index].name,
                                  style: TextStyle(
                                    fontFamily: Fonts.Comfortaa,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: context.isDarkMode ? Colors.white : Colors.black,
                                  ),
                                ),
                                Text(
                                  widget.meal.ingredients[index].measure,
                                  style: TextStyle(
                                    fontFamily: Fonts.Comfortaa,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: context.isDarkMode ? Colors.white : Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (widget.meal.youtubeUrl != null) ...[
                        FilledButton.icon(
                          onPressed: () {
                            launchUrl(Uri.parse(widget.meal.youtubeUrl!));
                          },
                          label: const Text("Watch video"),
                          icon: const Icon(Icons.play_arrow),
                        ),
                        const SizedBox(height: 16),
                      ],
                      Text(
                        widget.meal.instructions,
                        style: TextStyle(
                          fontFamily: Fonts.Comfortaa,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: context.isDarkMode ? Colors.white : Colors.black,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
