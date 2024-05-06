import '../core/transfer_object.dart';
import 'index.dart';

class Model extends ITable {
  String id;
  String name;
  final Characteristic characteristic;
  final List<Category> categories = [];
  final List<Ability> abilities = [];
  final List<UpgradeGroup> groups = [];
  final List<Upgrade> upgrades = [];
  String invulnerableSave = '';
  Catalogue catalogue = Catalogue.empty();

  Model({
    required this.id,
    required this.name,
    required this.characteristic,
  });

  factory Model.empty({String id=''}) {
    return Model(id: id, name: '', characteristic: Characteristic.empty());
  }

  @override
  List<String> get columnsName => ['_id', 'name', 'in_save', 'catalogue_id'];

  @override
  void fromMap(Map<String, dynamic> map) {
    id = map['_id'];
    name = map['name'];
    invulnerableSave = map['in_save'];
    catalogue = Catalogue.empty(id: map['catalogue_id']);
  }

  @override
  String get tableName => 'models';

  @override
  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'name': name,
      'in_save': invulnerableSave,
      'catalogue_id': catalogue.id,
    };
  }
}