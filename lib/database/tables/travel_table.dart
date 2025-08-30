/// Contains constants and SQL statement related to the `trips` table schema.
abstract class TravelTable {

  /// Private constructor to prevent instantiation.
  static const tableName = 'travels';

  /// Primary key (auto-incremented integer)
  static const String travelId = 'id';

  /// Title or name of the trip (text, required)
  static const String travelTitle = 'title';

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

  /// Origin Place of the Travel
  static const String originPlace = 'originPlace';

  /// Destination Place of the Travel
  static const String destinationPlace = 'destinationPlace';


  /// SQL statement to create the `Travels` table with the defined schema.
  static const createTable = '''
    CREATE TABLE $tableName (
      $travelId INTEGER PRIMARY KEY AUTOINCREMENT,
      $travelTitle TEXT NOT NULL,
      $startDate TEXT NOT NULL,
      $endDate TEXT NOT NULL,
      $meansOfTransportation TEXT NOT NULL,
      $numberOfParticipants INTEGER NOT NULL,
      $experienceType TEXT NOT NULL
      $originPlace TEXT NOT NULL,
      $destinationPlace TEXT NOT NULL
    )
  ''';
}
