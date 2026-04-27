import '../../../data/models/booking.dart';
import '../../../data/models/time_slot.dart';

abstract class BookingState {}
class BookingInitial extends BookingState {}
class BookingLoading extends BookingState {}
class MyBookingsLoaded extends BookingState {
  final List<Booking> bookings;
  MyBookingsLoaded(this.bookings);
}
class AvailabilityLoaded extends BookingState {
  final List<TimeSlot> slots;
  AvailabilityLoaded(this.slots);
}
class BookingSuccess extends BookingState {}
class BookingError extends BookingState {
  final String message;
  BookingError(this.message);
}
