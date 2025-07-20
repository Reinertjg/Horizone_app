import '../../database/daos/profile_dao.dart';
import '../../domain/entities/profile.dart';
import '../../domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileDao dao;

  ProfileRepositoryImpl(this.dao);

  @override
  Future<void> insertProfile(Profile profile) async {
    await dao.insertProfile(profile.toMap());
  }

  @override
  Future<void> deleteTableProfile() async {
    await dao.deleteTableProfile();
  }

  @override
  Future<List<Profile>> getAllProfiles() async {
    final maps = await dao.getProfile();
    return maps.map((e) => Profile.fromMap(e)).toList();
  }
}
