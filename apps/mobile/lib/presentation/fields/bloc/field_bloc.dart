import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import '../../../data/repositories/field_repository.dart';
import '../../../core/constants/app_strings.dart';
import 'field_event.dart';
import 'field_state.dart';

class FieldBloc extends Bloc<FieldEvent, FieldState> {
  final FieldRepository _repo;

  FieldBloc(this._repo) : super(FieldInitial()) {
    on<LoadFieldsEvent>(_onLoadFields);
    on<LoadFieldDetailEvent>(_onLoadFieldDetail);
  }

  Future<void> _onLoadFields(LoadFieldsEvent event, Emitter<FieldState> emit) async {
    emit(FieldLoading());
    try {
      final fields = await _repo.getFields(qyteti: event.qyteti, lloji: event.lloji);
      emit(FieldLoaded(fields));
    } on DioException catch (e) {
      emit(FieldError(_mapDioError(e)));
    } catch (e) {
      emit(FieldError(AppStrings.serverError));
    }
  }

  Future<void> _onLoadFieldDetail(LoadFieldDetailEvent event, Emitter<FieldState> emit) async {
    emit(FieldLoading());
    try {
      final field = await _repo.getFieldById(event.id);
      emit(FieldDetailLoaded(field));
    } on DioException catch (e) {
      emit(FieldError(_mapDioError(e)));
    } catch (e) {
      emit(FieldError(AppStrings.serverError));
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