import '../../database/horizone_database.dart';
import '../../database/tables/travel_table.dart';
import '../../domain/entities/travel.dart';
import '../../domain/repositories/travel_repository.dart';

/// Implementation of the [TravelRepository] interface.
class TravelRepositoryImpl implements TravelRepository {
  final _dbFuture = HorizoneDatabase().database;

  /// Inserts a [Travel] into the data source.
  @override
  Future<int> insertTravel(Travel travel) async {
    final db = await _dbFuture;
    return await db.insert(TravelTable.tableName, travel.toMap());
  }

  /// Deletes the trip with the given [id] from the data source.
  @override
  Future<void> deleteTravel(int id) async {
    final db = await _dbFuture;
    await db.delete(
      TravelTable.tableName,
      where: '${TravelTable.travelId} = ?',
      whereArgs: [id],
    );
  }

  /// Retrieves all trips from the data source.
  @override
  Future<List<Travel>> getAllTravels() async {
    final db = await _dbFuture;
    final result = await db.query(TravelTable.tableName);
    return result.map(Travel.fromMap).toList();
  }

  /// Retrieves a trip with the given [status] from the data source.
  @override
  Future<List<Travel>> getTravelByStatus(String status) async {
    final db = await _dbFuture;
    final result = await db.query(
      TravelTable.tableName,
      where: '${TravelTable.status} = ?',
      whereArgs: [status],
    );
    return result.map(Travel.fromMap).toList();
  }
}
