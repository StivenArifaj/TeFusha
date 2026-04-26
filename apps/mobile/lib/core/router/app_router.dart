import 'package:go_router/go_router.dart';
import '../../data/datasources/local/token_storage.dart';
import '../../presentation/splash/splash_screen.dart';
import '../../presentation/onboarding/onboarding_screen.dart';
import '../../presentation/auth/login_page.dart';
import '../../presentation/auth/register_page.dart';
import '../../presentation/home/home_page.dart';
import '../../presentation/fields/field_list_page.dart';
import '../../presentation/fields/field_detail_page.dart';
import '../../presentation/booking/booking_page.dart';
import '../../presentation/booking/booking_confirmation_page.dart';
import '../../presentation/booking/my_bookings_page.dart';
import '../../presentation/community/announcement_feed_page.dart';
import '../../presentation/community/create_announcement_page.dart';
import '../../presentation/community/announcement_detail_page.dart';
import '../../presentation/teams/my_teams_page.dart';
import '../../presentation/teams/create_team_page.dart';
import '../../presentation/teams/team_detail_page.dart';
import '../../presentation/events/event_list_page.dart';
import '../../presentation/events/event_detail_page.dart';
import '../../presentation/events/register_team_page.dart';
import '../../presentation/events/bracket_page.dart';
import '../../presentation/events/match_result_page.dart';
import '../../presentation/profile/profile_page.dart';
import '../../presentation/profile/edit_profile_page.dart';
import '../../presentation/owner/owner_dashboard_page.dart';
import '../../presentation/owner/register_field_page.dart';
import '../../presentation/owner/owner_bookings_page.dart';

final appRouter = GoRouter(
  initialLocation: '/splash',
  redirect: (context, state) async {
    final loggedIn   = await TokenStorage.isLoggedIn();
    final loc        = state.matchedLocation;
    final authRoutes = ['/auth/login', '/auth/register', '/onboarding', '/splash'];
    final isAuthRoute = authRoutes.any((r) => loc.startsWith(r));

    if (!loggedIn && !isAuthRoute) return '/auth/login';
    if (loggedIn  &&  isAuthRoute && loc != '/splash') return '/home';
    return null;
  },
  routes: [
    GoRoute(path: '/splash',         builder: (_, __) => const SplashScreen()),
    GoRoute(path: '/onboarding',     builder: (_, __) => const OnboardingScreen()),
    GoRoute(path: '/auth/login',     builder: (_, __) => const LoginPage()),
    GoRoute(path: '/auth/register',  builder: (_, __) => const RegisterPage()),
    GoRoute(path: '/home',           builder: (_, __) => const HomePage()),

    // Fields
    GoRoute(path: '/fields',         builder: (_, __) => const FieldListPage()),
    GoRoute(
      path: '/fields/:id',
      builder: (_, s) => FieldDetailPage(fieldId: int.parse(s.pathParameters['id']!)),
    ),
    GoRoute(
      path: '/fields/:id/book',
      builder: (_, s) => BookingPage(fieldId: int.parse(s.pathParameters['id']!)),
    ),
    GoRoute(path: '/booking/success', builder: (_, __) => const BookingConfirmationPage(fieldId: 0)),
    GoRoute(path: '/my-bookings',    builder: (_, __) => const MyBookingsPage()),

    // Community
    GoRoute(path: '/community',      builder: (_, __) => const AnnouncementFeedPage()),
    GoRoute(
      path: '/community/:id',
      builder: (_, s) => AnnouncementDetailPage(id: int.parse(s.pathParameters['id']!)),
    ),
    GoRoute(path: '/community/new',  builder: (_, __) => const CreateAnnouncementPage()),

    // Teams
    GoRoute(path: '/teams',          builder: (_, __) => const MyTeamsPage()),
    GoRoute(path: '/teams/new',      builder: (_, __) => const CreateTeamPage()),
    GoRoute(
      path: '/teams/:id',
      builder: (_, s) => TeamDetailPage(id: int.parse(s.pathParameters['id']!)),
    ),

    // Events / Tournaments
    GoRoute(path: '/events',         builder: (_, __) => const EventListPage()),
    GoRoute(
      path: '/events/:id',
      builder: (_, s) => EventDetailPage(eventId: int.parse(s.pathParameters['id']!)),
    ),
    GoRoute(
      path: '/events/:id/register',
      builder: (_, s) => RegisterTeamForEventPage(eventId: int.parse(s.pathParameters['id']!)),
    ),
    GoRoute(
      path: '/events/:id/bracket',
      builder: (_, s) => BracketPage(eventId: int.parse(s.pathParameters['id']!)),
    ),
    GoRoute(
      path: '/events/:eventId/matches/:matchId/result',
      builder: (_, s) => MatchResultPage(
        eventId: int.parse(s.pathParameters['eventId']!),
        matchId: int.parse(s.pathParameters['matchId']!),
      ),
    ),

    // Profile
    GoRoute(path: '/profile',        builder: (_, __) => const ProfilePage()),
    GoRoute(path: '/profile/edit',   builder: (_, __) => const EditProfilePage()),

    // Field Owner
    GoRoute(path: '/owner',          builder: (_, __) => const OwnerDashboardPage()),
    GoRoute(path: '/owner/fields/new', builder: (_, __) => const RegisterFieldPage()),
    GoRoute(path: '/owner/bookings', builder: (_, __) => const OwnerBookingsPage(fieldId: 0)),
  ],
);
