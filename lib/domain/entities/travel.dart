import 'travelstop.dart';

/// A class representing a trip.
class Travel {

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
  /// The Origin Place the Trip
  final String originPlace;
  final String originLabel;
  /// The Destination Place the Trip
  final String destinationPlace;
  final String destinationLabel;

  /// Constructs a new [Travel] object.
  Travel({
    required this.title,
    required this.startDate,
    required this.endDate,
    required this.meansOfTransportation,
    required this.numberOfParticipants,
    required this.experienceType,
    required this.originPlace,
    required this.originLabel,
    required this.destinationPlace,
    required this.destinationLabel
  });

  /// Converts the [Travel] object to a map.
  Map<String, dynamic> toMap() {
    final map = {
      'title': title,
      'startDate': startDate,
      'endDate': endDate,
      'meansOfTransportation': meansOfTransportation,
      'numberOfParticipants': numberOfParticipants,
      'experienceType': experienceType,
      'originLabel': originLabel,
      'destinationLabel': destinationLabel,
      'originPlace': originPlace,
      'destinationPlace': destinationPlace
    };
    return map;
  }

  /// Creates a [Travel] object from a map.
  static Travel fromMap(Map<String, dynamic> map) {
    return Travel(
      title: map['title'],
      startDate: map['startDate'],
      endDate: map['endDate'],
      meansOfTransportation: map['meansOfTransportation'],
      numberOfParticipants: map['numberOfParticipants'],
      experienceType: map['experienceType'],
      originPlace: map['originPlace'],
      originLabel: map['originLabel'],
      destinationPlace: map['destinationPlace'],
      destinationLabel: map['destinationLabel']
    );
  }
}
