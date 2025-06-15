import 'package:how_to_cook/common/local_db_constants.dart';
import 'package:how_to_cook/services/local_db/local_db_service.dart';
import 'package:sqflite/sqflite.dart';

class LocalDbServiceImpl implements LocalDbService {
  late final Database _db;

  @override
  Database get db => _db;

  @override
  Future<void> init() async {
    final dbPath = await getDatabasesPath();

    _db = await openDatabase(
      "$dbPath/${LocalDbConstants.dbName}",
      version: 1,
      onCreate: (db, version) async {
        await db.execute(LocalDbConstants.createMealsHistoryTableCommand);
        await db.execute(LocalDbConstants.createProductsCartTableCommand);
        await db.execute(LocalDbConstants.createSavedMealsTableCommand);
        await db.execute(LocalDbConstants.createMealsTableCommand);
      },
    );
  }
}
