import 'dart:math';

import 'package:how_to_cook/common/constants.dart';
import 'package:how_to_cook/common/enums/meal_filtering_type.dart';
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
import 'package:how_to_cook/services/meal_db/meal_db_service.dart';
import 'package:injector/injector.dart';

class MealManagerImpl implements MealManager {
  final injector = Injector.appInstance;
  late final MealDbService _mealDbService = injector.get<MealDbService>();
  late final TranslationManager translationManager = injector.get<TranslationManager>();

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

  Future<Meal> translateMeal(Meal meal, String locale) async {
    final futures = <Future>[];

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
    final categories = await getAllCategories();
    return categories[Random().nextInt(categories.length)];
  }

  @override
  Future<List<Category>> getAllCategories() async {
    final locale = Constants.currentLocale;
    final json = await _mealDbService.getRequestByPath(ApiConstants.allCategories);
    final categoriesJson = List.from(json[BodyParameters.categories]);

    final categories = categoriesJson.map((categoryJson) {
      categoryJson[BodyParameters.strCategoryOriginal] = categoryJson[BodyParameters.strCategory];
      return Category.fromJson(categoryJson);
    }).toList();

    if (locale.isNotEmpty && locale != Constants.en) {
      final futures = categories.map((category) => translateCategory(category, locale)).toList();
      return Future.wait(futures);
    }

    return categories;
  }

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
      final futures = areasString.map(
        (area) {
          return translationManager.translate(area[BodyParameters.strArea], locale).then(
            (value) {
              areas.add(
                Area(
                  name: value,
                  localizedName: area[BodyParameters.strArea],
                ),
              );
            },
          );
        },
      ).toList();
      await Future.wait(futures);
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

    final result = mealsJson.map((e) => MealShort.fromJson(Map<String, dynamic>.from(e)));

    if (locale.isNotEmpty && locale != Constants.en) {
      final futures = result.map((mealShort) async {
        mealShort.name = await translationManager.translate(mealShort.name, locale);
        return mealShort;
      }).toList();

      return Future.wait(futures);
    }

    return result.toList();
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
}
