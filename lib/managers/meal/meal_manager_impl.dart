import 'dart:math';

import 'package:flutter/material.dart';
import 'package:how_to_cook/common/constants.dart';
import 'package:how_to_cook/common/enums/meal_filtering_type.dart';
import 'package:how_to_cook/common/local_db_constants.dart';
import 'package:how_to_cook/common/rest/api_constants.dart';
import 'package:how_to_cook/common/rest/body_parameters.dart';
import 'package:how_to_cook/common/rest/query_parameters.dart';
import 'package:how_to_cook/extensions/meal_filtering_type_extension.dart';
import 'package:how_to_cook/managers/meal/meal_manager.dart';
import 'package:how_to_cook/managers/translation/translation_manager.dart';
import 'package:how_to_cook/models/area.dart';
import 'package:how_to_cook/models/category.dart';
import 'package:how_to_cook/models/meal.dart';
import 'package:how_to_cook/models/meal_ingredient.dart';
import 'package:how_to_cook/models/meal_short.dart';
import 'package:how_to_cook/services/local_db/local_db_service.dart';
import 'package:how_to_cook/services/meal_db/meal_db_service.dart';
import 'package:injector/injector.dart';
import 'package:sqflite/sqlite_api.dart';

class MealManagerImpl implements MealManager {
  final injector = Injector.appInstance;
  late final MealDbService _mealDbService = injector.get<MealDbService>();
  late final TranslationManager translationManager = injector.get<TranslationManager>();
  late final LocalDbService localDbService = injector.get<LocalDbService>();

  @override
  Future<Meal> getRandomMeal() async {
    final locale = Constants.currentLocale;

    final json = await _mealDbService.getRequestByPath(ApiConstants.randomMeal);

    var mealJson = json[BodyParameters.meals][0];

    var meal = Meal.fromJson(mealJson);

    if (locale.isNotEmpty && locale != Constants.en) {
      meal = await translateMeal(mealJson, locale);
    }

    return meal;
  }

  @override
  Future<Meal> translateMeal(Meal meal, String locale) async {
    final futures = <Future>[];

    futures.add(translationManager.translate(meal.name, locale).then((value) {
      meal.name = value;
    }));

    if (meal.category.isNotEmpty) {
      futures.add(translationManager.translate(meal.category, locale).then((value) {
        meal.category = value;
      }));
    }

    if (meal.tags?.isNotEmpty ?? false) {
      futures.add(
        translationManager.translateMany(meal.tags!, locale).then((value) {
          meal.tags = value;
        }),
      );
    }

    futures.add(translationManager.translate(meal.instructions, locale).then((value) {
      meal.instructions = value;
    }));

    futures.add(
      () async {
        final ingredientsToTranslate = meal.ingredients
            .map((ingredient) => "${ingredient.name},${ingredient.measure}")
            .toList();
        final translatedIngredients =
            await translationManager.translateMany(ingredientsToTranslate, locale);
        meal.ingredients = translatedIngredients.map((e) {
          final parts = e.split(',');
          return MealIngredient(
            name: parts[0],
            measure: parts[1],
          );
        }).toList();
      }(),
    );

    await Future.wait(futures);
    return meal;
  }

  @override
  Future<Category> getRandomCategory() async {
    final categories = await getAllCategories(false);
    var category = categories[Random().nextInt(categories.length)];

    if (Constants.currentLocale.isNotEmpty && Constants.currentLocale != Constants.en) {
      category = await translateCategory(category, Constants.currentLocale);
    }

    return category;
  }

  @override
  Future<List<Category>> getAllCategories([bool shouldTranslate = true]) async {
    final locale = Constants.currentLocale;
    final json = await _mealDbService.getRequestByPath(ApiConstants.allCategories);
    final categoriesJson = List.from(json[BodyParameters.categories]);

    final categories = categoriesJson.map((categoryJson) {
      categoryJson[BodyParameters.strCategoryOriginal] = categoryJson[BodyParameters.strCategory];
      return Category.fromJson(categoryJson);
    }).toList();

    if (locale.isNotEmpty && locale != Constants.en && shouldTranslate) {
      final translatedCategories = <Category>[];

      for (var category in categories) {
        await Future.delayed(Durations.medium1);

        final translatedCategory = await translateCategory(category, locale);
        translatedCategories.add(translatedCategory);
      }

      return translatedCategories;
    }

    return categories;
  }

  @override
  Future<Category> translateCategory(Category category, String locale) async {
    final futures = <Future>[];
    futures.add(
      translationManager.translate(category.name, locale).then((value) {
        category.name = value;
      }),
    );

    if (category.description.isNotEmpty) {
      futures.add(
        translationManager.translate(category.description, locale).then((value) {
          category.description = value;
        }),
      );
    }

    Future.wait(futures);
    return category;
  }

