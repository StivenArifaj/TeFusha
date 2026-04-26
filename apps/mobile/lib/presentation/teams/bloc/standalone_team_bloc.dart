import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/standalone_team_repository.dart';
import '../../../data/models/standalone_team.dart';

// Events
abstract class StandaloneTeamEvent {}
class LoadMyTeamsEvent extends StandaloneTeamEvent {}
class CreateStandaloneTeamEvent extends StandaloneTeamEvent {
  final Map<String, dynamic> data;
  CreateStandaloneTeamEvent(this.data);
}
class JoinStandaloneTeamEvent extends StandaloneTeamEvent {
  final int id;
  JoinStandaloneTeamEvent(this.id);
}

// State
abstract class StandaloneTeamState {}
class StandaloneTeamInitial extends StandaloneTeamState {}
class StandaloneTeamLoading extends StandaloneTeamState {}
class StandaloneTeamsLoaded extends StandaloneTeamState {
  final List<StandaloneTeam> teams;
  StandaloneTeamsLoaded(this.teams);
}
class StandaloneTeamSuccess extends StandaloneTeamState {}
class StandaloneTeamError extends StandaloneTeamState {
  final String message;
  StandaloneTeamError(this.message);
}

// Bloc
class StandaloneTeamBloc extends Bloc<StandaloneTeamEvent, StandaloneTeamState> {
  final StandaloneTeamRepository _repo;

  StandaloneTeamBloc(this._repo) : super(StandaloneTeamInitial()) {
    on<LoadMyTeamsEvent>(_onLoad);
    on<CreateStandaloneTeamEvent>(_onCreate);
    on<JoinStandaloneTeamEvent>(_onJoin);
  }

  Future<void> _onLoad(LoadMyTeamsEvent event, Emitter<StandaloneTeamState> emit) async {
    emit(StandaloneTeamLoading());
    try {
      final data = await _repo.getMyTeams();
      emit(StandaloneTeamsLoaded(data));
    } catch (e) {
      emit(StandaloneTeamError("Gabim gjatë marrjes së ekipeve"));
    }
  }

  Future<void> _onCreate(CreateStandaloneTeamEvent event, Emitter<StandaloneTeamState> emit) async {
    emit(StandaloneTeamLoading());
    try {
      await _repo.createTeam(event.data);
      emit(StandaloneTeamSuccess());
    } catch (e) {
      emit(StandaloneTeamError("Gabim gjatë krijimit të ekipit"));
    }
  }

  Future<void> _onJoin(JoinStandaloneTeamEvent event, Emitter<StandaloneTeamState> emit) async {
    try {
      await _repo.joinTeam(event.id);
      add(LoadMyTeamsEvent());
    } catch (e) {
      emit(StandaloneTeamError("Gabim gjatë bashkimit me ekipin"));
    }
  }
}
