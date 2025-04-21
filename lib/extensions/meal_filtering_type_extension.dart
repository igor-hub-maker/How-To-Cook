import 'package:how_to_cook/common/enums/meal_filtering_type.dart';

extension MealFilteringTypeExtension on MealFilteringType {
  String get filterQueryParameter => switch (this) {
        MealFilteringType.area => 'a',
        MealFilteringType.category => 'c',
        MealFilteringType.ingredient => 'i',
      };
}
