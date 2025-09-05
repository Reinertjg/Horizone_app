import '../entities/stop.dart';

/// Abstract repository that defines the contract for stop data operations.
abstract class StopRepository {
  /// Inserts a [Stop] into the data source.
  Future<void> insertStop(List<Stop> stops);

  /// Deletes the stop with the given [id] from the data source.
  Future<void> deleteStop(int id);

  /// Retrieves a stop with the given [id] from the data source.
  Future<List<Stop>> getStopsByTravelId(int travelId);
}