  @override
  Future<List<Area>> getAllAreas() async {
    final locale = Constants.currentLocale;

    final json =
        await _mealDbService.getRequestByPath(ApiConstants.list, {QueryParameters.a: "list"});
    final areas = List<Area>.empty(growable: true);

    final areasString = List.from(json[BodyParameters.meals]);

    if (locale.isNotEmpty && locale != Constants.en) {
      final areasToTranslate = areasString
          .map(
            (area) => area[BodyParameters.strArea].toString(),
          )
          .toList();

      final translatedAreas = await translationManager.translateMany(areasToTranslate, locale);

      for (var i = 0; i < translatedAreas.length; i++) {
        areas.add(
          Area(
            name: areasToTranslate[i],
            localizedName: translatedAreas[i],
          ),
        );
      }
    } else {
      areas.addAll(
        areasString.map(
          (area) => Area(
            name: area[BodyParameters.strArea],
            localizedName: area[BodyParameters.strArea],
          ),
        ),
      );
    }

    return areas;
  }

  @override
  Future<List<MealShort>> getMealsByFilter(
    String filter,
    MealFilteringType mealFilteringType,
  ) async {
    final locale = Constants.currentLocale;

    final json = await _mealDbService
        .getRequestByPath(ApiConstants.filter, {mealFilteringType.filterQueryParameter: filter});

    var mealsJson = List.from(json[BodyParameters.meals]);

    final result = mealsJson.map((e) => MealShort.fromJson(Map<String, dynamic>.from(e))).toList();

    if (locale.isNotEmpty && locale != Constants.en) {
      final mealNames = result.map((mealShort) => mealShort.name).toList();
      final translatedMealNames = await translationManager.translateMany(mealNames, locale);

      for (var i = 0; i < result.length; i++) {
        result[i].name = translatedMealNames[i];
      }
    }

    return result;
  }

  @override
  Future<Meal> getMealDetails(
    String mealId,
  ) async {
    final locale = Constants.currentLocale;

    final json =
        await _mealDbService.getRequestByPath(ApiConstants.lookup, {QueryParameters.i: mealId});

    var mealJson = json[BodyParameters.meals][0];
    var meal = Meal.fromJson(mealJson);

    if (locale.isNotEmpty && locale != Constants.en) {
      meal = await translateMeal(meal, locale);
    }

    return meal;
  }

  @override
  Future<void> saveMealToLocalIfNeeded(Meal meal, [bool shouldOverwrite = true]) async {
    final db = localDbService.db;

    if (shouldOverwrite == true) {
      final query = await db.query(
        LocalDbConstants.Meals,
        where: "${BodyParameters.idMeal} = ?",
        whereArgs: [meal.id],
      );

      if (query.isNotEmpty) {
        return;
      }
    }

    final json = meal.toJson();
    json[BodyParameters.locale] = Constants.currentLocale;

    db.insert(
      LocalDbConstants.Meals,
      json,
    );
  }

  @override
  Future<Meal?> getMealFromLocal(String mealId) async {
    final db = localDbService.db;

    final query = await db.query(
      LocalDbConstants.Meals,
      where: "${BodyParameters.idMeal} = ?",
      whereArgs: [mealId],
    );

    final mealJson = query.firstOrNull;

    if (mealJson == null) {
      return null;
    }

    if (mealJson[BodyParameters.locale] != Constants.currentLocale) {
      final meal = await getMealDetails(mealId);
      final json = meal.toJson();
      json[BodyParameters.locale] = Constants.currentLocale;

      db.insert(LocalDbConstants.Meals, json, conflictAlgorithm: ConflictAlgorithm.replace);

      return meal;
    }

    return Meal.fromJson(mealJson);
  }

  @override
  Future<List<Meal>> getMealsFromLocal(List<String> mealIds) async {
    final db = localDbService.db;
    final idsCombined = mealIds.join(',');

    final query = await db.query(
      LocalDbConstants.Meals,
      where: "${BodyParameters.idMeal} IN ($idsCombined)",
    );

    final result = <Meal>[];

    for (var mealJson in query) {
      if (mealJson[BodyParameters.locale] != Constants.currentLocale) {
        await Future.delayed(Durations.medium1);

        final meal = await getMealDetails(mealJson[BodyParameters.idMeal].toString());
        final json = meal.toJson();
        json[BodyParameters.locale] = Constants.currentLocale;

        db.insert(LocalDbConstants.Meals, json, conflictAlgorithm: ConflictAlgorithm.replace);

        result.add(Meal.fromJson(json));
        continue;
      }

      result.add(Meal.fromJson(mealJson));
    }

    return result;
  }
}
