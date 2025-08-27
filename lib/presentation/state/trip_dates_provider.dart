import 'package:flutter/widgets.dart';

import 'travelstops_provider.dart';

class TripDatesProvider extends ChangeNotifier {
  DateTime? _startDate = DateTime.now();
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

}
