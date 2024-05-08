import 'package:wh40k_command_center/domain/entities/index.dart';

import '../core/transfer_object.dart';

class FilterAbilityByModel extends Specification<Ability> {
  FilterAbilityByModel(String id) {
    query.where(() {
      final instance = Ability.empty();
      instance.model.id = id;
      return (instance, ['model_id']);
    });
  }
}

class FilterCategoryByModel extends Specification<Category> {
  FilterCategoryByModel(String id) {
    query.where(() {
      final instance = Category.empty();
      instance.model.id = id;
      return (instance, ['model_id']);
    });
  }
}
