// core/utils/travel_status.dart
import 'package:flutter/material.dart';

/// Widget that displays the travel info.
enum TravelStatus {
  /// The travel is in progress.
  inProgress,

  /// The travel has been completed.
  completed,

  /// The travel has been canceled.
  canceled,

  /// The travel has been scheduled.
  scheduled,
}

/// Returns the status of the travel based on the current date.
TravelStatus getTravelStatus({
  required DateTime startDate,
  required DateTime endDate,
  DateTime? now,
}) {
  final today = DateUtils.dateOnly(now ?? DateTime.now());
  final startDateFormat = DateUtils.dateOnly(startDate);
  final endDateFormat = DateUtils.dateOnly(endDate);

  if (today.isBefore(startDateFormat)) return TravelStatus.scheduled;
  if (today.isAfter(endDateFormat)) return TravelStatus.completed;
  return TravelStatus.inProgress;
}
