
import '../entities/participant.dart';

/// Abstract repository that defines the contract for trip data operations.
abstract class ParticipantRepository {

  /// Inserts a [Participant] into the data source.
  Future<void> insertParticipants(List<Participant> participant);

  /// Deletes the participant with the given [id] from the data source.
  Future<void> deleteParticipant(int id);

  /// Retrieves all participants from the data source.
  Future<List<Participant>> getAllParticipants(int travelId);

}