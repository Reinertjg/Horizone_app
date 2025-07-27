class Profile {
  final int? id;
  final String name;
  final String biography;
  final String birthDate;
  final String gender;
  final String jobTitle;

  Profile({
    this.id,
    required this.name,
    required this.biography,
    required this.birthDate,
    required this.gender,
    required this.jobTitle,
  });

  Map<String, dynamic> toMap() {
    final map = {
      'id': id,
      'name': name,
      'biography': biography,
      'birthDate': birthDate,
      'gender': gender,
      'jobTitle': jobTitle,
    };
    return map;
  }

  factory Profile.fromMap(Map<String, dynamic> map) => Profile(
    id: map['id'],
    name: map['name'],
    biography: map['biography'],
    birthDate: map['birthDate'],
    gender: map['gender'],
    jobTitle: map['jobTitle'],
  );
}
