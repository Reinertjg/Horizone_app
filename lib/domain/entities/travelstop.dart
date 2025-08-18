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
  final String startDate;
  final String endDate;
  final String description;

  TravelStop({
    this.travelStopId,
    required this.place,
    required this.label,
    required this.startDate,
    required this.endDate,
    required this.description,
  });
}
