import '../core/transfer_object.dart';

abstract class IRepository<T extends ITable> {
  Future<T?> get(dynamic id);
  Future<List<T>> list();
  Future<List<T>> filter(Specification<T> spec);
  Future<void> insert(T record);
  Future<void> update(T record);
  Future<void> delete(T record);
  Future<int> count();
}