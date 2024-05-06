abstract class ITable {
  String get tableName;
  List<String> get columnsName;
  Map<String, dynamic> toMap();
  void fromMap(Map<String, dynamic> map);
}

abstract class Specification<T extends ITable> {
  late T query;
  List<String> get columns;

  String where() {
    String tmp = '';

    for (String name in columns) {
      tmp += 'AND $name=?';
    }

    return tmp.isEmpty? '' : tmp.substring(3);
  }

  List<dynamic> whereArgs() {
    var map = query.toMap();
    return columns.map((e) => map[e]).toList();
  }
}