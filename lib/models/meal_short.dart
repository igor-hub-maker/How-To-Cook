import 'package:how_to_cook/common/rest/body_parameters.dart';
import 'package:how_to_cook/extensions/string_extensions.dart';
import 'package:how_to_cook/models/meal_ingredient.dart';

class MealShort {
  String id;
  String name;
  String imageUrl;

  MealShort({
    required this.id,
    required this.name,
    required this.imageUrl,
  });

  MealShort.fromJson(Map<String, dynamic> json)
      : this(
          id: json[BodyParameters.idMeal],
          name: json[BodyParameters.strMeal],
          imageUrl: json[BodyParameters.strMealThumb],
        );
}
