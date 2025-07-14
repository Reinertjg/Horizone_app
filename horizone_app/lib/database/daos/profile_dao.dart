
import 'package:horizone_app/database/horizone_database.dart';
import 'package:horizone_app/database/tables/profile_table.dart';

class ProfileDao {
  final dbFuture = HorizoneDatabase().database;

  Future<int> insertPorfile(Map<String, dynamic> profile) async {
    final db = await dbFuture;
    return await db.insert(ProfileTable.tableName, profile);
  }

  Future<List<Map<String, dynamic>>> getProfile() async {
    final db = await dbFuture;
    return await db.query(ProfileTable.tableName);
  }
}