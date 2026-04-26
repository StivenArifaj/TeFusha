import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import '../../../data/repositories/booking_repository.dart';
import '../../../data/repositories/field_repository.dart';
import '../../../core/constants/app_strings.dart';
import 'booking_event.dart';
import 'booking_state.dart';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  final BookingRepository _bookingRepo;
  final FieldRepository _fieldRepo;

  BookingBloc(this._bookingRepo, this._fieldRepo) : super(BookingInitial()) {
    on<LoadMyBookingsEvent>(_onLoadMyBookings);
    on<CreateBookingEvent>(_onCreateBooking);
    on<LoadAvailabilityEvent>(_onLoadAvailability);
  }

  Future<void> _onLoadMyBookings(LoadMyBookingsEvent event, Emitter<BookingState> emit) async {
    emit(BookingLoading());
    try {
      final bookings = await _bookingRepo.getMyBookings();
      emit(MyBookingsLoaded(bookings));
    } on DioException catch (e) {
      emit(BookingError(_mapDioError(e)));
    } catch (e) {
      emit(BookingError(AppStrings.serverError));
    }
  }

  Future<void> _onCreateBooking(CreateBookingEvent event, Emitter<BookingState> emit) async {
    emit(BookingLoading());
    try {
      await _bookingRepo.createBooking(
        fushaId: event.fushaId,
        dataRezervimit: event.date,
        oraFillimit: event.startTime,
        oraMbarimit: event.endTime,
      );
      emit(BookingSuccess());
    } on DioException catch (e) {
      emit(BookingError(_mapDioError(e)));
    } catch (e) {
      emit(BookingError(AppStrings.serverError));
    }
  }

  Future<void> _onLoadAvailability(LoadAvailabilityEvent event, Emitter<BookingState> emit) async {
    emit(BookingLoading());
    try {
      final slots = await _fieldRepo.getAvailability(event.fushaId, event.date);
      emit(AvailabilityLoaded(slots));
    } on DioException catch (e) {
      emit(BookingError(_mapDioError(e)));
    } catch (e) {
      emit(BookingError(AppStrings.serverError));
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