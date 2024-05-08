import 'package:wh40k_command_center/domain/core/transfer_object.dart';
import 'package:wh40k_command_center/domain/entities/index.dart';

class FilterModelByCatalogue extends Specification<Model> {
  FilterModelByCatalogue(String id) {
    query.where(() {
      final model = Model.empty();
      model.catalogue.id = id;
      return (model, ['catalogue_id']);
    });
  }
}