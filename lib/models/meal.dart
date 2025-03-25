import 'package:how_to_cook/common/rest/body_parameters.dart';
import 'package:how_to_cook/extensions/string_extensions.dart';
import 'package:how_to_cook/models/meal_ingredient.dart';

class Meal {
  String id;
  String name;
  String category;
  List<String>? tags;
  String instructions;
  String? youtubeUrl;
  List<MealIngredient> ingredients;
  String? source;
  String imageUrl;
  String? country;

  Meal({
    required this.id,
    required this.name,
    required this.category,
    required this.tags,
    required this.instructions,
    required this.youtubeUrl,
    required this.ingredients,
    required this.source,
    required this.imageUrl,
    required this.country,
  });

  Meal.fromJson(Map<String, dynamic> json)
      : this(
          id: json[BodyParameters.idMeal],
          name: json[BodyParameters.strMeal],
          category: json[BodyParameters.strCategory],
          tags: (json[BodyParameters.strTags] as String?)
              ?.split(',')
              .map((tag) => tag.trim().capitalizeFirstLetter())
              .toList(),
          instructions: json[BodyParameters.strInstructions],
          youtubeUrl: json[BodyParameters.strYoutube],
          ingredients: List.generate(20, (index) {
            final ingredient =
                json['${BodyParameters.strIngredient}${index + 1}'];
            final measure = json['${BodyParameters.strMeasure}${index + 1}'];
            if (ingredient != null && ingredient.isNotEmpty) {
              return MealIngredient(name: ingredient, measure: measure);
            }
            return null;
          })
              .where((element) => element != null)
              .toList()
              .cast<MealIngredient>(),
          source: json[BodyParameters.strSource],
          imageUrl: json[BodyParameters.strMealThumb],
          country: json[BodyParameters.strArea],
        );
}
