import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:how_to_cook/common/app_colors.dart';
import 'package:how_to_cook/common/enums/meal_filtering_type.dart';
import 'package:how_to_cook/common/fonts.dart';
import 'package:how_to_cook/models/category.dart';
import 'package:how_to_cook/widgets/pages/filtered_meals/filtered_meals_screen.dart';

class CategoryItemView extends StatelessWidget {
  const CategoryItemView({super.key, required this.category});

  final Category category;

  @override
  Widget build(BuildContext context) {
    return OpenContainer(
      openBuilder: (context, action) => FilteredMealsScreen(
        mealFilteringType: MealFilteringType.category,
        filter: category.originalName,
        name: category.name,
        description: category.description,
      ),
      openColor: Colors.transparent,
      closedElevation: 0,
      closedShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      closedBuilder: (context, action) => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: DecorationImage(
            image: NetworkImage(category.imageUrl),
            fit: BoxFit.cover,
          ),
          border: Border.all(
            color: AppColors.colorScheme.primary,
            width: 5,
          ),
        ),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: LinearGradient(
              colors: [
                AppColors.colorScheme.primary.withOpacity(0.8),
                Colors.transparent,
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: Text(
                      category.name,
                      style: const TextStyle(
                        fontFamily: Fonts.Comfortaa,
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
