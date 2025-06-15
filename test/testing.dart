import 'package:how_to_cook/IoC/composition_root.dart';
import 'package:how_to_cook/common/rest/api_constants.dart';
import 'package:how_to_cook/services/local_db/local_db_service.dart';
import 'package:how_to_cook/services/meal_db/meal_db_service.dart';
import 'package:how_to_cook/services/shared_preferences/shared_preferences_service.dart';
import 'package:injector/injector.dart';
import 'package:test/test.dart';

void main() {
  CompositionRoot.initialize();
  final injector = Injector.appInstance;

  final localDbService = injector.get<LocalDbService>();
  final mealDbService = injector.get<MealDbService>();
  final sharedPreferencesService = injector.get<SharedPreferencesService>();

  group("LocalDbSErvice testing", () {
    test("init", () async => await localDbService.init());

    test("db", () {
      expect(localDbService.db, isNotNull);
      expect(localDbService.db.isOpen, true);
    });
  });

  group("MealDbService testing", () {
    test("get meal", () async {
      final response = await mealDbService.getRequestByPath(ApiConstants.randomMeal);
      expect(response, isNotNull);
      expect(response['meals'], isNotEmpty);
      expect(response['meals'][0]['idMeal'], isNotNull);
    });
  });

  group("SharedPreferencesService testing", () {
    test('set string', () async {
      final result = await sharedPreferencesService.setString('testKey', 'testValue');
      expect(result, isTrue);
    });

    test("get string", () async {
      final result = await sharedPreferencesService.getString('testKey');
      expect(result, 'testValue');
    });
  });
}
