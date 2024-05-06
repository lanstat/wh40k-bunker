import 'package:wh40k_command_center/domain/entities/characteristic.dart';

import 'category.dart';

enum UpgradeType {
  melee,
  range,
  description
}

class UpgradeCharacteristic {
  String range;
  String a;
  String skill;
  String s;
  String ap;
  String d;
  String keywords;
  List<String> keywordsParsed = [];

  UpgradeCharacteristic({
    required this.range,
    required this.a,
    required this.skill,
    required this.s,
    required this.ap,
    required this.d,
    required this.keywords,
  }) {
    keywordsParsed = keywords.split(',').map((e) => e.trim()).toList();
  }


  factory UpgradeCharacteristic.empty() {
    return UpgradeCharacteristic(
      a: '',
      ap: '',
      d: '',
      keywords: '',
      range: '',
      s: '',
      skill: '',
    );
  }

  void assign(UpgradeCharacteristic base) {
    a = base.a;
    ap = base.ap;
    d = base.d;
    keywords = base.keywords;
    range = base.range;
    s = base.s;
    skill = base.skill;
  }
}

class Upgrade {
  String id;
  String name;
  UpgradeCharacteristic characteristic;
  UpgradeType type;
  String description;
  final List<Category> categories = [];

  Upgrade({
    required this.id,
    required this.name,
    required this.characteristic,
    this.type = UpgradeType.description,
    this.description = '',
  });

  void assign(Upgrade base) {
    name = base.name;
    characteristic.assign(base.characteristic);
  }

  factory Upgrade.empty() {
    return Upgrade(id: '', name: '', characteristic: UpgradeCharacteristic.empty());
  }
}

class UpgradeGroup {
  final String id;
  final String name;
  final List<Upgrade> upgrades = [];
  UpgradeType type;

  UpgradeGroup({
    required this.id,
    required this.name,
    this.type = UpgradeType.range,
  });
}
