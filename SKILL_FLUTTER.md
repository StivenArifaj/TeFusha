# TeFusha — SKILL: Flutter Mobile App (iOS + Android)
> Feed this file to Gemini CLI before any Flutter work.
> Stack locked by PMP §15.1 (modified): Flutter 3.x (Dart) — replaces React Native

---

## ABSOLUTE RULES (never break these)

1. **Framework**: Flutter 3.x only. Never React Native, Ionic, or any other.
2. **State management**: flutter_bloc only. Never Provider, Riverpod, GetX.
3. **Navigation**: go_router only. Never Navigator.push directly.
4. **HTTP client**: Dio only. Never http package.
5. **Token storage**: flutter_secure_storage only. Never SharedPreferences for tokens.
6. **Language**: Albanian (`sq_AL`) as primary locale for all UI strings.
7. **Architecture**: Feature-based folders under `lib/presentation/`. One BLoC per feature.
8. **No hardcoded strings** in widget files — all strings in `app_strings.dart`.
9. **No hardcoded colors** in widget files — all colors in `app_colors.dart`.
10. **API base URL** must come from environment config, never hardcoded.

---

## PROJECT STRUCTURE

```
apps/mobile/
├── lib/
│   ├── main.dart                   ← Entry point
│   ├── app.dart                    ← MaterialApp.router
│   ├── core/
│   │   ├── constants/
│   │   │   ├── app_colors.dart     ← ALL colors defined here
│   │   │   ├── app_strings.dart    ← ALL Albanian UI strings
│   │   │   └── api_constants.dart  ← Base URL + endpoints
│   │   ├── theme/
│   │   │   └── app_theme.dart      ← ThemeData light + dark
│   │   ├── router/
│   │   │   └── app_router.dart     ← GoRouter config
│   │   ├── di/
│   │   │   └── injection.dart      ← GetIt dependency injection
│   │   └── utils/
│   │       ├── validators.dart
│   │       └── date_utils.dart
│   ├── data/
│   │   ├── models/
│   │   │   ├── user.dart           ← @JsonSerializable
│   │   │   ├── field.dart
│   │   │   ├── booking.dart
│   │   │   └── event.dart
│   │   ├── repositories/
│   │   │   ├── auth_repository.dart
│   │   │   ├── field_repository.dart
│   │   │   ├── booking_repository.dart
│   │   │   └── event_repository.dart
│   │   └── datasources/
│   │       ├── remote/
│   │       │   └── api_client.dart ← Dio setup + interceptors
│   │       └── local/
│   │           └── token_storage.dart
│   └── presentation/
│       ├── auth/
│       │   ├── bloc/
│       │   │   ├── auth_bloc.dart
│       │   │   ├── auth_event.dart
│       │   │   └── auth_state.dart
│       │   ├── login_page.dart
│       │   └── register_page.dart
│       ├── home/
│       │   └── home_page.dart
│       ├── fields/
│       │   ├── bloc/
│       │   │   ├── field_bloc.dart
│       │   │   ├── field_event.dart
│       │   │   └── field_state.dart
│       │   ├── field_list_page.dart
│       │   ├── field_detail_page.dart
│       │   └── widgets/
│       │       ├── field_card.dart
│       │       └── availability_calendar.dart
│       ├── booking/
│       │   ├── bloc/
│       │   ├── booking_page.dart
│       │   ├── my_bookings_page.dart
│       │   └── widgets/
│       │       └── time_slot_picker.dart
│       ├── events/
│       │   ├── bloc/
│       │   ├── event_list_page.dart
│       │   ├── event_detail_page.dart
│       │   └── widgets/
│       │       └── bracket_widget.dart
│       └── profile/
│           └── profile_page.dart
├── test/
│   ├── booking_page_test.dart
│   └── field_bloc_test.dart
└── pubspec.yaml
```

---

## SETUP COMMANDS

```bash
# Create Flutter project
flutter create apps/mobile --org al.tefusha --project-name tefusha
cd apps/mobile

# Verify Flutter is ready
flutter doctor

# Install dependencies (add to pubspec.yaml first, then run)
flutter pub get

# Generate JSON serialization code (run after creating any model)
flutter pub run build_runner build --delete-conflicting-outputs

# Run on connected device or emulator
flutter run

# Build release APK
flutter build apk --release

# Build App Bundle (for Play Store)
flutter build appbundle --release
```

---

## pubspec.yaml (complete)

