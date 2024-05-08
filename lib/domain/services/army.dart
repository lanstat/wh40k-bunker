import 'package:get_it/get_it.dart';
import 'package:wh40k_command_center/domain/specs/model.dart';

import '../entities/index.dart';
import '../interfaces/army.dart';
import '../interfaces/repository.dart';
import '../specs/catalogue.dart';

GetIt _getIt = GetIt.instance;

class ArmyService extends IArmyService {
  final _catalogueRepo = _getIt<IRepository<Catalogue>>();
  final _modelRepo = _getIt<IRepository<Model>>();
  final _categoryRepo = _getIt<IRepository<Category>>();
  final _abilityRepo = _getIt<IRepository<Ability>>();

  @override
  Future<Model> getModel(String id) async {
    var record = await _modelRepo.get(id);
    if (record == null) {
      return Model.empty();
    }

    /*
    record.abilities.addAll(await _abilityRepo.filter(FilterAbilityByModel(id)));
    record.categories.addAll(await _categoryRepo.filter(FilterCategoryByModel(id)));
    */

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

      /*
      for (var category in model.categories) {
        category.model = model;
        await _categoryRepo.insert(category);
      }

      for (var ability in model.abilities) {
        ability.model = model;
        await _abilityRepo.insert(ability);
      }
      */
    }
  }

  @override
  Future<Catalogue> getCatalogue(String id) async {
    var record = await _catalogueRepo.get(id);
    if (record == null) {
      return Catalogue.empty();
    }
    return record;
  }
}
