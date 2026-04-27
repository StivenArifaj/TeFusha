import 'package:dio/dio.dart';
import '../../core/constants/api_constants.dart';
import '../datasources/remote/api_client.dart';
import '../models/booking.dart';

class BookingRepository {
  final Dio _dio = ApiClient.instance;

  Future<List<Booking>> getMyBookings() async {
    final response = await _dio.get(ApiConstants.myBookings);
    return (response.data as List).map((x) => Booking.fromJson(x)).toList();
  }

  Future<Booking> createBooking({
    required int fushaId,
    required String dataRezervimit,
    required String oraFillimit,
    required String oraMbarimit,
  }) async {
    final response = await _dio.post(
      ApiConstants.bookings,
      data: {
        'fusha_id': fushaId,
        'data_rezervimit': dataRezervimit,
        'ora_fillimit': oraFillimit,
        'ora_mbarimit': oraMbarimit,
      },
    );
    return Booking.fromJson(response.data);
  }

  Future<void> cancelBooking(int id) async {
    await _dio.put(ApiConstants.cancelBooking(id));
  }
}
