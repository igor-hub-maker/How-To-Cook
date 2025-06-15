import 'package:how_to_cook/common/constants.dart';
import 'package:how_to_cook/common/local_db_constants.dart';
import 'package:how_to_cook/common/rest/body_parameters.dart';
import 'package:how_to_cook/extensions/string_extensions.dart';
import 'package:how_to_cook/managers/products_cart/products_cart_manager.dart';
import 'package:how_to_cook/managers/translation/translation_manager.dart';
import 'package:how_to_cook/models/meal_ingredient.dart';
import 'package:how_to_cook/models/product.dart';
import 'package:how_to_cook/services/local_db/local_db_service.dart';
import 'package:injector/injector.dart';
import 'package:sqflite/sqlite_api.dart';

// TODO add translation
class ProductsCartManagerImpl implements ProductsCartManager {
  final injector = Injector.appInstance;
  late final LocalDbService _localDbService = injector.get<LocalDbService>();
  late final TranslationManager _translationManager = injector.get<TranslationManager>();

  @override
  Future<void> addOrUpdateToCart(Product product) async {
    final json = await _localDbService.db
        .query(LocalDbConstants.ProductsCart, where: "name = ?", whereArgs: [product.name]);
    if (json.isNotEmpty) {
      product.id = json.first[BodyParameters.id] as int?;
      product.count += json.first[BodyParameters.count] as double;
      product.isMarked = false;
    }

    await _localDbService.db.insert(
      LocalDbConstants.ProductsCart,
      product.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> addOrUpdateToCartFromMealIngredient(MealIngredient mealIngredient) {
    final (count, measure) = mealIngredient.measure.parseQuantity();

    final product = Product(
      name: mealIngredient.name,
      count: count,
      measure: measure,
    );

    return addOrUpdateToCart(product);
  }

  @override
  Future<void> clearCart() {
    return _localDbService.db.delete(LocalDbConstants.ProductsCart);
  }

  @override
  Future<List<Product>> getCartItems() async {
    final json = await _localDbService.db.query(
      LocalDbConstants.ProductsCart,
      where: "count > 0",
    );

    final json2 = await _localDbService.db.query(
      LocalDbConstants.ProductsCart,
      // where: "count > 0",
    );
    var ss = 0;
    return json.map((e) => Product.fromJson(e)).toList();
  }

  @override
  Future<void> removeFromCart(int productId) {
    return _localDbService.db.delete(
      LocalDbConstants.ProductsCart,
      where: "id = ?",
      whereArgs: [productId],
    );
  }

  @override
  Future<void> removeFromCartMany(List<int> productIds) {
    return _localDbService.db.delete(
      LocalDbConstants.ProductsCart,
      where: "id IN (${productIds.join(',')})",
    );
  }

  @override
  Future<void> addOrUpdateToCartFromMealIngredientMany(List<MealIngredient> mealIngredients) {
    for (var mealIngredient in mealIngredients) {
      addOrUpdateToCartFromMealIngredient(mealIngredient);
    }

    return Future.value();
  }

  @override
  Future<void> addOrUpdateToCartMany(List<Product> products) {
    for (var product in products) {
      addOrUpdateToCart(product);
    }

    return Future.value();
  }

  @override
  Future<void> markCartItem(int productId, bool isMarked) {
    return _localDbService.db.update(
      LocalDbConstants.ProductsCart,
      {BodyParameters.isMarked: isMarked ? 1 : 0},
      where: "id = ?",
      whereArgs: [productId],
    );
  }

  @override
  Future<void> localizeCartItems() async {
    final json = List.from(await _localDbService.db.query(
      LocalDbConstants.ProductsCart,
    ));

    for (var i = 0; i < json.length; i++) {
      final translationResult = await _translationManager.translateMany(
        [
          json[i][BodyParameters.name].toString(),
          json[i][BodyParameters.measure].toString(),
        ],
        Constants.currentLocale,
      );

      json[i][BodyParameters.name] = translationResult[0];
      json[i][BodyParameters.measure] = translationResult[1];

      _localDbService.db.insert(
        LocalDbConstants.ProductsCart,
        json[i],
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }
}
