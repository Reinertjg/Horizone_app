import '../entities/profile.dart';
import '../repositories/profile_repository.dart';

class ProfileUseCase {
  final ProfileRepository repository;

  ProfileUseCase(this.repository);

  Future<void> insert(Profile profile) => repository.insertProfile(profile);

  Future<void> delete() => repository.deleteTableProfile();

  Future<List<Profile>> getAll() => repository.getAllProfiles();
}
