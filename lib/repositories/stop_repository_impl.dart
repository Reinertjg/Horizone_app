import 'package:sqflite/sqflite.dart';

import '../database/horizone_database.dart';
import '../database/tables/stop_table.dart';
import '../domain/entities/stop.dart';
import '../domain/repositories/stop_repository.dart';

/// Implementation of the [StopRepository] interface.
class StopRepositoryImpl implements StopRepository {
  final _dbFuture = HorizoneDatabase().database;

  @override
  Future<void> insertStop(List<Stop> stops) async {
    if (stops.isEmpty) return;

    final db = await _dbFuture;
    await db.transaction((txn) async {
      final batch = txn.batch();
      for (final stop in stops) {
        batch.insert(
          StopTable.tableName,
          stop.toMap(),
          conflictAlgorithm: ConflictAlgorithm.abort,
        );
      }
      await batch.commit(noResult: true);
    });
  }

  @override
  Future<void> deleteStop(int id) async {
    final db = await _dbFuture;
    await db.delete('stops', where: 'id = ?', whereArgs: [id]);
  }

  @override
  Future<List<Stop>> getStopsByTravelId(int travelId) async {
    final db = await _dbFuture;
    final result = await db.query(
      StopTable.tableName,
      where: '${StopTable.travelId} = ?',
      whereArgs: [travelId],
    );
    return result.map(Stop.fromMap).toList();
  }
}
