/// Contains constants and SQL statement related to the `experiences`
/// table schema.
abstract class ExperienceTable {
  /// Private constructor to prevent instantiation.
  static const tableName = 'experiences';

  /// Primary key (auto-incremented integer)
  static const String experienceId = 'id';

  /// Description of the experience (text, required)
  static const String description = 'description';

  /// Path to the first photo of the experience (text)
  static const String photo1 = 'photo1';

  /// Path to the second photo of the experience (text)
  static const String photo2 = 'photo2';

  /// Path to the third photo of the experience (text)
  static const String photo3 = 'photo3';

  /// Foreign key referencing the `stops` table (integer, required)
  static const String stopId = 'stopId';

  /// SQL statement to create the `experiences` table with the defined schema.
  static const createTable =
      '''
    CREATE TABLE $tableName (
      $experienceId INTEGER PRIMARY KEY AUTOINCREMENT,
      $description TEXT NOT NULL,
      $photo1 TEXT,
      $photo2 TEXT,
      $photo3 TEXT,
      $stopId INTEGER NOT NULL,
      FOREIGN KEY ($stopId) REFERENCES stops(id)
    )
  ''';
}
