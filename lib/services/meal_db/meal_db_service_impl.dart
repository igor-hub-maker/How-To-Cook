import 'dart:convert';
import 'dart:developer';

import 'package:how_to_cook/common/rest/api_constants.dart';
import 'package:how_to_cook/common/rest/environment_constants.dart';
import 'package:http/http.dart' as http;
import 'package:how_to_cook/services/meal_db/meal_db_service.dart';

class MealDbServiceImpl implements MealDbService {
  @override
  Future getRequestByPath(String path, [Map<String, String>? queryParameters]) async {
    final responce = await http.get(
        Uri.https(EnvironmentConstants.mealUrl, "${ApiConstants.basePath}$path", queryParameters));

    if (responce.statusCode != 200) {
      log("${responce.request?.url.toString()}: Error:  ${responce.statusCode}");
      return null;
    }

    return jsonDecode(responce.body);
  }
}
