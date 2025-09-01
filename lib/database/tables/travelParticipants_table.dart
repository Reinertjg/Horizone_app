/// Contains constants and SQL statement related to the `trips` table schema.
abstract class TravelTable {

  /// Private constructor to prevent instantiation.
  static const tableName = 'travelParticipants';

  /// Primary key (auto-incremented integer)
  static const String participantId = 'id';

  /// Title or name of the trip (text, required)
  static const String participantName = 'name';

  /// Start date of the trip in string format (text, required)
  static const String email = 'email';

  /// End date of the trip in string format (text, required)
  static const String pathPhoto = 'pathPhoto';

  /// SQL statement to create the `Travels` table with the defined schema.
  static const createTable = '''
    CREATE TABLE $tableName (
      $participantId INTEGER PRIMARY KEY AUTOINCREMENT,
      $participantName TEXT NOT NULL,
      $email TEXT NOT NULL,
      $pathPhoto TEXT NOT NULL
    )
  ''';
}
