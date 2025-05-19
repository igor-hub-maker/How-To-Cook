import 'package:how_to_cook/common/rest/body_parameters.dart';

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
