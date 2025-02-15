import 'dart:math';

import 'package:how_to_cook/common/rest/api_constants.dart';
import 'package:how_to_cook/common/rest/body_parameters.dart';
import 'package:how_to_cook/managers/meal/meal_manager.dart';
import 'package:how_to_cook/models/category.dart';
import 'package:how_to_cook/models/ingredient.dart';
import 'package:how_to_cook/models/meal.dart';
import 'package:how_to_cook/services/meal_db/meal_db_service.dart';
import 'package:injector/injector.dart';
import 'package:translator/translator.dart';

class MealManagerImpl implements MealManager {
  late final MealDbService _mealDbService =
      Injector.appInstance.get<MealDbService>();

  @override
  Future<Meal> getRandomMeal([String? locale]) async {
    final json = await _mealDbService.getRequestByPath(ApiConstants.randomMeal);

    var mealJson = json[BodyParameters.meals][0];

    if (locale != null) {
      mealJson = await translateMeal(mealJson, locale);
    }

    return Meal.fromJson(mealJson);
  }

  Future<dynamic> translateMeal(dynamic mealJson, String locale) async {
    final translator = GoogleTranslator();
    final futures = <Future>[];

    futures.add(
      translator.translate(mealJson[BodyParameters.strMeal], to: locale).then(
            (result) => mealJson[BodyParameters.strMeal] = result.text,
          ),
    );

    futures.add(
      translator
          .translate(mealJson[BodyParameters.strInstructions], to: locale)
          .then(
            (result) => mealJson[BodyParameters.strInstructions] = result.text,
          ),
    );

    if (mealJson[BodyParameters.strArea] != null) {
      futures.add(
        translator
            .translate(mealJson[BodyParameters.strCategory], to: locale)
            .then(
              (result) => mealJson[BodyParameters.strCategory] = result.text,
            ),
      );
    }

    if (mealJson[BodyParameters.strTags] != null) {
      futures.add(
        translator.translate(mealJson[BodyParameters.strTags], to: locale).then(
              (result) => mealJson[BodyParameters.strTags] = result.text,
            ),
      );
    }

    await Future.wait(futures);
    return mealJson;
  }

  @override
  Future<Category> getRandomCategory([String? locale]) async {
    final categories = await getAllCategories(locale);
    return categories[Random().nextInt(categories.length)];
  }

  @override
  Future<List<Category>> getAllCategories([String? locale]) async {
    final json =
        await _mealDbService.getRequestByPath(ApiConstants.allCategories);
    final categoriesJson = List.from(json[BodyParameters.categories]);

    final categories = List<Category>.empty(growable: true);
    for (final categoryJson in categoriesJson) {
      if (locale != null) {
        categories.add(
            Category.fromJson(await translateCategory(categoryJson, locale)));
      } else {
        categories.add(Category.fromJson(categoryJson));
      }
    }

    return categories;
  }

  Future<dynamic> translateCategory(dynamic categoryJson, String locale) async {
    final translator = GoogleTranslator();
    categoryJson[BodyParameters.strCategory] = (await translator.translate(
      categoryJson[BodyParameters.strCategory],
      to: locale,
    ))
        .text;

    categoryJson[BodyParameters.strCategoryDescription] =
        (await translator.translate(
      categoryJson[BodyParameters.strCategoryDescription],
      to: locale,
    ))
            .text;

    return categoryJson;
  }

  @override
  Future<List<String>> getAllAreas([String? locale]) async {
    final json =
        await _mealDbService.getRequestByPath(ApiConstants.list, {"a": "list"});
    final areas = List.from(json[BodyParameters.meals])
        .map(
          (json) => json[BodyParameters.strArea] as String,
        )
        .toList();
    return areas;
  }

  @override
  Future<List<Ingredient>> getAllIngredients([String? locale]) async {
    final json =
        await _mealDbService.getRequestByPath(ApiConstants.list, {"i": "list"});

    final ingredients = List.from(json[BodyParameters.meals])
        .map(
          (json) => Ingredient.fromJson(json),
        )
        .toList();
    return ingredients;
  }
}
