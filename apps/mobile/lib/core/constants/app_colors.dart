import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary — Albanian red (main brand color, used for all primary actions)
  static const Color primary       = Color(0xFFE8002D);
  static const Color primaryDark   = Color(0xFFB0001F);
  static const Color primaryLight  = Color(0xFFFF5252);

  // Secondary — Sports green (used for success states and sport-related icons)
  static const Color secondary     = Color(0xFF2E7D32);
  static const Color secondaryLight = Color(0xFF60AD5E);

  // Accent — Energy orange (used for notifications and badges only)
  static const Color accent        = Color(0xFFFF6F00);

  // Background and surfaces
  static const Color background    = Color(0xFFF5F5F5);  // page backgrounds
  static const Color surface       = Color(0xFFFFFFFF);  // cards and sheets
  static const Color surfaceVariant = Color(0xFFF0F0F0); // secondary card areas

  // Home screen hero gradient — dark navy (used ONLY for hero header)
  static const Color heroStart     = Color(0xFF1A1A2E);
  static const Color heroEnd       = Color(0xFF16213E);

  // Text colors
  static const Color textPrimary   = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textHint      = Color(0xFFBDBDBD);
  static const Color textOnDark    = Color(0xFFFFFFFF);

  // Divider and borders
  static const Color divider       = Color(0xFFE0E0E0);
  static const Color border        = Color(0xFFEEEEEE);

  // Semantic colors
  static const Color success       = Color(0xFF4CAF50);
  static const Color warning       = Color(0xFFFFC107);
  static const Color error         = Color(0xFFF44336);
  static const Color info          = Color(0xFF2196F3);

  // Booking slot colors (used in TimeSlotPicker widget)
  static const Color slotAvailable = Color(0xFFE8F5E9); // light green background
  static const Color slotTaken     = Color(0xFFFFEBEE); // light red background
  static const Color slotSelected  = Color(0xFFE8002D); // primary red, white text

  // Booking status badge colors
  static const Color statusPending   = Color(0xFFFFF9C4); // yellow background
  static const Color statusConfirmed = Color(0xFFE8F5E9); // green background
  static const Color statusCancelled = Color(0xFFFFEBEE); // red background

  // Announcement type badge colors
  static const Color typeNeedPlayer = Color(0xFFE3F2FD); // blue
  static const Color typeNeedOpponent = Color(0xFFFCE4EC); // pink
  static const Color typeNeedTeam   = Color(0xFFF3E5F5); // purple

  // Category chip colors (sport type chips)
  static const Color chipBackground = Color(0xFFFFFFFF);
  static const Color chipSelected   = Color(0xFFE8002D);
  static const Color chipBorder     = Color(0xFFE0E0E0);
}
