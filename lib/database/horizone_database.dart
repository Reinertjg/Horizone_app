import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

import 'tables/participants_table.dart';
import 'tables/profile_table.dart';
import 'tables/travel_table.dart';

/// A class representing a trip.
class HorizoneDatabase {
  static final HorizoneDatabase _instance = HorizoneDatabase._internal();

  /// A singleton instance of [HorizoneDatabase].
  factory HorizoneDatabase() => _instance;

  HorizoneDatabase._internal();

  static Database? _database;

  /// A singleton instance of [HorizoneDatabase].
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('horizone.db');
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    final dbPath = await getDatabasesPath();
    final path = p.join(dbPath, fileName);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
      onConfigure: (onConfigure) async {
        await onConfigure.execute('PRAGMA foreign_keys = ON');
      }
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute(ProfileTable.createTable);
    await db.execute(TravelTable.createTable);
    await db.execute(ParticipantTable.createTable);
  }
}
