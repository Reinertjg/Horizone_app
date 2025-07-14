class ProfileTable {
  static const tableName = 'profiles';

  static const createTable = '''
    CREATE TABLE $tableName (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      biography TEXT UNIQUE NOT NULL,
      date_of_birth TEXT NOT NULL,
      gender TEXT NOT NULL,
      job_title TEXT NOT NULL,
    )
  ''';
}
