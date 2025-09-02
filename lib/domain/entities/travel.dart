
/// A class representing a trip.
class Travel {

  /// The unique identifier of the trip.
  final int? id;

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

  /// The image of the trip.
  final String image;

  /// The Origin Place the Trip
  final String originPlace;

  /// The Origin Label the Trip
  final String originLabel;

  /// The Destination Place the Trip
  final String destinationPlace;

  /// The Destination Label the Trip
  final String destinationLabel;

  /// The status of the trip (e.g., in progress, completed).
  String status = 'in progress';

  /// Constructs a new [Travel] object.
  Travel({
    this.id,
    required this.title,
    required this.startDate,
    required this.endDate,
    required this.meansOfTransportation,
    required this.numberOfParticipants,
    required this.experienceType,
    required this.image,
    required this.originPlace,
    required this.originLabel,
    required this.destinationPlace,
    required this.destinationLabel,
    required String status
  });

  /// Converts the [Travel] object to a map.
  Map<String, dynamic> toMap() {
    final map = {
      'id': id,
      'title': title,
      'startDate': startDate,
      'endDate': endDate,
      'meansOfTransportation': meansOfTransportation,
      'numberOfParticipants': numberOfParticipants,
      'experienceType': experienceType,
      'image': image,
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
      id: map['id'],
      title: map['title'],
      startDate: map['startDate'],
      endDate: map['endDate'],
      meansOfTransportation: map['meansOfTransportation'],
      numberOfParticipants: map['numberOfParticipants'],
      experienceType: map['experienceType'],
      image: map['image'],
      originPlace: map['originPlace'],
      originLabel: map['originLabel'],
      destinationPlace: map['destinationPlace'],
      destinationLabel: map['destinationLabel'],
      status: map['status']
    );
  }
}
