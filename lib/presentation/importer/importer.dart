import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../domain/interfaces/army.dart';
import '../../domain/interfaces/battlescribe.dart';

GetIt _getIt = GetIt.instance;

class ImporterPage extends StatefulWidget {
  const ImporterPage({super.key});

  @override
  State<ImporterPage> createState() => _InitPageState();
}

class _InitPageState extends State<ImporterPage> {
  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  void _refreshData() {
    _getIt<IBattleScribe>().fetchData('https://github.com/BSData/wh40k-10e/archive/refs/heads/main.zip').then((value) async {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Importacion completada')));
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Importacion de catalogos'),
      ),
      body: const Center(
        child: Text('Procesando'),
      ),
    );
  }
}
