import '../entities/trip.dart';
import '../repositories/trip_repository.dart';

/// Use case class responsible for managing [Trip] operations
/// such as insertion and retrieval.
class InterviewUseCase {
  /// Repository interface for interacting with trip data.
  final TripRepository repository;

  /// Creates an [InterviewUseCase] with the provided [repository].
  InterviewUseCase(this.repository);

  /// Inserts a new [Trip] into the repository.
  Future<void> insert(Trip trip) => repository.insertTrip(trip);

  /// Retrieves all [Trip] records from the repository.
  Future<List<Trip>> getAll() => repository.getAllTrips();
}
