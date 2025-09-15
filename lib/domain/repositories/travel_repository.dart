import '../entities/travel.dart';

/// Abstract repository that defines the contract for trip data operations.
abstract class TravelRepository {
  /// Inserts a [Travel] into the data source.
  Future<int> insertTravel(Travel travel);

  /// Deletes the trip with the given [id] from the data source.
  Future<void> deleteTravel(int id);

  /// Retrieves all trips from the data source.
  Future<List<Travel>> getAllTravels();

  /// Retrieves a trip with the given [status] from the data source.
  Future<List<Travel>> getTravelByStatus(String status);
}
