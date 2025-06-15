import 'package:how_to_cook/models/meal_ingredient.dart';
import 'package:how_to_cook/models/product.dart';

abstract class ProductsCartManager {
  Future<void> addOrUpdateToCart(Product product);

  Future<void> addOrUpdateToCartFromMealIngredient(MealIngredient mealIngredient);

  Future<void> addOrUpdateToCartMany(List<Product> products);

  Future<void> addOrUpdateToCartFromMealIngredientMany(List<MealIngredient> mealIngredients);

  Future<void> removeFromCart(int productId);

  Future<void> removeFromCartMany(List<int> productIds);

  Future<void> clearCart();

  Future<List<Product>> getCartItems();

  Future<void> markCartItem(int productId, bool isMarked);

  Future<void> localizeCartItems();
}
