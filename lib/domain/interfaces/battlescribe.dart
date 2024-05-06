import '../entities/catalogue.dart';
import '../entities/rule.dart';

abstract class IBattleScribe {
  Future<Catalogue?> parseCatalogue(String raw);
  Future<List<Rule>> parseRules(String raw);
  Future<void> fetchData(String url);
}