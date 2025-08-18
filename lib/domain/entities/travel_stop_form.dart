class TravelStopForm {
  /// Google Places placeId selected from autocomplete
  String? placeId;

  String label;

  String notes;

  String? startDateText;
  String? endDateText;

  TravelStopForm({
     this.placeId,
     this.label = '',
     this.notes = '',
     this.startDateText,
     this.endDateText,
  });
}
