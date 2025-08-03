import 'dart:io';

class Participant {
  final String name;
  final String email;
  final File? photo;

  Participant({required this.name, required this.email, this.photo});

  Participant copyWith({
    String? name,
    String? email,
    File? photo,
  }) {
    return Participant(
      name: name ?? this.name,
      email: email ?? this.email,
      photo: photo ?? this.photo,
    );
  }
}
