class MealIngredient {
  String name;
  String measure;

  MealIngredient({required this.name, required this.measure});

  MealIngredient.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        measure = json['measure'];
}
