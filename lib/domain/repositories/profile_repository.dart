import '../entities/profile.dart';

/// Abstract repository that defines the contract for profile data operations.
abstract class ProfileRepository {

  /// Inserts a [Profile] into the data source.
  Future<void> insertProfile(Profile profile);

  /// Deletes all profiles from the data source.
  Future<void> deleteTableProfile();

  /// Retrieves all profiles from the data source.
  Future<List<Profile>> getAllProfiles();
}
