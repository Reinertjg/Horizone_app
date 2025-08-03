/// A class representing a trip.
class Trip {
  /// The unique identifier of the trip.
  final int id;
  /// The title or name of the trip.
  final String title;
  /// The start date of the trip.
  final String startDate;
  /// The end date of the trip.
  final String endDate;
  /// The transportation method used for the trip.
  final String meansOfTransportation;
  /// The number of participants in the trip.
  final int numberOfParticipants;
  /// The type of experience the trip offers.
  final String experienceType;

  /// Constructs a new [Trip] object.
  Trip({
    required this.id,
    required this.title,
    required this.startDate,
    required this.endDate,
    required this.meansOfTransportation,
    required this.numberOfParticipants,
    required this.experienceType,
  });

  /// Converts the [Trip] object to a map.
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
