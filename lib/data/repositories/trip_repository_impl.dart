import '../../database/daos/trip_dao.dart';
import '../../domain/entities/trip.dart';
import '../../domain/repositories/trip_repository.dart';

/// Implementation of the [TripRepository] interface.
class TripRepositoryImpl implements TripRepository {
  final TripDao _dao;

  /// Constructs a new instance of [TripRepositoryImpl].
  TripRepositoryImpl(this._dao);

  @override
  Future<void> insertTrip(Trip trip) async {
    await _dao.insertTrip(trip.toMap());
  }

  @override
  Future<void> deleteTrip(int id) async {
    await _dao.deleteTrip(id);
  }

  @override
  Future<List<Trip>> getAllTrips() async {
    final maps = await _dao.getAllTrips();
    return maps.map(Trip.fromMap).toList();
  }
}
