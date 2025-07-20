class Profile {
  final String name;
  final String biography;
  final String birthDate;
  final String gender;
  final String jobTitle;

  Profile({
    required this.name,
    required this.biography,
    required this.birthDate,
    required this.gender,
    required this.jobTitle,
  });

  Map<String, dynamic> toMap() => {
    'name': name,
    'biography': biography,
    'birthDate': birthDate,
    'gender': gender,
    'jobTitle': jobTitle,
  };

  factory Profile.fromMap(Map<String, dynamic> map) => Profile(
    name: map['name'],
    biography: map['biography'],
    birthDate: map['birthDate'],
    gender: map['gender'],
    jobTitle: map['jobTitle'],
  );
}
