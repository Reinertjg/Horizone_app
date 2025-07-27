
import 'package:horizone_app/domain/entities/trip.dart';
import 'package:horizone_app/domain/repositories/trip_repository.dart';

class InterviewUseCase {
  final TripRepository repository;

  InterviewUseCase(this.repository);

  Future<void> insert(Trip trip) => repository.insertTrip(trip);

  Future<List<Trip>> getAll() => repository.getAllTrips();
}