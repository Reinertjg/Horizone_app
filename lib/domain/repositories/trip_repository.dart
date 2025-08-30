import '../entities/travel.dart';

/// Abstract repository that defines the contract for trip data operations.
abstract class TripRepository {

  /// Inserts a [Travel] into the data source.
  Future<void> insertTrip(Travel trip);

  /// Deletes the trip with the given [id] from the data source.
  Future<void> deleteTrip(int id);

  /// Retrieves all trips from the data source.
  Future<List<Travel>> getAllTrips();
}
