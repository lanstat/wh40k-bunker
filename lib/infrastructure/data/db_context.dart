import 'package:wh40k_command_center/domain/entities/index.dart';
import 'package:wh40k_command_center/domain/interfaces/api_context.dart';
import 'package:sqflite/sqflite.dart';

import 'migrations.dart';

class DatabaseContext extends ApiContext {
  late Database _database;

  @override
  Future<void> initialize() async {
    await super.initialize();

    var tmp = await getDatabasesPath();
    String path = '$tmp/roster.db';

    await deleteDatabase(path);
    _database = await openDatabase(path, version: 1, onCreate:  (Database db, int version) async {
      await migrateVersion1(db);
    });
  }

  @override
  Database get context => _database;

  @override
  void onModelCreating(Map<Type, (Type, String)> relations) {
    relations[Ability] = (Model, 'model_id');
  }
}