import 'package:intl/intl.dart';

/// A class representing a point on the map.
class PlacePoint {
  /// The latitude of the place.
  final double latitude;

  /// The longitude of the place.
  final double longitude;

  /// Creates a new [PlacePoint] object.
  const PlacePoint({required this.latitude, required this.longitude});

  @override
  String toString() => '$latitude,$longitude';

  /// Creates a new [PlacePoint] object from a string 'latitude,longitude'.
  static PlacePoint fromString(String pointString) {
    final parts = pointString.split(',');
    final latitude = double.parse(parts[0]);
    final longitude = double.parse(parts[1]);
    return PlacePoint(latitude: latitude, longitude: longitude);
  }
}

/// Represents a stop in a travel.
class Stop {
  /// The ID of the stop in the travel.
  final int? id;

  /// The order of the stop in the travel.
  final int order;

  /// The place of the stop.
  final PlacePoint place;

  /// The label of the stop.
  final String label;

  /// The start date of the stop.
  final DateTime? startDate;

  /// The end date of the stop.
  final DateTime? endDate;

  /// The description of the stop.
  final String description;

  /// The ID of the travel associated with the stop.
  final int? travelId;

  /// Creates a new [Stop] object.
  Stop({
    this.id,
    required this.order,
    required this.place,
    required this.label,
    required this.startDate,
    required this.endDate,
    required this.description,
    this.travelId,
  });

  /// Converts the [Stop] object to a map.
  Map<String, dynamic> toMap() {
    final map = {
      'id': id,
      'sort_order': order,
      'place': place.toString(),
      'label': label,
      'startDate': formatDate(startDate),
      'endDate': formatDate(endDate),
      'description': description,
      'travelId': travelId,
    };
    return map;
  }

  /// Creates a new [Stop] object from a map.
  static Stop fromMap(Map<String, dynamic> map) {
    return Stop(
      id: map['id'],
      order: map['sort_order'] ?? 0,
      place: PlacePoint.fromString(map['place']),
      label: map['label'],
      startDate:
          map['startDate'] != null && map['startDate'].isNotEmpty ? DateFormat('dd/MM/yyyy').parse(map['startDate']) : null,
      endDate:
          map['endDate'] != null && map['endDate'].isNotEmpty ? DateFormat('dd/MM/yyyy').parse(map['endDate']) : null,
      description: map['description'],
      travelId: map['travelId'],
    );
  }

  /// Creates a copy of the [Stop] object with the specified values.
  Stop copyWith({
    int? id,
    int? order,
    PlacePoint? place,
    String? label,
    DateTime? startDate,
    DateTime? endDate,
    String? description,
    int? travelId,
  }) {
    return Stop(
      id: id ?? this.id,
      order: order ?? this.order,
      place: place ?? this.place,
      label: label ?? this.label,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      description: description ?? this.description,
      travelId: travelId ?? this.travelId,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Stop && runtimeType == other.runtimeType && order == other.order;

  @override
  int get hashCode => order.hashCode;

  String formatDate(DateTime? date) {
    if (date == null) return '';
    return DateFormat('dd/MM/yyyy').format(date);
  }
}
