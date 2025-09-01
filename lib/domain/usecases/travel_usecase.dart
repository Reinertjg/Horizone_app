import '../entities/travel.dart';
import '../repositories/travel_repository.dart';

/// Use case class responsible for managing [Travel] operations
/// such as insertion and retrieval.
class TravelUseCase {
  /// Repository interface for interacting with trip data.
  final TravelRepository repository;

  /// Creates an [TravelUseCase] with the provided [repository].
  TravelUseCase(this.repository);

  /// Inserts a new [Travel] into the repository.
  Future<void> insert(Travel trip) => repository.insertTravel(trip);

  /// Retrieves all [Travel] records from the repository.
  Future<List<Travel>> getAll() => repository.getAllTravels();

  /// Retrieves a [Travel] record with the given [status] from the repository.
  Future<List<Travel>> getTravelByStatus(String status) =>
      repository.getTravelByStatus(status);
}
