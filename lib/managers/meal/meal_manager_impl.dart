import 'dart:math';

import 'package:how_to_cook/common/enums/meal_filtering_type.dart';
import 'package:how_to_cook/common/locale_constants.dart';
import 'package:how_to_cook/common/rest/api_constants.dart';
import 'package:how_to_cook/common/rest/body_parameters.dart';
import 'package:how_to_cook/common/rest/query_parameters.dart';
import 'package:how_to_cook/extensions/meal_filtering_type_extension.dart';
import 'package:how_to_cook/managers/meal/meal_manager.dart';
import 'package:how_to_cook/models/area.dart';
import 'package:how_to_cook/models/category.dart';
import 'package:how_to_cook/models/ingredient.dart';
import 'package:how_to_cook/models/meal.dart';
import 'package:how_to_cook/models/meal_short.dart';
import 'package:how_to_cook/services/meal_db/meal_db_service.dart';
import 'package:injector/injector.dart';
import 'package:translator/translator.dart';

class MealManagerImpl implements MealManager {
  late final MealDbService _mealDbService = Injector.appInstance.get<MealDbService>();

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
      translator.translate(mealJson[BodyParameters.strInstructions], to: locale).then(
            (result) => mealJson[BodyParameters.strInstructions] = result.text,
          ),
    );

    if (mealJson[BodyParameters.strArea] != null) {
      futures.add(
        translator.translate(mealJson[BodyParameters.strCategory], to: locale).then(
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
    final json = await _mealDbService.getRequestByPath(ApiConstants.allCategories);
    final categoriesJson = List.from(json[BodyParameters.categories]);

    final categories = List<Category>.empty(growable: true);
    for (final categoryJson in categoriesJson) {
      categoryJson[BodyParameters.strCategoryOriginal] = categoryJson[BodyParameters.strCategory];

      if (locale != null) {
        categories.add(Category.fromJson(await translateCategory(categoryJson, locale)));
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

    categoryJson[BodyParameters.strCategoryDescription] = (await translator.translate(
      categoryJson[BodyParameters.strCategoryDescription],
      to: locale,
    ))
        .text;

    return categoryJson;
  }

  @override
  Future<List<Area>> getAllAreas([String? locale]) async {
    final translator = GoogleTranslator();

    final json =
        await _mealDbService.getRequestByPath(ApiConstants.list, {QueryParameters.a: "list"});
    final areas = List<Area>.empty(growable: true);
    if (locale != null && locale != LocaleConstants.en) {
      final areasFutures = List.from(json[BodyParameters.meals]).map((json) async {
        final name = json[BodyParameters.strArea];
        final translation = await translator.translate(
          name,
          to: locale,
        );

        final translatedText = locale == LocaleConstants.ua
            ? translation.text.replaceAll("кий", "ка")
            : translation.text;

        return Area(name: name, localizedName: translatedText);
      }).toList();

      final translatedAreas = await Future.wait(areasFutures);
      areas.addAll(translatedAreas);
    } else {
      areas.addAll(
        List.from(json[BodyParameters.meals]).map(
          (json) => Area(
            name: json[BodyParameters.strArea],
            localizedName: json[BodyParameters.strArea],
          ),
        ),
      );
    }

    return areas;
  }

  @override
  Future<List<Ingredient>> getAllIngredients([String? locale]) async {
    final json =
        await _mealDbService.getRequestByPath(ApiConstants.list, {QueryParameters.i: "list"});

    final ingredients = List.from(json[BodyParameters.meals])
        .map(
          (json) => Ingredient.fromJson(json),
        )
        .toList();
    return ingredients;
  }

  @override
  Future<List<MealShort>> getMealsByFilter(String filter, MealFilteringType mealFilteringType,
      [String? locale]) async {
    final json = await _mealDbService
        .getRequestByPath(ApiConstants.filter, {mealFilteringType.filterQueryParameter: filter});

    var mealsJson = List.from(json[BodyParameters.meals]);

    final result = List<MealShort>.empty(growable: true);

    for (var mealJson in mealsJson) {
      if (locale != null) {
        mealJson = await translateMeal(mealJson, locale);
      }

      result.add(MealShort.fromJson(mealJson));
    }

    return result;
  }

  @override
  Future<Meal> getMealDetails(String mealId, [String? locale]) async {
    final json =
        await _mealDbService.getRequestByPath(ApiConstants.lookup, {QueryParameters.i: mealId});

    var mealJson = json[BodyParameters.meals][0];

    if (locale != null) {
      mealJson = await translateMeal(mealJson, locale);
    }

    return Meal.fromJson(mealJson);
  }
}
