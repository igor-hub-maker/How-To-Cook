import 'package:flutter/material.dart';
import 'package:how_to_cook/common/locale_db_constants.dart';
import 'package:how_to_cook/generated/locale_keys.g.dart';
import 'package:how_to_cook/services/local_db/local_db_service.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common/sqlite_api.dart';

class LocalDbServiceImpl implements LocalDbService {
  late final Database _db;

  @override
  Database get db => _db;

  @override
  Future<void> init() async {
    final dbPath = await getDatabasesPath();

    _db = await openDatabase(
      "$dbPath/${LocaleDbConstants.dbName}",
      version: 1,
      onCreate: (db, version) async {
        await db.execute(LocaleDbConstants.createMealsHistoryTableCommand);
      },
    );

    var ss = 0;
  }
}
