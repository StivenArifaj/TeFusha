abstract class BookingEvent {}
class LoadMyBookingsEvent extends BookingEvent {}
class CreateBookingEvent extends BookingEvent {
  final int fushaId;
  final String date;
  final String startTime;
  final String endTime;
  CreateBookingEvent(this.fushaId, this.date, this.startTime, this.endTime);
}
class LoadAvailabilityEvent extends BookingEvent {
  final int fushaId;
  final String date;
  LoadAvailabilityEvent(this.fushaId, this.date);
}