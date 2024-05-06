import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:wh40k_command_center/domain/entities/index.dart';
import 'package:wh40k_command_center/domain/interfaces/army.dart';
import 'package:wh40k_command_center/domain/interfaces/repository.dart';
import 'package:wh40k_command_center/presentation/importer/importer.dart';
import 'package:wh40k_command_center/presentation/roster/create.dart';

GetIt _getIt = GetIt.instance;

class CatalogueViewerPage extends StatefulWidget {
  const CatalogueViewerPage({super.key, required this.catalogueId});

  final String catalogueId;

  @override
  State<CatalogueViewerPage> createState() => _ScreenState();
}

class _ScreenState extends State<CatalogueViewerPage> {
  final _repo = _getIt<IArmyService>();
  List<Model> _models = [];

  @override
  void initState() {
    super.initState();

    _repo.listModels(widget.catalogueId).then((value) {
      setState(() {
        _models.addAll(value);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Models'),
        actions: [
          IconButton(
              onPressed: () async {
                await Navigator.push(context, MaterialPageRoute(builder: (context) => const RosterCreatorPage()));
              },
              icon: const Icon(Icons.add)
          ),
        ],
      ),
      body: ListView.builder(
          itemCount: _models.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(_models[index].name),
              onTap: () {
              },
            );
          }
      )
    );
  }
}
