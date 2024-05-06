import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:wh40k_command_center/domain/entities/index.dart';
import 'package:wh40k_command_center/domain/interfaces/repository.dart';
import 'package:wh40k_command_center/presentation/importer/importer.dart';
import 'package:wh40k_command_center/presentation/roster/create.dart';

GetIt _getIt = GetIt.instance;

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final IRepository<Roster> _repo = _getIt<IRepository<Roster>>();
  List<Roster> _rosters = [];

  @override
  void initState() {
    super.initState();

    _getIt<IRepository<Catalogue>>().count().then((value) {
      if (value > 0) {
        _refreshData();
      } else {
        Navigator.push(context, MaterialPageRoute(builder: (context) => const ImporterPage()));
      }
    });
  }

  void _refreshData() {
    _repo.list().then((value) {
      setState(() {
        _rosters = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          IconButton(
            onPressed: () async {
              await Navigator.push(context, MaterialPageRoute(builder: (context) => const RosterCreatorPage()));
              _refreshData();
            },
            icon: const Icon(Icons.add)
          ),
        ],
      ),
      body: _parseModel(),
    );
  }

  Widget _parseModel() {
    return ListView.builder(
      itemCount: _rosters.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(_rosters[index].name),
          onTap: () {
          },
        );
      }
    );
  }
}
