
import 'package:horizone_app/database/horizone_database.dart';
import 'package:horizone_app/database/tables/profile_table.dart';

class ProfileDao {
  final dbFuture = HorizoneDatabase().database;

  Future<int> insertPorfile(Map<String, dynamic> profile) async {
    final db = await dbFuture;
    return await db.insert(ProfileTable.tableName, {
      'name': profile['name'],
      'biography': profile['biography'],
      'birthDate': profile['birthDate'],
      'gender': profile['gender'],
      'job_title': profile['jobTitle'],
    });
  }

  Future<List<Map<String, dynamic>>> getProfile() async {
    final db = await dbFuture;
    return await db.query(ProfileTable.tableName);
  }

  Future<void> deleteProfile() async {
    final db = await dbFuture;
    await db.delete(
      ProfileTable.tableName,
    );
  }
}