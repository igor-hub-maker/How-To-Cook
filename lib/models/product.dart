import 'package:how_to_cook/common/rest/body_parameters.dart';

class Product {
  int? id;
  String name;
  double count;
  String measure;
  bool isMarked;

  Product({
    this.id,
    required this.name,
    required this.count,
    required this.measure,
    this.isMarked = false,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json[BodyParameters.id],
      name: json[BodyParameters.name],
      count: json[BodyParameters.count],
      measure: json[BodyParameters.measure],
      isMarked: json[BodyParameters.isMarked] == 0 ? false : true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) BodyParameters.id: id,
      BodyParameters.name: name,
      BodyParameters.count: count,
      BodyParameters.measure: measure,
      BodyParameters.isMarked: isMarked ? 1 : 0,
    };
  }
}