```yaml
name: tefusha
description: Platformë shqiptare për fushat sportive

publish_to: 'none'

version: 1.0.0+1

environment:
  sdk: '>=3.0.0 <4.0.0'

dependencies:
  flutter:
    sdk: flutter

  # State Management
  flutter_bloc: ^8.1.3
  equatable: ^2.0.5

  # Navigation
  go_router: ^12.0.0

  # HTTP / API
  dio: ^5.3.2

  # Local Storage
  flutter_secure_storage: ^9.0.0
  hive_flutter: ^1.1.0

  # UI
  google_fonts: ^6.1.0
  flutter_svg: ^2.0.9
  cached_network_image: ^3.3.0
  shimmer: ^3.0.0

  # Maps
  google_maps_flutter: ^2.5.3

  # Calendar / Date picker
  table_calendar: ^3.0.9

  # JSON serialization
  json_annotation: ^4.8.1

  # Dependency Injection
  get_it: ^7.6.4

  # Localization
  flutter_localizations:
    sdk: flutter
  intl: ^0.18.1

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.0
  build_runner: ^2.4.6
  json_serializable: ^6.7.1
  mockito: ^5.4.2
  bloc_test: ^9.1.5

flutter:
  uses-material-design: true
```

---

## DESIGN SYSTEM (implement exactly)

### app_colors.dart
```dart
import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary palette — Albanian red + sports green
  static const Color primary      = Color(0xFFE8002D); // Albanian flag red
  static const Color primaryDark  = Color(0xFFB0001F);
  static const Color secondary    = Color(0xFF2E7D32); // Sports green
  static const Color accent       = Color(0xFFFF6F00); // Energy orange

  // Neutral
  static const Color background   = Color(0xFFF5F5F5);
  static const Color surface      = Color(0xFFFFFFFF);
  static const Color onSurface    = Color(0xFF212121);
  static const Color hint         = Color(0xFF9E9E9E);
  static const Color divider      = Color(0xFFE0E0E0);

  // Semantic
  static const Color success      = Color(0xFF4CAF50);
  static const Color warning      = Color(0xFFFFC107);
  static const Color error        = Color(0xFFF44336);
  static const Color info         = Color(0xFF2196F3);

  // Booking status (matches PMP §13 BookingStatus enum)
  static const Color nePritje     = Color(0xFFFFC107); // pending = yellow
  static const Color konfirmuar   = Color(0xFF4CAF50); // confirmed = green
  static const Color anuluar      = Color(0xFFF44336); // cancelled = red
}
```

### app_strings.dart (key Albanian strings)
```dart
class AppStrings {
  AppStrings._();

  // App
  static const String appName      = 'TeFusha';
  static const String tagline      = 'Rezervo fushën tënde sportive';

  // Auth
  static const String login        = 'Hyr';
  static const String register     = 'Regjistrohu';
  static const String email        = 'Email';
  static const String password     = 'Fjalëkalimi';
  static const String fullName     = 'Emri i plotë';
  static const String phone        = 'Nr. telefoni';
  static const String logout       = 'Dil';

  // Fields
  static const String fields       = 'Fushat Sportive';
  static const String searchHint   = 'Kërko sipas qytetit...';
  static const String filter       = 'Filtro';
  static const String city         = 'Qyteti';
  static const String fieldType    = 'Lloji i Fushës';
  static const String price        = 'Çmimi';
  static const String perHour      = 'L/orë';
  static const String noFields     = 'Asnjë fushë nuk u gjet';
  static const String capacity     = 'Kapaciteti';

  // Booking
  static const String book         = 'Rezervo';
  static const String selectDate   = '1. Zgjedh Datën';
  static const String selectTime   = '2. Zgjedh Orën';
  static const String confirm      = 'Konfirmo Rezervimin';
  static const String cancel       = 'Anulo';
  static const String noSlots      = 'Nuk ka orare të lira për këtë ditë';
  static const String myBookings   = 'Rezervimet e Mia';
  static const String confirmBook  = 'A dëshiron ta rezervosh fushën?';

  // Events
  static const String events       = 'Evente & Kampionate';
  static const String createEvent  = 'Krijo Event';
  static const String registerTeam = 'Regjistro Ekipin';
  static const String bracket      = 'Tabela';
  static const String round        = 'Raundi';

  // Errors
  static const String networkError   = 'Problem me lidhjen. Provo sërish.';
  static const String serverError    = 'Gabim serveri. Provo më vonë.';
  static const String unauthorized   = 'Duhet të hysh në llogari.';
  static const String forbidden      = 'Nuk ke akses për këtë veprim.';
  static const String slotTaken      = 'Ora është e zënë — zgjedh një orar tjetër.';
  static const String requiredField  = 'Ky fushë është i detyrueshëm';
  static const String invalidEmail   = 'Email i pavlefshëm';
  static const String passwordMin    = 'Fjalëkalimi duhet të ketë minimum 6 karaktere';
}
```

### api_constants.dart
```dart
class ApiConstants {
  ApiConstants._();

  // Change this to your Vercel URL in production
  static const String baseUrl      = 'http://10.0.2.2:3001'; // Android emulator → localhost
  // static const String baseUrl   = 'http://localhost:3001';  // iOS simulator

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
```

