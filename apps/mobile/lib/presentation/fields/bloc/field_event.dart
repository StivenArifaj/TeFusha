abstract class FieldEvent {}
class LoadFieldsEvent extends FieldEvent {
  final String? qyteti;
  final String? lloji;
  LoadFieldsEvent({this.qyteti, this.lloji});
}
class LoadFieldDetailEvent extends FieldEvent {
  final int id;
  LoadFieldDetailEvent(this.id);
}
