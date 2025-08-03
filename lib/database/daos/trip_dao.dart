
import 'package:flutter/cupertino.dart';
import '../horizone_database.dart';
import '../tables/trips_table.dart';

/// A class representing a trip.
class TripDao extends ChangeNotifier {
  final _dbFuture = HorizoneDatabase().database;

  /// Inserts a new trip into the database.
  Future<List<Map<String, Object?>>> getAllTrips() async {
    final db = await _dbFuture;
    return await db.query(TripTable.tableName);
  }

  /// Inserts a new trip into the database.
  Future<int> insertTrip(Map<String, dynamic> trip) async {
    final db = await _dbFuture;
    return await db.insert(TripTable.tableName, {
      'title': trip['title'],
      'startDate': trip['startDate'],
      'endDate': trip['endDate'],
      'meansOfTransportation': trip['meansOfTransportation'],
      'numberOfParticipants': trip['numberOfParticipants'],
      'experienceType': trip['experienceType'],
    });
  }

  /// Deletes a trip from the database.
  Future<int> deleteTrip(int id) async {
    final db = await _dbFuture;
    return await db
        .delete(TripTable.tableName, where: 'id = ?', whereArgs: [id]);
  }
}