import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import '../../../data/repositories/announcement_repository.dart';
import '../../../data/models/announcement.dart';

// Events
abstract class AnnouncementEvent {}
class LoadAnnouncementsEvent extends AnnouncementEvent {
  final String? sport;
  final String? type;
  LoadAnnouncementsEvent({this.sport, this.type});
}
class CreateAnnouncementEvent extends AnnouncementEvent {
  final Map<String, dynamic> data;
  CreateAnnouncementEvent(this.data);
}
class RespondToAnnouncementEvent extends AnnouncementEvent {
  final int id;
  final String? message;
  RespondToAnnouncementEvent(this.id, this.message);
}

// State
abstract class AnnouncementState {}
class AnnouncementInitial extends AnnouncementState {}
class AnnouncementLoading extends AnnouncementState {}
class AnnouncementsLoaded extends AnnouncementState {
  final List<Announcement> announcements;
  AnnouncementsLoaded(this.announcements);
}
class AnnouncementSuccess extends AnnouncementState {}
class AnnouncementError extends AnnouncementState {
  final String message;
  AnnouncementError(this.message);
}

// Bloc
class AnnouncementBloc extends Bloc<AnnouncementEvent, AnnouncementState> {
  final AnnouncementRepository _repo;

  AnnouncementBloc(this._repo) : super(AnnouncementInitial()) {
    on<LoadAnnouncementsEvent>(_onLoad);
    on<CreateAnnouncementEvent>(_onCreate);
    on<RespondToAnnouncementEvent>(_onRespond);
  }

  Future<void> _onLoad(LoadAnnouncementsEvent event, Emitter<AnnouncementState> emit) async {
    emit(AnnouncementLoading());
    try {
      final data = await _repo.getAnnouncements(sport: event.sport, type: event.type);
      emit(AnnouncementsLoaded(data));
    } catch (e) {
      emit(AnnouncementError("Gabim gjatë marrjes së njoftimeve"));
    }
  }

  Future<void> _onCreate(CreateAnnouncementEvent event, Emitter<AnnouncementState> emit) async {
    emit(AnnouncementLoading());
    try {
      await _repo.createAnnouncement(event.data);
      emit(AnnouncementSuccess());
    } catch (e) {
      emit(AnnouncementError("Gabim gjatë krijimit të njoftimit"));
    }
  }

  Future<void> _onRespond(RespondToAnnouncementEvent event, Emitter<AnnouncementState> emit) async {
    try {
      await _repo.respond(event.id, event.message);
      // Optionally reload or emit success
    } catch (e) {
      emit(AnnouncementError("Gabim gjatë dërgimit të përgjigjes"));
    }
  }
}
