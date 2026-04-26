import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../core/constants/app_strings.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _repo;

  AuthBloc(this._repo) : super(AuthInitial()) {
    on<LoginSubmitted>(_onLogin);
    on<RegisterSubmitted>(_onRegister);
    on<LogoutRequested>(_onLogout);
  }

  Future<void> _onLogin(LoginSubmitted event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await _repo.login(event.email, event.password);
      emit(AuthAuthenticated(user));
    } on DioException catch (e) {
      emit(AuthError(_mapDioError(e)));
    } catch (e) {
      emit(AuthError(AppStrings.serverError));
    }
  }

  Future<void> _onRegister(RegisterSubmitted event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await _repo.register(event.fullName, event.email, event.password, event.role);
      emit(AuthAuthenticated(user));
    } on DioException catch (e) {
      emit(AuthError(_mapDioError(e)));
    } catch (e) {
      emit(AuthError(AppStrings.serverError));
    }
  }

  Future<void> _onLogout(LogoutRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    await _repo.logout();
    emit(AuthUnauthenticated());
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
