import 'package:wh40k_command_center/domain/core/transfer_object.dart';

class Rule extends ITable {
  String id;
  String name;
  String description;

  Rule({
    required this.id,
    required this.name,
    required this.description,
  });

  @override
  List<String> get columnsName => ['_id', 'name', 'description'];

  @override
  void fromMap(Map<String, dynamic> map) {
    id = map['_id'];
    name = map['name'];
    description = map['description'];
  }

  @override
  String get tableName => 'rules';

  @override
  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'name': name,
      'description': description,
    };
  }
}
