import '../entities/trip.dart';
import '../entities/profile.dart';

abstract class TripRepository {
  Future<void> insertTrip(Trip trip);
  Future<void> deleteTrip(int id);
  Future<List<Trip>> getAllTrips();
}