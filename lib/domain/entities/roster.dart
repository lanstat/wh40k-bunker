import '../core/transfer_object.dart';

class Roster extends ITable {
  int id;
  String name;
  String catalogueId;

  Roster({
    required this.id,
    required this.name,
    required this.catalogueId
  });

  factory Roster.empty() {
    return Roster(id: 0, name: '', catalogueId: '');
  }

  @override
  List<String> get columnsName => ['_id', 'name', 'catalogueId'];

  @override
  void fromMap(Map<String, dynamic> map) {
    id = map['_id'];
    name = map['name'];
    catalogueId = map['catalogueId'];
  }

  @override
  String get tableName => 'rosters';

  @override
  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'name': name,
      'catalogueId': catalogueId,
    };
  }
}