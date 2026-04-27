import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import '../../../data/repositories/event_repository.dart';
import '../../../core/constants/app_strings.dart';
import 'event_event.dart';
import 'event_state.dart';

class EventBloc extends Bloc<EventEvent, EventState> {
  final EventRepository _repo;

  EventBloc(this._repo) : super(EventInitial()) {
    on<LoadEventsEvent>(_onLoadEvents);
    on<LoadEventDetailEvent>(_onLoadEventDetail);
    on<RegisterTeamEvent>(_onRegisterTeam);
  }

  Future<void> _onLoadEvents(LoadEventsEvent event, Emitter<EventState> emit) async {
    emit(EventLoading());
    try {
      final events = await _repo.getEvents();
      emit(EventsLoaded(events));
    } on DioException catch (e) {
      emit(EventError(_mapDioError(e)));
    } catch (e) {
      emit(EventError(AppStrings.serverError));
    }
  }

  Future<void> _onLoadEventDetail(LoadEventDetailEvent event, Emitter<EventState> emit) async {
    emit(EventLoading());
    try {
      final evt = await _repo.getEventById(event.id);
      emit(EventDetailLoaded(evt));
    } on DioException catch (e) {
      emit(EventError(_mapDioError(e)));
    } catch (e) {
      emit(EventError(AppStrings.serverError));
    }
  }

  Future<void> _onRegisterTeam(RegisterTeamEvent event, Emitter<EventState> emit) async {
    emit(EventLoading());
    try {
      await _repo.registerTeam(event.eventId, event.teamName);
      emit(EventActionSuccess('Ekipi u regjistrua me sukses!'));
      // Reload event details after registering
      add(LoadEventDetailEvent(event.eventId));
    } on DioException catch (e) {
      emit(EventError(_mapDioError(e)));
      add(LoadEventDetailEvent(event.eventId)); // fallback load
    } catch (e) {
      emit(EventError(AppStrings.serverError));
      add(LoadEventDetailEvent(event.eventId)); // fallback load
    }
  }

  String _mapDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
        return AppStrings.networkError;
      case DioExceptionType.badResponse:
        return e.response?.data?['error'] ?? AppStrings.serverError;
      default:
        return AppStrings.networkError;
    }
  }
}
