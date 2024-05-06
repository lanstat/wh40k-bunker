import '../entities/index.dart';

typedef ItemCreator<T> = T Function();

abstract class ApiContext {
  final Map<Type, ItemCreator<dynamic>> _sets = {};

  T getInstance<T>() {
    return _sets[T]!();
  }

  Future<void> initialize() async {
    _sets[Category] = () => Category.empty();
    _sets[Catalogue] = () => Catalogue.empty();
    _sets[Roster] = () => Roster.empty();
    _sets[Model] = () => Model.empty();
  }

  dynamic get context;
}