import 'package:wh40k_command_center/domain/core/transfer_object.dart';
import 'package:wh40k_command_center/domain/entities/index.dart';

class FilterModelByCatalogue extends Specification<Model> {
  FilterModelByCatalogue(String id) {
    query.catalogue.id = id;
  }

  @override
  List<String> get columns => ['catalogue_id'];
}