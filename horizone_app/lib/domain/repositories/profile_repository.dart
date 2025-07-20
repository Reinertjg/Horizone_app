import '../entities/profile.dart';

abstract class ProfileRepository {
  Future<void> insertProfile(Profile profile);
  Future<void> deleteTableProfile();
  Future<List<Profile>> getAllProfiles();
}
