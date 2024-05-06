import '../entities/roster.dart';

abstract class IRosterService {
  Future<List<Roster>> listRosters();
}