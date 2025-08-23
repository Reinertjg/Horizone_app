import 'package:flutter/widgets.dart';

import 'travelstops_provider.dart';

class TripDatesProvider extends ChangeNotifier {
  final TravelStopsProvider stops = TravelStopsProvider();
  DateTime? _startDate;
  DateTime? _endDate;
  List<DateTime> _dates = [];

  DateTime? get startDate => _startDate;

  DateTime? get endDate => _endDate;

  List<DateTime> get dates => _dates;

  void setTripStart(DateTime date) {
    _startDate = date;
    notifyListeners();
  }

  void setTripEnd(DateTime date) {
    _endDate = date;
    notifyListeners();
  }

  void addDate(DateTime date) {
    _dates.add(date);
    notifyListeners();
  }

  DateTime minDateForStop(int index) {
    if (index == 0) {
      return startDate ?? DateTime.now();
    } else {
      return dates[index - 1];
    }
  }

  DateTime maxDateForStop(int index) {
    if (index == stops.length - 1) {
      return endDate ?? DateTime.now();
    } else {
      return dates[index + 1] ;
    }
  }

  DateTime initialDateForStop(int index, {DateTime? current}) {
    if (index == 0) {
      return current ?? startDate ?? DateTime.now();
    } else {
      return dates[index - 1];
    }
  }
}
