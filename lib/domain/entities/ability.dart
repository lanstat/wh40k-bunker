import '../core/transfer_object.dart';
import 'model.dart';

class Ability extends ITable {
  String id;
  String name;
  String description;
  Model model = Model.empty();

  Ability({
    required this.id,
    required this.name,
    required this.description,
  });

  factory Ability.empty() {
    return Ability(id: '', name: '', description: '');
  }

  @override
  List<String> get columnsName => ['_id', 'name', 'description', 'model_id'];

  @override
  void fromMap(Map<String, dynamic> map) {
    id = map['_id'];
    name = map['name'];
    description = map['description'];
    model.id = map['model_id'];
  }

  @override
  String get tableName => 'abilities';

  @override
  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'name': name,
      'description': description,
      'model_id': model.id,
    };
  }
}