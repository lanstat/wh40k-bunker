import '../core/transfer_object.dart';
import 'index.dart';

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

class RosterUnit extends ITable {
  int id;
  int quantity;
  Roster roster;
  Model model;

  RosterUnit({
    required this.id,
    required this.quantity,
    required this.roster,
    required this.model,
  });

  factory RosterUnit.empty() {
    return RosterUnit(id: 0, quantity: 0, roster: Roster.empty(), model: Model.empty());
  }

  @override
  List<String> get columnsName => ['_id', 'quantity', 'roster_id', 'model_id'];

  @override
  void fromMap(Map<String, dynamic> map) {
    id = map['id'];
    quantity = map['quantity'];
    roster.id = map['roster_id'];
    model.id = map['model_id'];
  }

  @override
  String get tableName => 'roster_units';

  @override
  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'quantity': quantity,
      'roster_id': roster.id,
      'model_id': model.id
    };
  }

}