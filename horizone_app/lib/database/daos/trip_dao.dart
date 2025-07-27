
import 'package:flutter/cupertino.dart';
import 'package:horizone_app/database/horizone_database.dart';
import '../tables/trips_table.dart';

class TripDao extends ChangeNotifier {
  final dbFuture = HorizoneDatabase().database;

  Future<List<Map<String, Object?>>> getAllTrips() async {
    final db = await dbFuture;
    return await db.query(TripTable.tableName);
  }

  Future<int> insertTrip(Map<String, dynamic> trip) async {
    final db = await dbFuture;
    return await db.insert(TripTable.tableName, {
      'title': trip['title'],
      'startDate': trip['startDate'],
      'endDate': trip['endDate'],
      'meansOfTransportation': trip['meansOfTransportation'],
      'numberOfParticipants': trip['numberOfParticipants'],
      'experienceType': trip['experienceType'],
    });
  }

  Future<int> deleteTrip(int id) async {
    final db = await dbFuture;
    return await db.delete(TripTable.tableName, where: 'id = ?', whereArgs: [id]);
  }
}