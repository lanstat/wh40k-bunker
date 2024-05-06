import 'package:get_it/get_it.dart';
import 'package:wh40k_command_center/domain/entities/index.dart';
import 'package:wh40k_command_center/domain/interfaces/army.dart';
import 'package:wh40k_command_center/domain/interfaces/repository.dart';
import 'package:wh40k_command_center/domain/specs/catalogue.dart';

GetIt _getIt= GetIt.instance;

class ArmyMemory extends IArmyService {
  final List<Catalogue> _list = [];

  @override
  Future<Model> getModel(String id) async {
    for (var catalogue in _list) {
      var model = catalogue.models.where((element) => element.id == id).firstOrNull;
      if (model != null) {
        return model;
      }
    }
    return Model.empty();
  }

  @override
  Future<void> setCatalogue(Catalogue record) async {
    _list.add(record);
  }

  @override
  Future<List<Catalogue>> listCatalogues() async {
    return _list;
  }

  @override
  Future<List<Model>> listModels(String id) async {
    return _list.firstWhere((element) => element.id == id).models;
  }
}

class ArmyDatabase extends IArmyService {
  final _catalogueRepo = _getIt<IRepository<Catalogue>>();
  final _modelRepo = _getIt<IRepository<Model>>();

  @override
  Future<Model> getModel(String id) async {
    var record = await _modelRepo.get(id);
    if (record == null) {
      return Model.empty();
    }
    return record;
  }

  @override
  Future<List<Catalogue>> listCatalogues() {
    return _catalogueRepo.list();
  }

  @override
  Future<List<Model>> listModels(String id) {
    return _modelRepo.filter(FilterModelByCatalogue(id));
  }

  @override
  Future<void> setCatalogue(Catalogue record) async {
    await _catalogueRepo.insert(record);

    for (var model in record.models) {
      model.catalogue = record;
      await _modelRepo.insert(model);
    }
  }
}