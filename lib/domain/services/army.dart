import 'package:get_it/get_it.dart';

import '../entities/catalogue.dart';
import '../entities/model.dart';
import '../interfaces/army.dart';
import '../interfaces/repository.dart';
import '../specs/catalogue.dart';

GetIt _getIt = GetIt.instance;

class ArmyService extends IArmyService {
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
