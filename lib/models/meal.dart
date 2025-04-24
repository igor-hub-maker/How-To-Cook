import 'package:how_to_cook/common/rest/body_parameters.dart';
import 'package:how_to_cook/extensions/string_extensions.dart';
import 'package:how_to_cook/models/meal_ingredient.dart';
import 'package:how_to_cook/models/meal_short.dart';

class Meal extends MealShort {
  String category;
  List<String>? tags;
  String instructions;
  String? youtubeUrl;
  List<MealIngredient> ingredients;
  String? source;
  String? country;

  Meal({
    required this.category,
    required this.tags,
    required this.instructions,
    required this.youtubeUrl,
    required this.ingredients,
    required this.source,
    required this.country,
    required super.id,
    required super.name,
    required super.imageUrl,
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
            final ingredient = json['${BodyParameters.strIngredient}${index + 1}'];
            final measure = json['${BodyParameters.strMeasure}${index + 1}'];
            if (ingredient != null && ingredient.isNotEmpty && ingredient != '') {
              return MealIngredient(name: ingredient, measure: measure);
            }
            return null;
          }).where((element) => element != null).toList().cast<MealIngredient>(),
          source: json[BodyParameters.strSource],
          imageUrl: json[BodyParameters.strMealThumb],
          country: json[BodyParameters.strArea],
        );

  Map<String, dynamic> toJson() {
    return {
      BodyParameters.idMeal: id,
      BodyParameters.strMeal: name,
      BodyParameters.strCategory: category,
      BodyParameters.strTags: tags?.join(','),
      BodyParameters.strInstructions: instructions,
      BodyParameters.strYoutube: youtubeUrl,
      BodyParameters.strSource: source,
      BodyParameters.strMealThumb: imageUrl,
      BodyParameters.strArea: country,
      for (int i = 0; i < ingredients.length; i++) ...{
        '${BodyParameters.strIngredient}${i + 1}': ingredients[i].name,
        '${BodyParameters.strMeasure}${i + 1}': ingredients[i].measure,
      },
    };
  }
}
