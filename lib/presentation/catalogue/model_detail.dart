import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:wh40k_command_center/domain/entities/model.dart';
import 'package:wh40k_command_center/domain/entities/upgrade.dart';
import 'package:wh40k_command_center/domain/interfaces/army.dart';

GetIt _getIt = GetIt.instance;

class ModelDetailPage extends StatefulWidget {
  const ModelDetailPage({super.key, required this.id});

  final String id;

  @override
  State<ModelDetailPage> createState() => _ScreenState();
}

class _ScreenState extends State<ModelDetailPage> {
  final IArmyService _army = _getIt<IArmyService>();
  final List<bool> _isOpen = [false, false, false];
  Model _model = Model.empty();

  @override
  void initState() {
    super.initState();
    _army.getModel(widget.id).then((value) {
      setState(() {
        _model = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var widgets = <Widget>[];
    widgets.add(Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _characteristicColumn('M', _model.characteristic.m),
        _characteristicColumn('T', _model.characteristic.t),
        _characteristicColumn('SV', _model.characteristic.sv),
        _characteristicColumn('W', _model.characteristic.w),
        _characteristicColumn('LD', _model.characteristic.ld),
        _characteristicColumn('OC', _model.characteristic.oc),
      ],
    ));

    widgets.add(ExpansionPanelList(
      children: [
        ExpansionPanel(
          isExpanded: _isOpen[0],
          headerBuilder: (context, isOpen) {
            return const Text('Range weapons');
          },
          body: _parseUpgrades(_model.upgrades.where((element) => element.type == UpgradeType.range).toList())
        ),
        ExpansionPanel(
            isExpanded: _isOpen[1],
            headerBuilder: (context, isOpen) {
              return const Text('Melee weapons');
            },
            body: _parseUpgrades(_model.upgrades.where((element) => element.type == UpgradeType.melee).toList())
        )
      ],
      expansionCallback: (index, isOpen) {
        setState(() {
          _isOpen[index] = !isOpen;
        });
      },
    ));

    widgets.add(const Text('Abilities'));
    for (var record in _model.abilities) {
      widgets.add(
        Text(record.name)
      );
      widgets.add(
          Text(record.description)
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(_model.name),
      ),
      body: ListView(
        children: widgets,
      ),
    );
  }

  Widget _characteristicColumn(String type, String value) {
    return Column(
      children: [
        Text(type),
        Text(value)
      ],
    );
  }

  Widget _parseUpgrades(List<Upgrade> upgrades) {
    List<Widget> widgets = [];
    for (var record in upgrades) {
      widgets.add(
          Text(record.name)
      );
      widgets.add(Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _characteristicColumn('Range', record.characteristic.range),
          _characteristicColumn('A', record.characteristic.a),
          _characteristicColumn('BS', record.characteristic.skill),
          _characteristicColumn('S', record.characteristic.s),
          _characteristicColumn('AP', record.characteristic.ap),
          _characteristicColumn('D', record.characteristic.d),
        ],
      ));
      if (record.characteristic.keywordsParsed.isNotEmpty) {
        widgets.add(Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: record.characteristic.keywordsParsed.map((e) {
            return Text(e);
          }).toList(),
        ));
      }
    }

    return Column(
      children: widgets,
    );
  }
}
