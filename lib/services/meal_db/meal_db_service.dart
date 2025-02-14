abstract class MealDbService {
  Future<dynamic> getRequestByPath(String path, [Map<String, String>? queryParameters]);
}
