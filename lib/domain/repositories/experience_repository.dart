import '../entities/experience.dart';

/// An abstract repository for managing user experiences related to stops.
abstract class ExperienceRepository {
  /// Inserts a new [experience] into the repository.
  Future<void> insertExperience(Experience experience);

  /// Updates an existing [experience] in the repository.
  Future<void> updateExperience(Experience experience);

  /// Retrieves a list of [Experience]s associated with a given [stopId].
  Future<List<Experience>> getExperiencesByStopId(int stopId);

  /// Retrieves a list of all [Experience]s in the repository.
  Future<List<Experience>> getAllExperiences();
}
