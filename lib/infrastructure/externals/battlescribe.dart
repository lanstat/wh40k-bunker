import 'dart:io';

import 'package:flutter_archive/flutter_archive.dart';
import 'package:get_it/get_it.dart';
import 'package:wh40k_command_center/domain/interfaces/army.dart';
import 'package:wh40k_command_center/domain/interfaces/battlescribe.dart';
import 'package:http/http.dart' as http;
import 'package:wh40k_command_center/infrastructure/externals/mock.dart';
import 'package:xml/xml.dart';
import 'package:xml/xpath.dart';

import '../../domain/entities/index.dart';

GetIt _getIt = GetIt.instance;

String _fetchAttribute(List<XmlAttribute> attributes, String name) {
  return attributes.firstWhere((element) => element.name.local == name).value ?? '';
}

List<Upgrade> _parseUpgrade(XmlNode record, Map<String, dynamic> bag) {
  var nodes = record.xpath('./profiles/profile');
  UpgradeCharacteristic characteristic = UpgradeCharacteristic.empty();
  var type = UpgradeType.description;
  String description = '';
  final upgrades = <Upgrade>[];

  for (var node in nodes) {
    var parent = node.xpath('./characteristics').firstOrNull!;
    description = parent.xpath('./characteristic[@name="Description"]').firstOrNull?.innerText ?? '';
    if (description.isEmpty) {
      var parentType = _fetchAttribute(node.attributes, 'typeName');
      if (['Unit', 'Abilities'].contains(parentType)) {
        continue;
      }
      if (parentType.contains('Melee')) {
        type = UpgradeType.melee;
      } else {
        type = UpgradeType.range;
      }
      characteristic = UpgradeCharacteristic(
        range: parent.xpath('./characteristic[@name="Range"]').first.innerText,
        a: parent.xpath('./characteristic[@name="A"]').first.innerText,
        skill: parent.xpath('./characteristic[@name="WS"]').firstOrNull?.innerText ??parent.xpath('./characteristic[@name="BS"]').first.innerText,
        s: parent.xpath('./characteristic[@name="S"]').first.innerText,
        ap: parent.xpath('./characteristic[@name="AP"]').first.innerText,
        d: parent.xpath('./characteristic[@name="D"]').first.innerText,
        keywords: parent.xpath('./characteristic[@name="Keywords"]').first.innerText,
      );
    }

    var upgrade = Upgrade(
      id: _fetchAttribute(node.attributes, 'id'),
      name: _fetchAttribute(node.attributes, 'name'),
      characteristic: characteristic,
      description: description,
      type: type,
    );

    upgrades.add(upgrade);
  }

  var entries = record.xpath('./selectionEntries/selectionEntry');
  if (entries.isNotEmpty) {
    for (var entry in entries) {
      upgrades.addAll(_parseUpgrade(entry, bag));
    }
  }

  entries = record.xpath('./entryLinks/entryLink');
  for (var entry in entries) {
    final targetId = _fetchAttribute(entry.attributes, 'targetId');
    if (!bag.containsKey(targetId)) {
      continue;
    }
    dynamic item = bag[targetId];

    if (item is Upgrade) {
      upgrades.add(item);
    }
  }

  return upgrades;
}

/*
dynamic _parseLink(XmlDocument root, String id) {
  final node = root.xpath('//catalogue/sharedSelectionEntries/selectionEntry[@id="$id"]').firstOrNull;
  if (node == null) return  null;

  final type = _fetchAttribute(node.attributes, 'type');
  if (type == 'upgrade') {
    return _parseUpgrade(node, bag);
  }
  return null;
}
 */

