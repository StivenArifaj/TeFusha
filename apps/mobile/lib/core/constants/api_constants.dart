class ApiConstants {
  ApiConstants._();

  // Change this to your Vercel URL in production
  static const String baseUrl      = 'http://localhost:4000'; // Physical device via adb reverse

  // Auth
  static const String register     = '/api/auth/register';
  static const String login        = '/api/auth/login';
  static const String refresh      = '/api/auth/refresh';

  // Fields
  static const String fields       = '/api/fields';
  static String fieldById(int id)  => '/api/fields/$id';
  static String fieldAvailability(int id) => '/api/fields/$id/availability';

  // Bookings
  static const String bookings     = '/api/bookings';
  static const String myBookings   = '/api/bookings/mine';
  static String confirmBooking(int id) => '/api/bookings/$id/confirm';
  static String cancelBooking(int id)  => '/api/bookings/$id/cancel';

  // Events
  static const String events       = '/api/events';
  static String eventById(int id)  => '/api/events/$id';
  static String registerTeam(int id)       => '/api/events/$id/teams';
  static String generateFixtures(int id)   => '/api/events/$id/generate-fixtures';
  static String updateMatch(int eId, int mId) => '/api/events/$eId/matches/$mId';
}
