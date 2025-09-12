import 'package:intl/intl.dart';

/// The pattern used to format travel dates.
const String travelDatePattern = 'dd/MM/yyyy';

/// Attempts to parse a date string in dd/MM/yyyy format into a [DateTime]
/// normalized to midnight (00:00) in the local time zone.
/// Returns `null` if the input is empty or invalid.
DateTime? tryParseTravelDate(String rawDate) {
  final sanitizedInput = rawDate.trim();
  if (sanitizedInput.isEmpty) return null;

  try {
    /// Parse the date string
    final parsedDate = DateFormat(
      travelDatePattern,
    ).parseStrict(sanitizedInput);
    // Ensure "date-only" (no time component)
    return DateTime(parsedDate.year, parsedDate.month, parsedDate.day);
  } catch (_) {
    return null;
  }
}

/// Parses a date string in dd/MM/yyyy format into a [DateTime]
DateTime parseTravelDate(String rawDate) {
  final parsedDate = tryParseTravelDate(rawDate);
  if (parsedDate == null) {
    throw FormatException(
      'Invalid date: "$rawDate" (expected format $travelDatePattern)',
    );
  }
  return parsedDate;
}
