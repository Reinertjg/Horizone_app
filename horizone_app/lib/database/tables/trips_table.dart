/// Contains constants and SQL statement related to the `trips` table schema.
abstract class TripTable {

  /// Private constructor to prevent instantiation.
  static const tableName = 'trips';

  /// Primary key (auto-incremented integer)
  static const String tripId = 'id';

  /// Title or name of the trip (text, required)
  static const String tripTitle = 'title';

  /// Start date of the trip in string format (text, required)
  static const String startDate = 'startDate';

  /// End date of the trip in string format (text, required)
  static const String endDate = 'endDate';

  /// Transportation method (e.g. car, plane) (text, required)
  static const String meansOfTransportation = 'meansOfTransportation';

  /// Number of participants (integer, required)
  static const String numberOfParticipants = 'numberOfParticipants';

  /// Type of experience (e.g. cultural, adventure) (text, required)
  static const String experienceType = 'experienceType';

  /// SQL statement to create the `trips` table with the defined schema.
  static const createTable = '''
    CREATE TABLE $tableName (
      $tripId INTEGER PRIMARY KEY AUTOINCREMENT,
      $tripTitle TEXT NOT NULL,
      $startDate TEXT NOT NULL,
      $endDate TEXT NOT NULL,
      $meansOfTransportation TEXT NOT NULL,
      $numberOfParticipants INTEGER NOT NULL,
      $experienceType TEXT NOT NULL
    )
  ''';
}