---

## DIO SETUP WITH AUTH INTERCEPTOR

### data/datasources/remote/api_client.dart
```dart
import 'package:dio/dio.dart';
import '../../local/token_storage.dart';
import '../../../core/constants/api_constants.dart';

class ApiClient {
  static Dio? _dio;

  static Dio get instance {
    _dio ??= _createDio();
    return _dio!;
  }

  static Dio _createDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 15),
        sendTimeout: const Duration(seconds: 15),
        headers: {'Content-Type': 'application/json'},
      ),
    );
    dio.interceptors.add(_AuthInterceptor(dio));
    return dio;
  }
}

class _AuthInterceptor extends Interceptor {
  final Dio dio;
  _AuthInterceptor(this.dio);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await TokenStorage.getAccessToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      try {
        final refresh = await TokenStorage.getRefreshToken();
        final response = await dio.post(
          ApiConstants.refresh,
          data: {'refresh_token': refresh},
          options: Options(headers: {}), // no auth header on refresh
        );
        await TokenStorage.saveTokens(
          access: response.data['access_token'],
          refresh: response.data['refresh_token'],
        );
        final retryOpts = err.requestOptions;
        retryOpts.headers['Authorization'] =
            'Bearer ${response.data["access_token"]}';
        return handler.resolve(await dio.fetch(retryOpts));
      } catch (_) {
        await TokenStorage.clear();
        // TODO: navigate to login via a global navigator key
      }
    }
    handler.next(err);
  }
}
```

### data/datasources/local/token_storage.dart
```dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

class TokenStorage {
  static const _storage    = FlutterSecureStorage();
  static const _accessKey  = 'tf_access';
  static const _refreshKey = 'tf_refresh';
  static const _userKey    = 'tf_user';

  static Future<void> saveTokens({
    required String access,
    required String refresh,
  }) async {
    await _storage.write(key: _accessKey,  value: access);
    await _storage.write(key: _refreshKey, value: refresh);
  }

  static Future<String?> getAccessToken()  async => _storage.read(key: _accessKey);
  static Future<String?> getRefreshToken() async => _storage.read(key: _refreshKey);

  static Future<bool> isLoggedIn() async {
    final token = await _storage.read(key: _accessKey);
    return token != null;
  }

  static Future<void> clear() async => _storage.deleteAll();

  static Map<String, dynamic>? decodeJwt(String token) {
    try {
      final parts = token.split('.');
      final payload = base64Url.decode(base64Url.normalize(parts[1]));
      return jsonDecode(utf8.decode(payload)) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }
}
```

---

## BLoC PATTERN (implement this pattern for ALL features)

```dart
// EVENTS (what can happen)
abstract class FeatureEvent {}
class LoadFeatureEvent extends FeatureEvent {}
class CreateFeatureEvent extends FeatureEvent {
  final String data;
  CreateFeatureEvent(this.data);
}

// STATES (what the UI shows)
abstract class FeatureState {}
class FeatureInitial  extends FeatureState {}
class FeatureLoading  extends FeatureState {}
class FeatureLoaded   extends FeatureState {
  final List<dynamic> items;
  FeatureLoaded(this.items);
}
class FeatureError    extends FeatureState {
  final String message;
  FeatureError(this.message);
}

// BLOC
class FeatureBloc extends Bloc<FeatureEvent, FeatureState> {
  final FeatureRepository _repo;

  FeatureBloc(this._repo) : super(FeatureInitial()) {
    on<LoadFeatureEvent>(_onLoad);
    on<CreateFeatureEvent>(_onCreate);
  }

  Future<void> _onLoad(LoadFeatureEvent event, Emitter<FeatureState> emit) async {
    emit(FeatureLoading());
    try {
      final items = await _repo.getAll();
      emit(FeatureLoaded(items));
    } on DioException catch (e) {
      emit(FeatureError(_mapDioError(e)));
    } catch (e) {
      emit(FeatureError(AppStrings.serverError));
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
```

---

## GOROUTER SETUP (with auth redirect)

