import '../entities/participant.dart';
import '../repositories/participant_repository.dart';

/// Use case class responsible for managing [Participant] operations
/// such as insertion and retrieval.
class ParticipantUseCase {

  /// Repository interface for interacting with trip data.
  final ParticipantRepository repository;

  /// Creates an [ParticipantUseCase] with the provided [repository].
  ParticipantUseCase(this.repository);

  /// Inserts a new [Participant] into the repository.
  Future<void> insert(List<Participant> participant) =>
      repository.insertParticipants(participant);

  /// Deletes the participant with the given [id] from the repository.
  Future<void> delete(int id) => repository.deleteParticipant(id);

  /// Retrieves all [Participant] records from the repository.
  Future<List<Participant>> getParticipantsByTravelId(int travelId) =>
      repository.getParticipantsByTravelId(travelId);
}
