import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:how_to_cook/common/app_colors.dart';
import 'package:how_to_cook/common/fonts.dart';
import 'package:how_to_cook/generated/locale_keys.g.dart';
import 'package:world_flags/world_flags.dart';

class ItemView extends StatelessWidget {
  const ItemView({
    super.key,
    required this.name,
    this.count,
    this.tags,
    required this.imageUrl,
    this.country,
  });

  final String name;
  final int? count;
  final List<String>? tags;
  final String imageUrl;
  final String? country;

  @override
  Widget build(BuildContext context) {
    final countryData =
        WorldCountry.list.where((e) => e.demonyms.any((ee) => ee.male == country)).firstOrNull;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: DecorationImage(
          image: NetworkImage(imageUrl),
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
                        text: name,
                      ),
                    ],
                  )),
                ),
              ],
            ),
            const SizedBox(height: 10),
            if (count != null)
              Row(
                children: [
                  Text(
                    plural(LocaleKeys.Ingredients, count!),
                    style: const TextStyle(
                      fontFamily: Fonts.Comfortaa,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            if (tags != null) ...[
              const SizedBox(height: 10),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: List.generate(
                  tags?.length ?? 0,
                  (index) => Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      tags![index],
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
