/// Contains constants and SQL statement related to the `profiles` table schema.
abstract class ProfileTable {
  ProfileTable._();

  /// Private constructor to prevent instantiation.
  static const tableName = 'profiles';

  /// Primary key (auto-incremented integer)
  static const String profileId = 'id';

  /// User's full name (text, required)
  static const String profileName = 'name';

  /// Short biography or description (text, required, must be unique)
  static const String biography = 'biography';

  /// Date of birth in string format (text, required)
  static const String birthDate = 'birthDate';

  /// Gender identity (text, required)
  static const String gender = 'gender';

  /// Professional job title or role (text, required)
  static const String jobTitle = 'job_title';

  /// Path to the photo of the user (text, required)
  static const String pathPhoto = 'photo';


  /// SQL statement to create the `profiles` table with the defined schema.
  static const createTable = '''
    CREATE TABLE $tableName (
      $profileId INTEGER PRIMARY KEY AUTOINCREMENT,
      $profileName TEXT NOT NULL,
      $biography TEXT UNIQUE NOT NULL,
      $birthDate TEXT NOT NULL,
      $gender TEXT NOT NULL,
      $jobTitle TEXT NOT NULL,
      $pathPhoto TEXT
    )
  ''';

}
