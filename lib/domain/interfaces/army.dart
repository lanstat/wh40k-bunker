import '../entities/index.dart';

abstract class IArmyService {
  Future<List<Catalogue>> listCatalogues();

  Future<void> setCatalogue(Catalogue record);

  Future<List<Model>> listModels(String id);

  Future<Model> getModel(String id);
}