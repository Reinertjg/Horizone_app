import 'dart:io';

import '../entities/profile.dart';
import '../repositories/profile_repository.dart';

/// Use case class responsible for handling business logic related to [Profile].
class ProfileUseCase {
  /// The repository used to access profile data.
  final ProfileRepository repository;

  /// Creates a [ProfileUseCase] with the given [repository].
  ProfileUseCase(this.repository);

  /// Inserts a new [profile] into the data source.
  Future<void> insert(Profile profile) => repository.insertProfile(profile);

  /// Updates an existing [profile] in the data source.
  Future<void> updateProfile(Profile profile) =>
      repository.updateProfile(profile);

  /// Updates the name of an existing [profile] in the data source.
  Future<void> updateName(int id, String name) =>
      repository.updateProfileName(id, name);

  /// Updates the picture of an existing [profile] in the data source.
  Future<void> updatePicture(int id, File photo) =>
      repository.updateProfilePicture(id, photo);

  /// Deletes all profile entries from the data source.
  Future<void> delete() => repository.deleteTableProfile();

  /// Retrieves all profiles from the data source.
  Future<List<Profile>> getAll() => repository.getAllProfiles();
}
