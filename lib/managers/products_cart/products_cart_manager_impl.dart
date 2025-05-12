import 'package:how_to_cook/common/local_db_constants.dart';
import 'package:how_to_cook/common/rest/body_parameters.dart';
import 'package:how_to_cook/extensions/string_extensions.dart';
import 'package:how_to_cook/managers/products_cart/products_cart_manager.dart';
import 'package:how_to_cook/models/meal_ingredient.dart';
import 'package:how_to_cook/models/product.dart';
import 'package:how_to_cook/services/local_db/local_db_service.dart';
import 'package:injector/injector.dart';
import 'package:sqflite/sqlite_api.dart';

class ProductsCartManagerImpl implements ProductsCartManager {
  late final LocalDbService _localDbService = Injector.appInstance.get<LocalDbService>();

  @override
  Future<void> addOrUpdateToCart(Product product) async {
    final json = await _localDbService.db
        .query(LocalDbConstants.ProductsCartTable, where: "name = ?", whereArgs: [product.name]);
    if (json.isNotEmpty) {
      product.id = json.first[BodyParameters.id] as int?;
      product.count += json.first[BodyParameters.count] as double;
      product.isMarked = false;
    }

    await _localDbService.db.insert(
      LocalDbConstants.ProductsCartTable,
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
    return _localDbService.db.delete(LocalDbConstants.ProductsCartTable);
  }

  @override
  Future<List<Product>> getCartItems() async {
    final json = await _localDbService.db.query(
      LocalDbConstants.ProductsCartTable,
      where: "count > 0",
    );

    return json.map((e) => Product.fromJson(e)).toList();
  }

  @override
  Future<void> removeFromCart(int productId) {
    return _localDbService.db.delete(
      LocalDbConstants.ProductsCartTable,
      where: "id = ?",
      whereArgs: [productId],
    );
  }

  @override
  Future<void> removeFromCartMany(List<int> productIds) {
    return _localDbService.db.delete(
      LocalDbConstants.ProductsCartTable,
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
      LocalDbConstants.ProductsCartTable,
      {BodyParameters.isMarked: isMarked ? 1 : 0},
      where: "id = ?",
      whereArgs: [productId],
    );
  }
}
