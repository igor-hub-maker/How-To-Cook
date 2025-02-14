import 'package:how_to_cook/common/rest/body_parameters.dart';

class Ingredient {
  String id;
  String name;
  String? description;
  String? type;

  Ingredient({
    required this.id,
    required this.name,
    this.description,
    this.type,
  });

  Ingredient.fromJson(Map<String, dynamic> json)
      : this(
          id: json[BodyParameters.idIngredient],
          name: json[BodyParameters.strIngredient],
          description: json[BodyParameters.strDescription],
          type: json[BodyParameters.strType],
        );
}
