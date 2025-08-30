import '../entities/travel.dart';
import '../repositories/trip_repository.dart';

/// Use case class responsible for managing [Travel] operations
/// such as insertion and retrieval.
class InterviewUseCase {
  /// Repository interface for interacting with trip data.
  final TripRepository repository;

  /// Creates an [InterviewUseCase] with the provided [repository].
  InterviewUseCase(this.repository);

  /// Inserts a new [Travel] into the repository.
  Future<void> insert(Travel trip) => repository.insertTrip(trip);

  /// Retrieves all [Travel] records from the repository.
  Future<List<Travel>> getAll() => repository.getAllTrips();
}
