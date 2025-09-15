import 'dart:io';

import 'stop.dart';

/// A class representing a trip.
class Travel {
  /// The unique identifier of the trip.
  final int? id;

  /// The image of the trip.
  final File? image;

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

  /// The number of stops in the trip.
  final int numberOfStops;

  /// The Origin Place the Trip
  final PlacePoint originPlace;

  /// The Origin Label the Trip
  final String originLabel;

  /// The Destination Place the Trip
  final PlacePoint destinationPlace;

  /// The Destination Label the Trip
  final String destinationLabel;

  /// The rating of the trip.
  final double? rating;

  /// The status of the trip (e.g., 'active', 'inactive').
  String status = 'active';

  /// Constructs a new [Travel] object.
  Travel({
    this.id,
    required this.image,
    required this.title,
    required this.startDate,
    required this.endDate,
    required this.meansOfTransportation,
    required this.numberOfParticipants,
    required this.experienceType,
    required this.numberOfStops,
    required this.originPlace,
    required this.originLabel,
    required this.destinationPlace,
    required this.destinationLabel,
    this.rating,
    required String status,
  });

  /// Converts the [Travel] object to a map.
  Map<String, dynamic> toMap() {
    final map = {
      'id': id,
      'image': image?.path,
      'title': title,
      'startDate': startDate,
      'endDate': endDate,
      'meansOfTransportation': meansOfTransportation,
      'numberOfParticipants': numberOfParticipants,
      'experienceType': experienceType,
      'numberOfStops': numberOfStops,
      'originLabel': originLabel,
      'destinationLabel': destinationLabel,
      'originPlace': originPlace.toString(),
      'destinationPlace': destinationPlace.toString(),
      'rating': rating,
      'status': status,
    };
    return map;
  }

  /// Creates a [Travel] object from a map.
  static Travel fromMap(Map<String, dynamic> map) {
    return Travel(
      id: map['id'],
      image: map['image'] != null ? File(map['image']) : null,
      title: map['title'],
      startDate: map['startDate'],
      endDate: map['endDate'],
      meansOfTransportation: map['meansOfTransportation'],
      numberOfParticipants: map['numberOfParticipants'],
      experienceType: map['experienceType'],
      numberOfStops: map['numberOfStops'],
      originLabel: map['originLabel'],
      destinationLabel: map['destinationLabel'],
      originPlace: PlacePoint.fromString(map['originPlace']),
      destinationPlace: PlacePoint.fromString(map['destinationPlace']),
      rating: map['rating'],
      status: map['status'],
    );
  }
}
