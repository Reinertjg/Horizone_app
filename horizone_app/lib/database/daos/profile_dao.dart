//
// import 'package:flutter/material.dart';
// import 'package:horizone_app/database/horizone_database.dart';
// import 'package:horizone_app/database/tables/profile_table.dart';
//
// class ProfileDao extends ChangeNotifier{
//   final dbFuture = HorizoneDatabase().database;
//
//   Future<int> insertProfile(Map<String, dynamic> profile) async {
//     final db = await dbFuture;
//     return await db.insert(ProfileTable.tableName, {
//       'name': profile['name'],
//       'biography': profile['biography'],
//       'birthDate': profile['birthDate'],
//       'gender': profile['gender'],
//       'job_title': profile['jobTitle'],
//     });
//   }
//
//   Future<List<Map<String, Object?>>> getProfile() async {
//     final db = await dbFuture;
//     return await db.query(ProfileTable.tableName);
//   }
//
//   Future<void> deleteTableProfile() async {
//     final db = await dbFuture;
//     await db.delete(
//       ProfileTable.tableName,
//     );
//   }
// }