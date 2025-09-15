import 'dart:io';

import '../entities/experience.dart';
import '../repositories/experience_repository.dart';

/// This class interacts with the [ExperienceRepository]
/// to perform CRUD operations on [Experience] entities.
class ExperienceUseCase {
  /// The repository that this use case will interact with.
  final ExperienceRepository repository;

  /// Creates an instance of [ExperienceUseCase].
  ExperienceUseCase(this.repository);

  /// Inserts a new [experience] into the repository.
  Future<void> insertExperience(Experience experience) {
    _validateExperience(experience);
    return repository.insertExperience(experience);
  }

  /// Updates an existing [experience] in the repository.
  Future<void> updateExperience(Experience experience) {
    _validateExperience(experience);
    return repository.updateExperience(experience);
  }

  /// Retrieves a list of experiences associated with a given [stopId].
  Future<List<Experience>> getExperiencesByStopId(int stopId) =>
      repository.getExperiencesByStopId(stopId);

  /// Retrieves a list of all experiences in the repository.
  Future<List<Experience>> getAllExperiences() =>
      repository.getAllExperiences();

  /// Validation
  void _validateExperience(Experience experience) {
    var photos = <File?>[
      experience.photo1,
      experience.photo2,
      experience.photo3,
    ];
    final text = experience.description.trim();
    if (text.isEmpty) {
      throw ArgumentError('experience.description não pode ser vazio');
    }

    final normalized = text.replaceAll(RegExp(r'\s+'), ' ');
    if (normalized.length < 20) {
      throw ArgumentError(
        'experience.description deve ter no mínimo 20 caracteres',
      );
    }
    if (photos.isEmpty) {
      throw ArgumentError('experience.photos não pode ser vazio');
    }
  }
}
