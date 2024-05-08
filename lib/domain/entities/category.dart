import 'package:wh40k_command_center/domain/core/transfer_object.dart';

import 'model.dart';


class Category extends ITable {
  String id;
  String name;
  Model model = Model.empty();

  Category({
    required this.id,
    required this.name,
  });

  factory Category.empty() {
    return Category(id: '', name: '');
  }

  @override
  List<String> get columnsName => ['_id', 'name', 'model_id'];

  @override
  void fromMap(Map<String, dynamic> map) {
    id = map['_id'];
    name = map['name'];
    model.id = map['model_id'];
  }

  @override
  String get tableName => 'categories';

  @override
  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'name': name,
      'model_id': model.id,
    };
  }
}