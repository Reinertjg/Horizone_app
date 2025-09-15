/// Contains constants and SQL statement related to the `stops` table schema.
abstract class StopTable {
  /// Private constructor to prevent instantiation.
  static const tableName = 'stops';

  /// Primary key (auto-incremented integer)
  static const String stopId = 'id';

  /// Order of the stop (integer, required)
  static const String stopOrder = 'sort_order';

  /// Place of the stop (text, required)
  static const String stopLabel = 'label';

  /// Place of the stop (text, required)
  static const String stopPlace = 'place';

  /// Start date of the stop in string format (text, required)
  static const String stopStartDate = 'startDate';

  /// End date of the stop in string format (text, required)
  static const String stopEndDate = 'endDate';

  /// Description of the stop (text)
  static const String stopDescription = 'description';

  /// Travel ID of the stop (integer, required)
  static const String travelId = 'travelId';

  /// SQL statement to create the `Stops` table with the defined schema.
  static const createTable =
      '''
    CREATE TABLE $tableName (
      $stopId INTEGER PRIMARY KEY AUTOINCREMENT,
      $stopOrder INTEGER NOT NULL,
      $stopLabel TEXT NOT NULL,
      $stopPlace TEXT NOT NULL,
      $stopStartDate TEXT NOT NULL,
      $stopEndDate TEXT NOT NULL,
      $stopDescription TEXT,
      $travelId INTEGER NOT NULL,
      FOREIGN KEY ($travelId) REFERENCES travels(id)
    )
  ''';
}
