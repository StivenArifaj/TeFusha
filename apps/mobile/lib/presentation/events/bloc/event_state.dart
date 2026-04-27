import '../../../data/models/event.dart';

abstract class EventState {}
class EventInitial extends EventState {}
class EventLoading extends EventState {}
class EventsLoaded extends EventState {
  final List<Event> events;
  EventsLoaded(this.events);
}
class EventDetailLoaded extends EventState {
  final Event event;
  EventDetailLoaded(this.event);
}
class EventActionSuccess extends EventState {
  final String message;
  EventActionSuccess(this.message);
}
class EventError extends EventState {
  final String message;
  EventError(this.message);
}
