import 'package:flutter/cupertino.dart';

class PlacePoint {
  final double latitude;
  final double longitude;

  const PlacePoint({required this.latitude, required this.longitude});

  @override
  String toString() => '$latitude,$longitude';
}

class TravelStop {
  final int order;
  final int? travelStopId;
  final PlacePoint place;
  final String label;
  final String startDate;
  final String endDate;
  final String description;

  TravelStop({
    this.travelStopId,
    required this.order,
    required this.place,
    required this.label,
    required this.startDate,
    required this.endDate,
    required this.description,
  });

  /// Creates a copy of this object but with the given values replaced.
  TravelStop copyWith({
    int? order,
    int? travelStopId,
    PlacePoint? place,
    String? label,
    String? startDate,
    String? endDate,
    String? description,
  }) {
    return TravelStop(
      order: order ?? this.order,
      travelStopId: travelStopId ?? this.travelStopId,
      place: place ?? this.place,
      label: label ?? this.label,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      description: description ?? this.description,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TravelStop &&
          runtimeType == other.runtimeType &&
          order == other.order;

  @override
  int get hashCode => order.hashCode;
}
