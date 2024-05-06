import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:wh40k_command_center/domain/interfaces/api_context.dart';
import 'package:wh40k_command_center/domain/interfaces/army.dart';
import 'package:wh40k_command_center/domain/interfaces/battlescribe.dart';
import 'package:wh40k_command_center/domain/interfaces/repository.dart';
import 'package:wh40k_command_center/infrastructure/data/db_context.dart';
import 'package:wh40k_command_center/infrastructure/data/db_repository.dart';
import 'package:wh40k_command_center/infrastructure/externals/battlescribe.dart';
import 'package:wh40k_command_center/infrastructure/services/army.dart';
import 'package:wh40k_command_center/presentation/home/home.dart';
import 'domain/entities/index.dart';

GetIt getIt = GetIt.instance;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  getIt.registerSingletonAsync<ApiContext>(() async {
    var instance = DatabaseContext();
    await instance.initialize();
    return instance;
  });

  await getIt.allReady();

  getIt.registerFactory<IRepository<Roster>>(() => DatabaseRepository<Roster>());
  getIt.registerFactory<IRepository<Catalogue>>(() => DatabaseRepository<Catalogue>());
  getIt.registerFactory<IRepository<Model>>(() => DatabaseRepository<Model>());
  getIt.registerSingleton<IArmyService>(ArmyDatabase());
  getIt.registerSingleton<IBattleScribe>(BattleScribeMock());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}
