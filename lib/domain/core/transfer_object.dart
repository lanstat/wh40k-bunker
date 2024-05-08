abstract class ITable {
  String get tableName;
  List<String> get columnsName;
  Map<String, dynamic> toMap();
  void fromMap(Map<String, dynamic> map);
}

typedef WhereFilter<T> = (T, List<String>) Function();

class LinQ<T> {
  WhereFilter<T>? _whereFilter;

  LinQ<T> where(WhereFilter<T> query) {
    _whereFilter = query;
    return this;
  }
}

abstract class Specification<T extends ITable> {
  final query = LinQ<T>();

  (String, List<dynamic>) where() {
    var (instance, columns) = query._whereFilter!();
    String tmp = '';

    for (String name in columns) {
      tmp += 'AND $name=?';
    }

    var map = instance.toMap();
    return (
      tmp.isEmpty? '' : tmp.substring(3),
      columns.map((e) => map[e]).toList()
    );
  }
}