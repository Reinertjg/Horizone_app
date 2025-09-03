/// Contains constants and SQL statement related to the `trips` table schema.
abstract class ParticipantTable {

  /// Private constructor to prevent instantiation.
  static const tableName = 'participants';

  /// Primary key (auto-incremented integer)
  static const String participantId = 'id';

  /// Title or name of the participant (text, required)
  static const String participantName = 'name';

  /// Email of the participant (text, required)
  static const String email = 'email';

  /// Path to the photo of the participant (text, required)
  static const String pathPhoto = 'photo';

  /// Foreign key referencing the `travels` table (integer, required)
  static const String travelId = 'travelId';

  /// SQL statement to create the `Travels` table with the defined schema.
  static const createTable = '''
    CREATE TABLE $tableName (
      $participantId INTEGER PRIMARY KEY AUTOINCREMENT,
      $participantName TEXT NOT NULL,
      $email TEXT NOT NULL,
      $pathPhoto TEXT,
      $travelId INTEGER NOT NULL,
      FOREIGN KEY ($travelId) REFERENCES travels(id)
    )
  ''';
}
