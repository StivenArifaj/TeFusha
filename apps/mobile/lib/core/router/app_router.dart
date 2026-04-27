import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tefusha/data/datasources/local/token_storage.dart';
import 'package:tefusha/presentation/splash/splash_screen.dart';
import 'package:tefusha/presentation/onboarding/onboarding_screen.dart';
import 'package:tefusha/presentation/welcome/welcome_screen.dart';
import 'package:tefusha/presentation/auth/login_screen.dart';
import 'package:tefusha/presentation/auth/sign_up_screen.dart';
import 'package:tefusha/presentation/auth/otp_verify_screen.dart';
import 'package:tefusha/presentation/auth/forgot_password_screen.dart';
import 'package:tefusha/presentation/auth/create_new_password_screen.dart';
import 'package:tefusha/presentation/auth/create_your_profile_screen.dart';
import 'package:tefusha/presentation/main/bottom_navigation_screen.dart';
import 'package:tefusha/presentation/home/home_screen.dart';
import 'package:tefusha/presentation/search/search_screen.dart';
import 'package:tefusha/presentation/filter/filter_screen.dart';
import 'package:tefusha/presentation/fields/most_popular_screen.dart';
import 'package:tefusha/presentation/fields/field_detail_screen.dart';
import 'package:tefusha/presentation/booking/request_to_book_screen.dart';
import 'package:tefusha/presentation/booking/checkout_screen.dart';
import 'package:tefusha/presentation/booking/booking_detail_screen.dart';
import 'package:tefusha/presentation/booking/booking_complete_screen.dart';
import 'package:tefusha/presentation/booking/my_booking_screen.dart';
import 'package:tefusha/presentation/community/announcement_feed_screen.dart';
import 'package:tefusha/presentation/community/create_announcement_screen.dart';
import 'package:tefusha/presentation/community/announcement_detail_screen.dart';
import 'package:tefusha/presentation/teams/my_teams_screen.dart';
import 'package:tefusha/presentation/teams/create_team_screen.dart';
import 'package:tefusha/presentation/teams/team_detail_screen.dart';
import 'package:tefusha/presentation/events/event_list_screen.dart';
import 'package:tefusha/presentation/events/event_detail_screen.dart';
import 'package:tefusha/presentation/profile/profile_screen.dart';
import 'package:tefusha/presentation/profile/edit_profile_screen.dart';
import 'package:tefusha/presentation/owner/owner_dashboard_screen.dart';
import 'package:tefusha/presentation/owner/register_field_screen.dart';
import 'package:tefusha/presentation/owner/owner_bookings_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/splash',
  redirect: (context, state) async {
    final loggedIn = await TokenStorage.isLoggedIn();
    final loc = state.matchedLocation;
    
    // Public routes that don't require login
    final publicRoutes = [
      '/splash',
      '/onboarding',
      '/welcome',
      '/login',
      '/sign-up',
      '/otp-verify',
      '/forgot-password',
      '/create-new-password',
    ];
    
    final isPublicRoute = publicRoutes.any((r) => loc.startsWith(r));

    if (!loggedIn && !isPublicRoute) return '/welcome';
    if (loggedIn && (loc == '/login' || loc == '/sign-up' || loc == '/welcome')) return '/home';
    
    return null;
  },
  routes: [
    GoRoute(path: '/splash', builder: (_, __) => const SplashScreen()),
    GoRoute(path: '/onboarding', builder: (_, __) => const OnboardingScreen()),
    GoRoute(path: '/welcome', builder: (_, __) => const WelcomeScreen()),
    GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),
    GoRoute(path: '/sign-up', builder: (_, __) => const SignUpScreen()),
    GoRoute(
      path: '/otp-verify',
      builder: (_, state) => OtpVerifyScreen(email: state.extra as String? ?? ''),
    ),
    GoRoute(path: '/forgot-password', builder: (_, __) => const ForgotPasswordScreen()),
    GoRoute(path: '/create-new-password', builder: (_, __) => const CreateNewPasswordScreen()),
    GoRoute(path: '/create-profile', builder: (_, __) => const CreateYourProfileScreen()),
    
    // Main App Shell
    GoRoute(path: '/home', builder: (_, __) => const BottomNavigationScreen()),
    
    // Search & Filter
    GoRoute(path: '/search', builder: (_, __) => const SearchScreen()),
    GoRoute(path: '/filter', builder: (_, __) => const FilterScreen()),
    
    // Fields
    GoRoute(path: '/fields', builder: (_, __) => const MostPopularScreen()),
    GoRoute(
      path: '/field/:id',
      builder: (_, s) => FieldDetailScreen(fieldId: int.parse(s.pathParameters['id']!)),
    ),
    
    // Booking
    GoRoute(
      path: '/book/:id',
      builder: (_, s) => RequestToBookScreen(fieldId: int.parse(s.pathParameters['id']!)),
    ),
    GoRoute(path: '/checkout', builder: (_, __) => const CheckoutScreen()),
    GoRoute(
      path: '/booking/:id',
      builder: (_, s) => BookingDetailScreen(id: int.parse(s.pathParameters['id']!)),
    ),
    GoRoute(path: '/booking-complete', builder: (_, __) => const BookingCompleteScreen(fieldId: 0)),
    GoRoute(path: '/my-bookings', builder: (_, __) => const MyBookingScreen()),
    
    // Community
    GoRoute(path: '/community', builder: (_, __) => const AnnouncementFeedScreen()),
    GoRoute(path: '/community/new', builder: (_, __) => const CreateAnnouncementScreen()),
    GoRoute(
      path: '/community/:id',
      builder: (_, s) => AnnouncementDetailScreen(id: int.parse(s.pathParameters['id']!)),
    ),
    
    // Teams
    GoRoute(path: '/teams', builder: (_, __) => const MyTeamsScreen()),
    GoRoute(path: '/teams/new', builder: (_, __) => const CreateTeamScreen()),
    GoRoute(
      path: '/teams/:id',
      builder: (_, s) => TeamDetailScreen(id: int.parse(s.pathParameters['id']!)),
    ),
    
    // Events
    GoRoute(path: '/events', builder: (_, __) => const EventListScreen()),
    GoRoute(
      path: '/events/:id',
      builder: (_, s) => EventDetailScreen(eventId: int.parse(s.pathParameters['id']!)),
    ),
    
    // Profile
    GoRoute(path: '/profile', builder: (_, __) => const ProfileScreen()),
    GoRoute(path: '/profile/edit', builder: (_, __) => const EditProfileScreen()),
    
    // Owner
    GoRoute(path: '/owner', builder: (_, __) => const OwnerDashboardScreen()),
    GoRoute(path: '/owner/fields/new', builder: (_, __) => const RegisterFieldScreen()),
    GoRoute(path: '/owner/bookings', builder: (_, __) => const OwnerBookingsScreen(fieldId: 0)),
    
    // Misc
    GoRoute(path: '/notifications', builder: (_, __) => const Scaffold(body: Center(child: Text('Notifications')))),
  ],
);
