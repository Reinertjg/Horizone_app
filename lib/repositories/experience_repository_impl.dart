import '../database/horizone_database.dart';
import '../database/tables/experience_table.dart';
import '../domain/entities/experience.dart';
import '../domain/repositories/experience_repository.dart';

/// Implementation of the [ExperienceRepository] interface.
class ExperienceRepositoryImpl implements ExperienceRepository {
  final _dbFuture = HorizoneDatabase().database;

  @override
  Future<void> insertExperience(Experience experience) async {
    final db = await _dbFuture;
    await db.insert('experiences', experience.toMap());
  }

  @override
  Future<void> updateExperience(Experience experience) async {
    final db = await _dbFuture;
    await db.update(
      ExperienceTable.tableName,
      experience.toMap(),
      where: '${ExperienceTable.experienceId} = ?',
      whereArgs: [experience.id],
    );
  }

  @override
  Future<List<Experience>> getExperiencesByStopId(int stopId) async {
    final db = await _dbFuture;
    return db
        .query(
          ExperienceTable.tableName,
          where: '${ExperienceTable.stopId} = ?',
          whereArgs: [stopId],
        )
        .then((result) {
          return result.map(Experience.fromMap).toList();
        });
  }

  @override
  Future<List<Experience>> getAllExperiences() async {
    final db = await _dbFuture;
    return db
        .query(
          ExperienceTable.tableName,
        )
        .then((result) => result.map(Experience.fromMap).toList());
  }
}
