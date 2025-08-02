import '../../database/horizone_database.dart';
import '../../database/tables/profile_table.dart';
import '../../domain/entities/profile.dart';
import '../../domain/repositories/profile_repository.dart';

/// Implementation of the [ProfileRepository] interface.
class ProfileRepositoryImpl implements ProfileRepository {
  final _dbFuture = HorizoneDatabase().database;

  @override
  Future<int> insertProfile(Profile profile) async {
    final db = await _dbFuture;
    return await db.insert(ProfileTable.tableName, profile.toMap());
  }

  @override
  Future<List<Profile>> getAllProfiles() async {
    final db = await _dbFuture;
    final result = await db.query(ProfileTable.tableName);
    return result.map(Profile.fromMap).toList();
  }

  @override
  Future<void> deleteTableProfile() async {
    final db = await _dbFuture;
    await db.delete(ProfileTable.tableName);
  }
}
