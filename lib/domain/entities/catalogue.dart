import 'package:wh40k_command_center/domain/core/transfer_object.dart';

import 'model.dart';

class Catalogue extends ITable {
  String id;
  String name;
  String revision;
  final List<Model> models = [];

  Catalogue({
    required this.id,
    required this.name,
    required this.revision,
  });

  factory Catalogue.empty({String id=''}) {
    return Catalogue(id: id, name: '', revision: '');
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'name': name,
      'revision': revision
    };
  }

  @override
  List<String> get columnsName => ['_id', 'name', 'revision'];

  @override
  void fromMap(Map<String, dynamic> map) {
    id = map['_id'];
    name = map['name'];
    revision = map['revision'];
  }

  @override
  String get tableName => 'catalogues';
}