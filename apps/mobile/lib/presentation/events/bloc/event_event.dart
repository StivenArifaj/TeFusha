abstract class EventEvent {}
class LoadEventsEvent extends EventEvent {}
class LoadEventDetailEvent extends EventEvent {
  final int id;
  LoadEventDetailEvent(this.id);
}
class RegisterTeamEvent extends EventEvent {
  final int eventId;
  final String teamName;
  RegisterTeamEvent(this.eventId, this.teamName);
}
