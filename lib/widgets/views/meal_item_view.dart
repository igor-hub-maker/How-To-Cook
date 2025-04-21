import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:how_to_cook/common/app_colors.dart';
import 'package:how_to_cook/common/fonts.dart';
import 'package:how_to_cook/generated/locale_keys.g.dart';
import 'package:how_to_cook/models/meal.dart';
import 'package:how_to_cook/models/meal_short.dart';
import 'package:world_flags/world_flags.dart';

class MealItemView extends StatelessWidget {
  const MealItemView({
    super.key,
    required this.meal,
  });

  final MealShort meal;

  @override
  Widget build(BuildContext context) {
    Meal? mealDetailed = meal is Meal ? meal as Meal : null;

    final countryData = mealDetailed != null
        ? WorldCountry.list
            .where((e) => e.demonyms.any((ee) => ee.male == mealDetailed.country))
            .firstOrNull
        : null;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: DecorationImage(
          image: NetworkImage(meal.imageUrl),
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
                  child: RichText(
                      text: TextSpan(
                    style: const TextStyle(
                      fontFamily: Fonts.Comfortaa,
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                    children: [
                      if (countryData != null)
                        WidgetSpan(
                          alignment: PlaceholderAlignment.middle,
                          child: CountryFlag.simplified(
                            countryData,
                            aspectRatio: 16 / 9,
                            height: 16,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      if (countryData != null) const TextSpan(text: " · "),
                      TextSpan(
                        text: meal.name,
                      ),
                    ],
                  )),
                ),
              ],
            ),
            const SizedBox(height: 10),
            if (mealDetailed != null)
              Row(
                children: [
                  Text(
                    plural(LocaleKeys.Ingredients, mealDetailed.ingredients.length),
                    style: const TextStyle(
                      fontFamily: Fonts.Comfortaa,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            if (mealDetailed?.tags != null) ...[
              const SizedBox(height: 10),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: List.generate(
                  mealDetailed!.tags?.length ?? 0,
                  (index) => Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      mealDetailed.tags![index],
                      style: const TextStyle(
                        fontFamily: Fonts.Comfortaa,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
