import 'package:sqflite/sqflite.dart';

import '../../database/horizone_database.dart';
import '../database/tables/participants_table.dart';
import '../domain/entities/participant.dart';
import '../domain/repositories/participant_repository.dart';

/// Implementation of the [ParticipantRepository] interface.
class ParticipantRepositoryImpl implements ParticipantRepository {
  final _dbFuture = HorizoneDatabase().database;

  /// Inserts a [Participant] into the data source.
  @override
  Future<void> insertParticipants(List<Participant> participants) async {
    if (participants.isEmpty) return;

    final db = await _dbFuture;
    await db.transaction((txn) async {
      final batch = txn.batch();
      for (final participant in participants) {
        batch.insert(
          ParticipantTable.tableName,
          participant.toMap(),
          conflictAlgorithm: ConflictAlgorithm.abort,
        );
      }
      await batch.commit(noResult: true);
    });
  }

  /// Deletes the participant with the given [id] from the data source.
  @override
  Future<void> deleteParticipant(int id) async {
    final db = await _dbFuture;
    await db.delete(
      ParticipantTable.tableName,
      where: '${ParticipantTable.participantId} = ?',
      whereArgs: [id],
    );
  }

  /// Retrieves all participants with the given [travelId] from the data source.
  @override
  Future<List<Participant>> getParticipantsByTravelId(int travelId) async {
    final db = await _dbFuture;
    final result = await db.query(
      ParticipantTable.tableName,
      where: '${ParticipantTable.travelId} = ?',
      whereArgs: [travelId],
    );
    return result.map(Participant.fromMap).toList();
  }
}
