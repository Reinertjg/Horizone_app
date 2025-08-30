import '../../database/daos/trip_dao.dart';
import '../../domain/entities/travel.dart';
import '../../domain/repositories/trip_repository.dart';

/// Implementation of the [TripRepository] interface.
class TripRepositoryImpl implements TripRepository {
  final TripDao _dao;

  /// Constructs a new instance of [TripRepositoryImpl].
  TripRepositoryImpl(this._dao);

  @override
  Future<void> insertTrip(Travel trip) async {
    await _dao.insertTrip(trip.toMap());
  }

  @override
  Future<void> deleteTrip(int id) async {
    await _dao.deleteTrip(id);
  }

  @override
  Future<List<Travel>> getAllTrips() async {
    final maps = await _dao.getAllTrips();
    return maps.map(Travel.fromMap).toList();
  }
}
