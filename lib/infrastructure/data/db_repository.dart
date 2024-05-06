import 'package:get_it/get_it.dart';
import 'package:sqflite/sqflite.dart';
import 'package:wh40k_command_center/domain/core/transfer_object.dart';
import 'package:wh40k_command_center/domain/interfaces/api_context.dart';
import 'package:wh40k_command_center/domain/interfaces/repository.dart';

GetIt _getIt = GetIt.instance;

class DatabaseRepository<T extends ITable> extends IRepository<T> {
  final ApiContext _context = _getIt<ApiContext>();

  @override
  Future<List<T>> list() async {
    Database db = _context.context as Database;
    var instance = _context.getInstance<T>();
    List<Map> maps = await db.query(
      instance.tableName,
      columns: instance.columnsName,
    );

    return maps.map<T>((e) {
      var t = _context.getInstance<T>();
      t.fromMap(e as Map<String, dynamic>);
      return t;
    }).toList();
  }

  @override
  Future<void> insert(T record) async {
    Database db = _context.context as Database;
    await db.insert(record.tableName, record.toMap());
  }

  @override
  Future<void> delete(T record) async {
    Database db = _context.context as Database;
    final map = record.toMap();
    await db.delete(
      record.tableName,
      where: '_id=?',
      whereArgs: [map['_id']]
    );
  }

  @override
  Future<void> update(T record) async {
    Database db = _context.context as Database;
    final map = record.toMap();
    await db.update(
      record.tableName,
      map,
      where: '_id=?',
      whereArgs: [map['_id']]
    );
  }

  @override
  Future<List<T>> filter(Specification<T> spec) async {
    Database db = _context.context as Database;
    var instance = _context.getInstance<T>();
    spec.query = instance;

    List<Map> maps = await db.query(
      instance.tableName,
      columns: instance.columnsName,
      where: spec.where(),
      whereArgs: spec.whereArgs(),
    );

    return maps.map<T>((e) {
      var t = _context.getInstance<T>();
      t.fromMap(e as Map<String, dynamic>);
      return t;
    }).toList();
  }

  @override
  Future<T?> get(id) async {
    Database db = _context.context as Database;
    var instance = _context.getInstance<T>();

    var maps =await db.query(
      instance.tableName,
      columns: instance.columnsName,
      where: 'id=?',
      whereArgs: [id]
    );

    if (maps.isEmpty) {
      return null;
    }

    var t = _context.getInstance<T>();
    t.fromMap(maps.first);
    return t;
  }

  @override
  Future<int> count() async {
    Database db = _context.context as Database;
    var instance = _context.getInstance<T>();

    var maps = await db.rawQuery('SELECT COUNT(1) c FROM ${instance.tableName}');
    if (maps.isEmpty) {
      return 0;
    }
    return maps.first['c'] as int;
  }
}