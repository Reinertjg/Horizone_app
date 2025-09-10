import 'dart:io';

import '../entities/profile.dart';

/// Abstract repository that defines the contract for profile data operations.
abstract class ProfileRepository {

  /// Inserts a [Profile] into the data source.
  Future<void> insertProfile(Profile profile);

  /// Updates a [Profile] in the data source.
  Future<void> updateProfile(Profile profile);

  /// Updates Name [Profile] from the data source.
  Future<void> updateProfileName(int id, String name);

  /// Updates Picture [Profile] from the data source.
  Future<void> updateProfilePicture(int id, File photo);

  /// Deletes all profiles from the data source.
  Future<void> deleteTableProfile();

  /// Retrieves all profiles from the data source.
  Future<List<Profile>> getAllProfiles();
}