void _parseProfileLink(XmlDocument root, Map<String, dynamic> bag) {
  final nodes = root.xpath('//catalogue/sharedProfiles/profile');

  for (var node in nodes) {
    final id =  _fetchAttribute(node.attributes, 'id');
    final type = _fetchAttribute(node.attributes, 'typeName');
    if (type == 'upgrade') {
      bag[id] = _parseUpgrade(node, bag);
    }
    if (type == 'Abilities') {
      bag[id] = Ability(
        id: id,
        name: _fetchAttribute(node.attributes, 'name'),
        description: node.xpath('./characteristics/characteristic').first.innerText,
      );
    }
  }
}

void _parseSelectionLink(XmlDocument root, Map<String, dynamic> bag) {
  final nodes = root.xpath('//catalogue/sharedSelectionEntries/selectionEntry');

  for (var node in nodes) {
    final id =  _fetchAttribute(node.attributes, 'id');
    final type = _fetchAttribute(node.attributes, 'type');
    if (type == 'upgrade') {
      final upgrades = _parseUpgrade(node, bag);
      if (upgrades.length == 1) {
        bag[id] = upgrades[0];
      }
    }
  }
}

List<Rule> _parseSharedRules(XmlDocument document, Map<String, dynamic> bag) {
  final nodes = document.xpath('//gameSystem/sharedRules/rule');
  final rules = <Rule>[];

  for (var node in nodes) {
    final id =  _fetchAttribute(node.attributes, 'id');
    final rule = Rule(
      id: id,
      name: _fetchAttribute(node.attributes, 'name'),
      description: node.xpath('./description').first.innerText,
    );
    bag[id] = rule;
    rules.add(rule);
  }

  return rules;
}

Catalogue _parseCatalogue(XmlDocument document, Map<String, dynamic> bag) {
  final node = document.xpath('//catalogue').first;

  _parseProfileLink(document, bag);
  _parseSelectionLink(document, bag);

  final catalogue = Catalogue(
    id: _fetchAttribute(node.attributes, 'id'),
    name: _fetchAttribute(node.attributes, 'name'),
    revision: _fetchAttribute(node.attributes, 'revision'),
  );

  final entries = document.xpath('//catalogue/sharedSelectionEntries/selectionEntry');
  for (var record in entries) {
    final type = _fetchAttribute(record.attributes, 'type');
    if (!['unit', 'model'].contains(type)) {
      continue;
    }

    var node = record.xpath('./profiles/profile[@typeName="Unit"]/characteristics').firstOrNull;
    final Characteristic characteristic;
    if (node == null) {
      characteristic = Characteristic.empty();
    } else {
      characteristic = Characteristic(
          m: node.xpath('./characteristic[@name="M"]').first.innerText,
          t: node.xpath('./characteristic[@name="T"]').first.innerText,
          sv: node.xpath('./characteristic[@name="SV"]').first.innerText,
          w: node.xpath('./characteristic[@name="W"]').first.innerText,
          ld: node.xpath('./characteristic[@name="LD"]').first.innerText,
          oc: node.xpath('./characteristic[@name="OC"]').first.innerText
      );
    }

    final model = Model(
      id:  _fetchAttribute(record.attributes, 'id'),
      name: _fetchAttribute(record.attributes, 'name'),
      characteristic: characteristic,
    );

    var records = record.xpath('./categoryLinks/categoryLink');
    for (var record1 in records) {
      model.categories.add(Category(
        id: _fetchAttribute(record1.attributes, 'id'),
        name: _fetchAttribute(record1.attributes, 'name'),
      ));
    }

    records = record.xpath('./profiles/profile[@typeName="Abilities"]');
    for (var record1 in records) {
      model.abilities.add(Ability(
        id: _fetchAttribute(record1.attributes, 'id'),
        name: _fetchAttribute(record1.attributes, 'name'),
        description: record1.xpath('./characteristics/characteristic').first.innerText,
      ));
    }

    records = record.xpath('./selectionEntries/selectionEntry/selectionEntryGroups/selectionEntryGroup');
    for (var record1 in records) {
      final group = UpgradeGroup(
        id: _fetchAttribute(record1.attributes, 'id'),
        name: _fetchAttribute(record1.attributes, 'name'),
      );

      final records2 = record1.xpath('./selectionEntries/selectionEntry');
      for (var record2 in records2) {
        final upgrade = _parseUpgrade(record2, bag);
        group.upgrades.addAll(upgrade);
        model.upgrades.addAll(upgrade);
      }

      model.groups.add(group);
    }

    records = record.xpath('./selectionEntryGroups/selectionEntryGroup');
    for (var record1 in records) {
      final group = UpgradeGroup(
        id: _fetchAttribute(record1.attributes, 'id'),
        name: _fetchAttribute(record1.attributes, 'name'),
      );

      final records2 = record1.xpath('./selectionEntries/selectionEntry');
      for (var record2 in records2) {
        final upgrade = _parseUpgrade(record2, bag);
        group.upgrades.addAll(upgrade);
        model.upgrades.addAll(upgrade);
      }

      model.groups.add(group);
    }

    records = record.xpath('./selectionEntries/selectionEntry[@type="model"]');
    for (var record1 in records) {
      final records2 = record1.xpath('./selectionEntries/selectionEntry');
      for (var record2 in records2) {
        model.upgrades.addAll(_parseUpgrade(record2, bag));
      }
    }

    records = record.xpath('./selectionEntries/selectionEntry[@type="upgrade"]');
    for (var record1 in records) {
      model.upgrades.addAll(_parseUpgrade(record1, bag));
    }

    records = record.xpath('./entryLinks/entryLink');
    for (var record1 in records) {
      final targetId = _fetchAttribute(record1.attributes, 'targetId');
      if (!bag.containsKey(targetId)) {
        continue;
      }
      dynamic item = bag[targetId];

      if (item is Upgrade) {
        model.upgrades.add(item);
      }
    }

    records = record.xpath('./infoLinks/infoLink');
    for (var record1 in records) {
      final targetId = _fetchAttribute(record1.attributes, 'targetId');
      if (!bag.containsKey(targetId)) {
        continue;
      }
      dynamic item = bag[targetId];

      if (item is Upgrade) {
        model.upgrades.add(item);
      } else if (item is Ability) {
        model.abilities.add(item);
      }
    }

    catalogue.models.add(model);
  }
  return catalogue;
}

