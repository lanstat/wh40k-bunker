import 'package:sqflite/sqflite.dart';

Future<void> migrateVersion1(Database db) async {
  await db.execute('CREATE TABLE catalogues(_id TEXT PRIMARY KEY, name TEXT, revision TEXT)');
  await db.execute('CREATE TABLE rosters(_id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, catalogueId TEXT)');
  await db.execute('CREATE TABLE models(_id TEXT PRIMARY KEY, name TEXT, in_save TEXT, catalogue_id TEXT)');
  await db.execute('CREATE TABLE roster_units(_id INTEGER PRIMARY KEY AUTOINCREMENT, quantity INT, roster_id INT, model_id TEXT)');
  await db.execute('CREATE TABLE abilities(_id TEXT PRIMARY KEY, name TEXT, description TEXT)');
  await db.execute('CREATE TABLE categories(_id TEXT PRIMARY KEY, name TEXT)');
  await db.execute('CREATE TABLE model_abilities(model_id TEXT, ability_id TEXT)');
  await db.execute('CREATE TABLE model_categories(model_id TEXT, category_id TEXT)');
}
