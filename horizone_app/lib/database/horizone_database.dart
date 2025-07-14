import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'tables/profile_table.dart';

class HorizoneDatabase {
  static final HorizoneDatabase _instance = HorizoneDatabase._internal();
  factory HorizoneDatabase() => _instance;

  HorizoneDatabase._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB("horizone.db");
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute(ProfileTable.createTable);
  }
}
