import '../../../data/models/field.dart';

abstract class FieldState {}
class FieldInitial extends FieldState {}
class FieldLoading extends FieldState {}
class FieldLoaded extends FieldState {
  final List<Field> fields;
  FieldLoaded(this.fields);
}
class FieldDetailLoaded extends FieldState {
  final Field field;
  FieldDetailLoaded(this.field);
}
class FieldError extends FieldState {
  final String message;
  FieldError(this.message);
}
