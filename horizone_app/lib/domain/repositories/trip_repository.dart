import '../entities/trip.dart';

/// Abstract repository that defines the contract for trip data operations.
abstract class TripRepository {

  /// Inserts a [Trip] into the data source.
  Future<void> insertTrip(Trip trip);

  /// Deletes the trip with the given [id] from the data source.
  Future<void> deleteTrip(int id);

  /// Retrieves all trips from the data source.
  Future<List<Trip>> getAllTrips();
}
