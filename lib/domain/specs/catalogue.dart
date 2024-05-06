import 'package:wh40k_command_center/domain/core/transfer_object.dart';
import 'package:wh40k_command_center/domain/entities/index.dart';

class FilterModelByCatalogue extends Specification<Model> {
  final String id;
  FilterModelByCatalogue(this.id);

  @override
  List<String> get columns => ['catalogue_id'];

  @override
  void apply() {
    query.catalogue.id = id;
  }
}