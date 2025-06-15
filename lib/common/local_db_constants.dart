class LocalDbConstants {
  static const String dbName = 'how_to_cook.db';
  static const String MealsHistory = "MealsHistory";
  static const String ProductsCart = "ProductsCart";
  static const String SavedMeals = "SavedMeals";
  static const String Meals = "Meals";

  static const String createMealsTableCommand =
      "CREATE TABLE Meals (idMeal TEXT PRIMARY KEY, strMeal TEXT, strCategory TEXT, strTags TEXT, strInstructions TEXT, strYoutube TEXT, strSource TEXT, locale TEXT, strMealThumb TEXT, strArea TEXT, strIngredient1 TEXT, strMeasure1 TEXT, strIngredient2 TEXT, strMeasure2 TEXT, strIngredient3 TEXT, strMeasure3 TEXT, strIngredient4 TEXT, strMeasure4 TEXT, strIngredient5 TEXT, strMeasure5 TEXT, strIngredient6 TEXT, strMeasure6 TEXT, strIngredient7 TEXT, strMeasure7 TEXT, strIngredient8 TEXT, strMeasure8 TEXT, strIngredient9 TEXT, strMeasure9 TEXT, strIngredient10 TEXT, strMeasure10 TEXT, strIngredient11 TEXT, strMeasure11 TEXT, strIngredient12 TEXT, strMeasure12 TEXT, strIngredient13 TEXT, strMeasure13 TEXT, strIngredient14 TEXT, strMeasure14 TEXT, strIngredient15 TEXT, strMeasure15 TEXT, strIngredient16 TEXT, strMeasure16 TEXT, strIngredient17 TEXT, strMeasure17 TEXT, strIngredient18 TEXT, strMeasure18 TEXT, strIngredient19 TEXT, strMeasure19 TEXT, strIngredient20 TEXT, strMeasure20 TEXT)";
  static const String createMealsHistoryTableCommand =
      "CREATE TABLE MealsHistory (id INTEGER PRIMARY KEY AUTOINCREMENT, idMeal TEXT, strMeal TEXT)";
  static const String createSavedMealsTableCommand =
      "CREATE TABLE SavedMeals (id INTEGER PRIMARY KEY AUTOINCREMENT, idMeal TEXT, strMeal TEXT)";
  static const String createProductsCartTableCommand =
      "CREATE TABLE ProductsCart (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, count REAL, measure TEXT, isMarked BOOLEAN DEFAULT false)";
}
