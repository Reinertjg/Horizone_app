import 'dart:io';

import '../../database/horizone_database.dart';
import '../../database/tables/profile_table.dart';
import '../../domain/entities/profile.dart';
import '../../domain/repositories/profile_repository.dart';

/// Implementation of the [ProfileRepository] interface.
class ProfileRepositoryImpl implements ProfileRepository {
  final _dbFuture = HorizoneDatabase().database;

  @override
  Future<int> insertProfile(Profile profile) async {
    final db = await _dbFuture;
    return await db.insert(ProfileTable.tableName, profile.toMap());
  }

  @override
  Future<void> updateProfile(Profile profile) async {
    final db = await _dbFuture;
    final map = profile.toMap();
    map.remove(ProfileTable.pathPhoto);
    await db.update(
      ProfileTable.tableName,
      map,
      where: '${ProfileTable.profileId} = ?',
      whereArgs: [profile.id],
    );
  }

  @override
  Future<void> updateProfileName(int id, String name) async {
    final db = await _dbFuture;
    await db.update(
      ProfileTable.tableName,
      {'name': name},
      where: '${ProfileTable.profileId} = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<void> updateProfilePicture(int id, File photo) async {
    final db = await _dbFuture;
    await db.update(
      ProfileTable.tableName,
      {'photo': photo.path},
      where: '${ProfileTable.profileId} = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<void> deleteTableProfile() async {
    final db = await _dbFuture;
    await db.delete(ProfileTable.tableName);
  }

  @override
  Future<List<Profile>> getAllProfiles() async {
    final db = await _dbFuture;
    final result = await db.query(ProfileTable.tableName);
    return result.map(Profile.fromMap).toList();
  }
}
