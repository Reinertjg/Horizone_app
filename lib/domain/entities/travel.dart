import 'travelstop.dart';

/// A class representing a trip.
class Travel {
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
  /// The Origin Place the Trip
  final PlacePoint? originPlace;
  final String originLabel;
  /// The Destination Place the Trip
  final PlacePoint? destinationPlace;
  final String destinationLabel;

  /// Constructs a new [Travel] object.
  Travel({
    required this.id,
    required this.title,
    required this.startDate,
    required this.endDate,
    required this.meansOfTransportation,
    required this.numberOfParticipants,
    required this.experienceType,
    this.originPlace,
    required this.originLabel,
    this.destinationPlace,
    required this.destinationLabel
  });

  /// Converts the [Travel] object to a map.
  Map<String, dynamic> toMap() => {
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

  /// Creates a [Travel] object from a map.
  static Travel fromMap(Map<String, dynamic> map) {
    return Travel(
      id: map['id'],
      title: map['title'],
      startDate: map['startDate'],
      endDate: map['endDate'],
      meansOfTransportation: map['meansOfTransportation'],
      numberOfParticipants: map['numberOfParticipants'],
      experienceType: map['experienceType'],
      originLabel: map['originLabel'],
      destinationLabel: map['destinationLabel']
    );
  }
}
