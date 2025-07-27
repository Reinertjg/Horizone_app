
import '../../database/daos/trip_dao.dart';
import '../../domain/entities/trip.dart';
import '../../domain/entities/profile.dart';
import '../../domain/repositories/trip_repository.dart';

class TripRepositoryImpl implements TripRepository {
  final TripDao dao;

  TripRepositoryImpl(this.dao);

  @override
  Future<void> insertTrip(Trip trip) async {
    await dao.insertTrip(trip.toMap());
  }

  @override
  Future<void> deleteTrip(int id) async {
    await dao.deleteTrip(id);
  }

  @override
  Future<List<Trip>> getAllTrips() async {
    final maps = await dao.getAllTrips();
    return maps.map((e) => Trip.fromMap(e)).toList();
  }
}