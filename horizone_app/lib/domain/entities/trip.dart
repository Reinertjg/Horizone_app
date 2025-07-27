class Trip {
  final int id;
  final String title;
  final String startDate;
  final String endDate;
  final String meansOfTransportation;
  final int numberOfParticipants;
  final String experienceType;

  Trip({
    required this.id,
    required this.title,
    required this.startDate,
    required this.endDate,
    required this.meansOfTransportation,
    required this.numberOfParticipants,
    required this.experienceType,
  });

  Map<String, dynamic> toMap() => {
    'title': title,
    'startDate': startDate,
    'endDate': endDate,
    'meansOfTransportation': meansOfTransportation,
    'numberOfParticipants': numberOfParticipants,
    'experienceType': experienceType,
  };

  /// Creates a [Trip] object from a map.
  static Trip fromMap(Map<String, dynamic> map) {
    return Trip(
      id: map['id'],
      title: map['title'],
      startDate: map['startDate'],
      endDate: map['endDate'],
      meansOfTransportation: map['meansOfTransportation'],
      numberOfParticipants: map['numberOfParticipants'],
      experienceType: map['experienceType'],
    );
  }
}
