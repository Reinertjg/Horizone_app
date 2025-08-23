class PlacePoint {
  final double latitude;
  final double longitude;

  const PlacePoint({required this.latitude, required this.longitude});

  @override
  String toString() => '$latitude,$longitude';
}

class TravelStop {
  final int? travelStopId;
  final PlacePoint place;
  final String label;
  final DateTime? startDate;
  final DateTime? endDate;
  final String description;

  TravelStop({
    this.travelStopId,
    required this.place,
    required this.label,
    required this.startDate,
    required this.endDate,
    required this.description,
  });

  /// Creates a copy of this object but with the given values replaced.
  TravelStop copyWith({
    int? travelStopId,
    PlacePoint? place,
    String? label,
    DateTime? startDate,
    DateTime? endDate,
    String? description,
  }) {
    return TravelStop(
      travelStopId: travelStopId ?? this.travelStopId,
      place: place ?? this.place,
      label: label ?? this.label,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      description: description ?? this.description,
    );
  }
}
