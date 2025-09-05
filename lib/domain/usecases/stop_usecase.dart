import '../entities/stop.dart';
import '../repositories/stop_repository.dart';

/// Use case class responsible for managing [Stop] operations
class StopUseCase {
  /// Repository interface for interacting with stop data.
  final StopRepository repository;

  /// Creates a [StopUseCase] with the provided [repository].
  StopUseCase(this.repository);

  /// Inserts a new [Stop] into the repository.
  Future<void> insert(List<Stop> stops) => repository.insertStop(stops);

  /// Retrieves a [Stop] with the given [id] from the repository.
  Future<List<Stop>> getStopsByTravelId(int travelId) =>
      repository.getStopsByTravelId(travelId);
}
