import 'package:sqflite/sqflite.dart';

Future<void> migrateVersion1(Database db) async {
  await db.execute('CREATE TABLE catalogues(_id TEXT PRIMARY KEY, name TEXT, revision TEXT)');
  await db.execute('CREATE TABLE rosters(_id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, catalogueId TEXT)');
  await db.execute('CREATE TABLE models(_id TEXT PRIMARY KEY, name TEXT, in_save TEXT, catalogue_id TEXT)');
  await db.execute('CREATE TABLE roster_units(_id INTEGER PRIMARY KEY AUTOINCREMENT, quantity INT, roster_id INT, model_id TEXT)');
}
