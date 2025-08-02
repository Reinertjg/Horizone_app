/// A class representing a trip.
class Profile {
  /// The unique identifier of the profile.
  final int? id;
  /// The name of the profile.
  final String name;
  /// The biography or description of the profile.
  final String biography;
  /// The date of birth of the profile.
  final String birthDate;
  /// The gender of the profile.
  final String gender;
  /// The job title or role of the profile.
  final String jobTitle;

  /// Constructs a new [Profile] object.
  Profile({
    this.id,
    required this.name,
    required this.biography,
    required this.birthDate,
    required this.gender,
    required this.jobTitle,
  });

  /// Converts the [Profile] object to a map.
  Map<String, dynamic> toMap() {
    final map = {
      'id': id,
      'name': name,
      'biography': biography,
      'birthDate': birthDate,
      'gender': gender,
      'job_title': jobTitle,
    };
    return map;
  }

  /// Constructs a new [Profile] object from a map.
  factory Profile.fromMap(Map<String, dynamic> map) => Profile(
    id: map['id'] ?? '',
    name: map['name'] ?? '',
    biography: map['biography'] ?? '',
    birthDate: map['birthDate'] ?? '',
    gender: map['gender'] ?? '',
    jobTitle: map['job_title'] ?? '',
  );
}
