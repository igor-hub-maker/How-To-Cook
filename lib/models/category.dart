import 'package:how_to_cook/common/rest/body_parameters.dart';

class Category {
  String id;
  String name;
  String imageUrl;
  String description;

  Category({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.description,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json[BodyParameters.idCategory],
      name: json[BodyParameters.strCategory],
      imageUrl: json[BodyParameters.strCategoryThumb],
      description: json[BodyParameters.strCategoryDescription],
    );
  }
}