class BattleScribeHttp extends IBattleScribe {
  final _bag = <String, dynamic>{};

  @override
  Future<void> fetchData(String url) async {
    final response = await http.get(
      Uri.parse(url),
    );

    if (response.statusCode == 200) {
      final document = XmlDocument.parse(response.body);
      //return _parseCatalogue(document);
    }
  }

  @override
  Future<Catalogue?> parseCatalogue(String raw) async {
    final document = XmlDocument.parse(raw);
    return _parseCatalogue(document, _bag);
  }

  @override
  Future<List<Rule>> parseRules(String raw) async {
    final document = XmlDocument.parse(raw);
    return _parseSharedRules(document, _bag);
  }
}

class BattleScribeMock extends IBattleScribe {
  final IArmyService _army = _getIt.get<IArmyService>();
  final _bag = <String, dynamic>{};

  @override
  Future fetchData(String url) async {
    await parseRules(rawDataBase);
    var catalogue = await parseCatalogue(rawAdMechData);
    if (catalogue != null) {
      await _army.setCatalogue(catalogue);
    }
    catalogue = await parseCatalogue(rawIKData);
    if (catalogue != null) {
      await _army.setCatalogue(catalogue);
    }
  }

  @override
  Future<Catalogue?> parseCatalogue(String raw) async {
    final document = XmlDocument.parse(raw);
    return _parseCatalogue(document, _bag);
  }

  @override
  Future<List<Rule>> parseRules(String raw) async {
    final document = XmlDocument.parse(raw);
    return _parseSharedRules(document, _bag);
  }
}
