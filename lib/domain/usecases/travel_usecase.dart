import 'package:intl/intl.dart';

import '../entities/travel.dart';
import '../repositories/travel_repository.dart';

/// Use case class responsible for managing [Travel] operations
class TravelUseCase {
  /// The repository used to access travel data.
  final TravelRepository repository;

  /// Creates a new instance of [TravelUseCase]
  TravelUseCase(this.repository);

  /// Inserts a new [Travel] into the repository.
  Future<int> insert(Travel trip) => repository.insertTravel(trip);

  /// Retrieves all [Travel] records from the repository.
  Future<List<Travel>> getAll() => repository.getAllTravels();

  /// Retrieves a [Travel] record with the given [status] from the repository.
  Future<List<Travel>> getTravelByStatus(String status) =>
      repository.getTravelByStatus(status);

  /// Validates if a new trip overlaps with existing trips
  Future<bool> validateOverlap(DateTime start, DateTime end) async {
    final travels = await repository.getAllTravels();

    for (final travel in travels) {
      final dateFormat = DateFormat('dd/MM/yyyy');

      final travelStartDate = dateFormat.parse(travel.startDate);
      final travelEndDate = dateFormat.parse(travel.endDate);

      final overlap = start.isBefore(travelEndDate) &&
          travelStartDate.isBefore(end);

      if (overlap) return true;
    }
    return false;
  }
}
