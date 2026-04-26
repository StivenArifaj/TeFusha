import 'package:get_it/get_it.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/field_repository.dart';
import '../../data/repositories/booking_repository.dart';
import '../../data/repositories/event_repository.dart';
import '../../data/repositories/announcement_repository.dart';
import '../../data/repositories/standalone_team_repository.dart';

final getIt = GetIt.instance;

void setupDependencies() {
  // Repositories
  getIt.registerLazySingleton(() => AuthRepository());
  getIt.registerLazySingleton(() => FieldRepository());
  getIt.registerLazySingleton(() => BookingRepository());
  getIt.registerLazySingleton(() => EventRepository());
  getIt.registerLazySingleton(() => AnnouncementRepository());
  getIt.registerLazySingleton(() => StandaloneTeamRepository());
}