```dart
// core/router/app_router.dart
import 'package:go_router/go_router.dart';
import '../../data/datasources/local/token_storage.dart';
// ... import all pages

final appRouter = GoRouter(
  initialLocation: '/home',
  redirect: (context, state) async {
    final loggedIn = await TokenStorage.isLoggedIn();
    final goingToAuth = state.matchedLocation.startsWith('/auth');
    if (!loggedIn && !goingToAuth) return '/auth/login';
    if (loggedIn  &&  goingToAuth) return '/home';
    return null;
  },
  routes: [
    GoRoute(path: '/auth/login',    builder: (_, __) => const LoginPage()),
    GoRoute(path: '/auth/register', builder: (_, __) => const RegisterPage()),
    GoRoute(path: '/home',          builder: (_, __) => const HomePage()),
    GoRoute(path: '/fields',        builder: (_, __) => const FieldListPage()),
    GoRoute(
      path: '/fields/:id',
      builder: (_, state) => FieldDetailPage(
        fieldId: int.parse(state.pathParameters['id']!),
      ),
    ),
    GoRoute(
      path: '/fields/:id/book',
      builder: (_, state) => BookingPage(
        fieldId: int.parse(state.pathParameters['id']!),
      ),
    ),
    GoRoute(path: '/my-bookings',  builder: (_, __) => const MyBookingsPage()),
    GoRoute(path: '/events',       builder: (_, __) => const EventListPage()),
    GoRoute(
      path: '/events/:id',
      builder: (_, state) => EventDetailPage(
        eventId: int.parse(state.pathParameters['id']!),
      ),
    ),
    GoRoute(path: '/profile',      builder: (_, __) => const ProfilePage()),
  ],
);
```

---

## HOME PAGE (bottom navigation)

```dart
// presentation/home/home_page.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _idx = 0;

  final _tabs = [
    (icon: Icons.sports_soccer, label: 'Fushat',     path: '/fields'),
    (icon: Icons.calendar_today, label: 'Rezervimet', path: '/my-bookings'),
    (icon: Icons.emoji_events,  label: 'Evente',     path: '/events'),
    (icon: Icons.person,        label: 'Profili',    path: '/profile'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _idx,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.hint,
        type: BottomNavigationBarType.fixed,
        onTap: (i) {
          setState(() => _idx = i);
          context.go(_tabs[i].path);
        },
        items: _tabs.map((t) => BottomNavigationBarItem(
          icon: Icon(t.icon), label: t.label,
        )).toList(),
      ),
    );
  }

  Widget _buildBody() {
    // Navigate to appropriate page based on index
    switch (_idx) {
      case 0: return const FieldListPage();
      case 1: return const MyBookingsPage();
      case 2: return const EventListPage();
      case 3: return const ProfilePage();
      default: return const FieldListPage();
    }
  }
}
```

---

## COMMON ERRORS & FIXES

### Error: "CocoaPods not installed" (iOS)
```bash
sudo gem install cocoapods
cd ios && pod install
```

### Error: "Gradle build failed" (Android)
```bash
cd android
./gradlew clean
flutter clean && flutter pub get
flutter run
```

### Error: "MissingPluginException for flutter_secure_storage"
```bash
flutter clean
flutter pub get
# Restart the app completely (not hot reload)
```

### Error: "type 'Null' is not a subtype of type 'String'" in JSON parsing
- Your API returned null for a field marked non-nullable in your model
- Either: fix the model to use `String?` OR fix the API to always return the field

### Error: "Bad state: No element" in `firstWhere`
- Always use `firstWhere(..., orElse: () => defaultValue)`
- Never use `firstWhere` without `orElse` on lists that might not contain the element

### Error: build_runner "Already exists" conflict
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### Error: "Connection refused" when calling API from Android emulator
- Android emulator cannot reach `localhost` — use `10.0.2.2` instead
- iOS simulator CAN use `localhost`
- For real device: use your computer's local network IP (e.g., `192.168.1.x`)

### Error: GoRouter redirect infinite loop
- Check that your redirect function handles all cases: logged in → not going to auth → null; logged in → going to auth → '/home'

### Error: BlocProvider not found above widget tree
- Every page that uses a BLoC must be wrapped in `BlocProvider`
- Either wrap at route level in GoRouter, OR wrap in the page's own `build` method
- Use `BlocProvider(create: (ctx) => getIt<FeatureBloc>()..add(LoadEvent()), child: ...)`

### Error: Shimmer / skeleton not showing
- Shimmer requires a `Shimmer.fromColors` wrapper around placeholder widgets
- Placeholder widgets need fixed height/width to show

---

## TESTING CHECKLIST (before moving to Web platform)

```bash
# 1. No analysis issues
flutter analyze

# 2. All tests pass
flutter test

# 3. Run on Android emulator
flutter run -d emulator-5554

# 4. Run on iOS simulator (Mac only)
flutter run -d iPhone

# 5. Build release APK (must succeed)
flutter build apk --release
```

### Features that MUST work before launch
- [ ] Register + Login → stores JWT securely
- [ ] Field list loads and filters by city/type
- [ ] Field detail page shows info + availability calendar
- [ ] Booking page shows only free time slots
- [ ] Cannot book an already-booked slot
- [ ] Booking confirmation dialog works
- [ ] My Bookings page shows history
- [ ] Events list + event detail + bracket widget
- [ ] Bottom navigation works on all tabs
- [ ] Logout clears tokens and redirects to login
- [ ] App handles network errors gracefully (shows Albanian error message)
