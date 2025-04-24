import 'package:sqflite/sqlite_api.dart';

abstract class LocalDbService {
  Database get db;

  Future<void> init();
}
