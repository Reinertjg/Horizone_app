import 'dart:io';

/// A class representing a participant in a trip.
class Participant {

  /// The ID of the participant.
  final int? id;

  /// The name of the participant.
  final String name;

  /// The email address of the participant.
  final String email;

  /// The photo of the participant.
  final File? photo;

  /// The ID of the travel associated with the participant.
  final int? travelId;

  /// Constructs a new [Participant] object.
  Participant({
    this.id,
    required this.name,
    required this.email,
    this.photo,
    this.travelId,
  });

  /// Converts the [Participant] object to a map.
  Map<String, dynamic> toMap() {
    final map = {
      'id': id,
      'name': name,
      'email': email,
      'photo': photo?.path,
      'travelId': travelId,
    };
    return map;
  }

  /// Creates a [Participant] object from a map.
  static Participant fromMap(Map<String, dynamic> map) {
    return Participant(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      photo: File(map['photo']),
      travelId: map['travelId'],
    );
  }

  Participant copyWith({int? id, String? name, String? email, File? photo, int? travelId}) {
    return Participant(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      photo: photo ?? this.photo,
      travelId: travelId ?? this.travelId,
    );
  }
}
