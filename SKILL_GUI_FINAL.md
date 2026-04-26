# TeFusha — SKILL_GUI_FINAL.md
# Complete GUI Rebuild + Feature Completion Guide for Gemini CLI
# Version: FINAL — All platforms, all screens, all user journeys

> **READ THIS BEFORE ANYTHING ELSE.**
> This file is the single source of truth for rebuilding and completing the entire TeFusha UI/UX
> across Flutter (primary), React Web, and React Admin. It was written based on:
>
> - The full project audit (April 2026) confirming what is built and what is missing
> - PMP v2.1 (all sections, Albanian language document)
> - The agreed design direction: Option 3 — Multi-Sports Field Booking (light surfaces,
>   category chips, large field imagery, clear scheduling grids)
> - Confirmed additions: OpenStreetMap embedded + "Më jep rrugën" Google Maps navigation button,
>   Matchmaking/Announcements system, Independent Teams, full Tournament module
> - Antigravity skills installed: base Antigravity, Mobile App Dev bundle, UI Pro Max bundle

---

## TABLE OF CONTENTS

1. What Is Already Built (Audit Summary)
2. What This File Will Complete (Full Gap List)
3. Antigravity Skills — How To Use Them In This Project
4. Absolute Rules — Never Break These
5. Database Schema Additions (New Tables)
6. New Backend API Endpoints Required
7. Design System — Complete Specification (Option 3)
8. Complete App Map — Every Screen, Every Platform
9. User Journey Maps — Step-by-Step for Every User Type
10. Flutter Mobile App — Screen-by-Screen Build Guide (PRIMARY)
11. Web Platform (React.js) — Screen-by-Screen Build Guide
12. Admin Panel (React.js) — Screen-by-Screen Build Guide
13. Map Integration — flutter_map + "Më jep rrugën" Button
14. Matchmaking & Announcements Module
15. Independent Teams Module
16. Tournaments & Brackets Module (Expanded)
17. Field Owner Dashboard Module
18. Common Errors & Fixes (GUI Specific)
19. Testing Checklist — Platform by Platform
20. Deployment Order

---

## 1. WHAT IS ALREADY BUILT (AUDIT SUMMARY)

The following was confirmed working in the April 2026 audit. Do NOT rebuild these from scratch.
Only restyle them to match the design system in Section 7 of this file.

**Backend (backend/):** Fully functional. Running on port 4000.
Schema has User, Field, Booking, Event, Team, TeamMember, Match.
Auth (register/login/JWT), Field CRUD, Booking with atomic transaction (FOR UPDATE),
Admin routes, Event routes are all implemented and tested.
TypeScript compiles with 0 errors.

**Flutter (apps/mobile/):**
Basic structure exists with Clean Architecture folders (core, data, domain, presentation).
Auth BLoC, Fields BLoC, Booking BLoC are created.
GoRouter is configured with routes for Login, Register, Home, FieldDetails, MyBookings.
flutter_secure_storage is implemented for tokens.
Dio client with auth interceptor is implemented.
app_colors.dart and app_strings.dart exist.
flutter analyze returns 0 errors. APK builds successfully.

**Web (apps/web/):**
Created with Vite + React + TypeScript.
Axios client, AuthContext, useFields hook are implemented.
Basic pages exist: Fields, Login, Register.
Builds successfully.

**Admin (apps/admin/):**
Created with Vite + React + TypeScript.
Dashboard with stats and bar chart is implemented.
Users, Fields, Bookings pages exist.
Builds successfully.

**WHAT IS MISSING AND MUST BE BUILT WITH THIS FILE:**
- The entire visual design (all screens look unstyled/generic — this file fixes everything)
- Splash screen + Onboarding
- OpenStreetMap integration in FieldDetailPage
- "Më jep rrugën" button
- Matchmaking / Announcements system (no DB table, no UI, no API)
- Independent Teams (teams that exist outside of events)
- Community/Matchmaking tab in Flutter bottom nav
- Teams tab in Flutter bottom nav
- Tournament bracket view (BracketWidget is basic — needs full rebuild)
- Field Owner Dashboard (OwnerDashboardPage, RegisterFieldPage, OwnerBookingsPage)
- Notification system (basic in-app)
- Profile page with stats
- Onboarding flow
- Web: FieldDetailPage, BookingPage, EventDetailPage, Matchmaking section
- Admin: Announcements management page, enhanced field management with map preview

---

## 2. WHAT THIS FILE WILL COMPLETE

After following every instruction in this file, the result will be:

A Flutter mobile app with 28 fully styled screens covering every user type (regular user,
field owner, admin on mobile). The visual language is Option 3 — clean white/light gray
surfaces, bold Albanian red primary color (#E8002D), Nunito font family, large field
photography cards, horizontal sport category chips, a 5-tab bottom navigation bar, and
a dark gradient hero header on the home screen only.

A React web platform with 12 pages where users can browse fields, book, see events,
and manage their matchmaking announcements, all matching the same color palette.

A React admin panel with 8 pages giving the platform administrators full control over
users, fields, bookings, events, and announcements, with a statistics dashboard.

Two new database tables (Announcement, StandaloneTeam) with full API coverage.

---

## 3. ANTIGRAVITY SKILLS — HOW TO USE THEM IN THIS PROJECT

You have installed the following Antigravity skill bundles. Here is exactly how to activate
and use them at the start of each development session.

**Your skills are located at:**
C:\Users\stive\.gemini\skills\ (Gemini CLI skills)
C:\Users\stive\.gemini\antigravity\skills\ (Antigravity skills)

**Before starting ANY Flutter screen work, activate these skills by typing into Gemini CLI:**

@mobile-app-dev @ui-pro-max

These two bundles together give the agent knowledge about Flutter widget best practices,
responsive layouts, animation patterns, and professional UI component construction.
Always activate both together when working on Flutter screens.

**Before starting ANY React web or admin work, activate:**

@ui-pro-max

This gives the agent the React component patterns and CSS-in-JS knowledge needed.

**General rules for using Antigravity skills:**
- Always mention the skill at the START of your prompt, before describing the task
- If the agent starts generating generic or poor-quality UI code, re-activate the skill
  in your next message
- If you get a "context limit" or "truncation" warning from Antigravity, follow the
  instructions in: C:\Users\stive\.gemini\antigravity\docs\users\agent-overload-recovery.md
- Use @mobile-app-dev specifically when building: BLoC classes, repository patterns,
  GoRouter configuration, and Flutter state management
- Use @ui-pro-max specifically when building: widget trees, custom painters, animations,
  cards, bottom sheets, and any visual component

**Recommended additional skills to install before proceeding:**
Run these commands in your terminal to add skills that will significantly improve
the quality of the map integration and database work:

npx antigravity-awesome-skills --gemini --category backend
npx antigravity-awesome-skills --gemini --category database
npx antigravity-awesome-skills --gemini --category maps

After installing, activate with: @backend @database when doing DB schema work.

---

## 4. ABSOLUTE RULES — NEVER BREAK THESE

These rules apply to EVERY file generated in this project. No exceptions.

**Design rules:**
1. Primary color is always #E8002D (Albanian red). Never change this.
2. Secondary color is always #2E7D32 (sports green). Never change this.
3. Background is always #F5F5F5 (light gray). Never pure white as page background.
4. Surface (cards, modals, sheets) is always #FFFFFF.
5. Font family is always Nunito (google_fonts: ^6.1.0). Never use the default system font.
6. Dark gradient header (#1A1A2E to #16213E) is used ONLY on the home screen hero section.
   All other screens use the #F5F5F5 light background.
7. All border radii on cards are 16px. All buttons are 12px border radius.
8. Icons come from Material Icons only (built into Flutter). Never add an extra icon package.
9. All error messages, labels, placeholders, and UI text are written in Albanian (sq_AL).
10. Never use Tailwind in Flutter. Never use raw hex colors in widget files —
    always reference AppColors.primaryColor etc.

**Architecture rules:**
11. Flutter state management is flutter_bloc only. Never Provider, Riverpod, GetX.
12. Navigation is go_router only. Never Navigator.push directly in a page file.
13. All API calls go through the repository layer. Never call Dio directly from a page or BLoC.
14. Token storage uses flutter_secure_storage only. Never SharedPreferences for tokens.
15. Every model file uses @JsonSerializable. Always run build_runner after adding a model.

**Backend rules:**
16. All new API endpoints follow the existing pattern in backend/src/routes/.
17. All request bodies are validated with Zod before reaching the controller.
18. All error responses use the format: { error: "Mesazhi në shqip" }
19. The backend runs on port 4000. Do not change this.
20. Every new Prisma model requires a migration: npx prisma migrate dev --name description

---

## 5. DATABASE SCHEMA ADDITIONS (NEW TABLES)

The existing schema covers User, Field, Booking, Event, Team, TeamMember, Match.
Two new models must be added. Run the migration BEFORE building any Flutter or API code
that uses these models.

**Step 1: Add these models to backend/prisma/schema.prisma**

Add the following AFTER the existing Match model and BEFORE the closing of the file.
Do not modify any existing models — only add new ones.

```prisma
// ─── NJOFTIM (Matchmaking Announcement) ─────────────────────────
// New table for PMP §4.1 - Community matchmaking feature
// A user or team posts that they need players, opponents, or a team to join

model Announcement {
  id             Int                  @id @default(autoincrement())
  userId         Int
  titull         String               @db.VarChar(150)
  pershkrim      String               @db.Text
  lloji_sportit  String               @db.VarChar(50)
  vendndodhja    String?              @db.VarChar(200)
  data_lojës     DateTime?
  lojtare_nevojitet Int               @default(1)
  tipi           AnnouncementType
  statusi        String               @default("aktiv")
  created_at     DateTime             @default(now())

  perdoruesi     User                 @relation("PerdoruesNjoftim", fields: [userId], references: [id])
  pergjigjet     AnnouncementResponse[]

  @@map("announcements")
}

enum AnnouncementType {
  kerko_lojtar        // I need 1 player to complete my team
  kerko_kundershtare  // My team is looking for an opponent team
  kerko_ekip          // I am a player looking for a team to join
}

model AnnouncementResponse {
  id              Int          @id @default(autoincrement())
  announcementId  Int
  userId          Int
  mesazhi         String?      @db.Text
  created_at      DateTime     @default(now())

  njoftimi        Announcement @relation(fields: [announcementId], references: [id])
  perdoruesi      User         @relation("PerdoruesPergjigje", fields: [userId], references: [id])

  @@map("announcement_responses")
}

// ─── EKIPI I PAVARUR (Standalone Team) ──────────────────────────
// New table — teams that exist permanently, independent of events
// Players can create a team, invite friends, and then register that team for events

model StandaloneTeam {
  id            Int                    @id @default(autoincrement())
  emri          String                 @db.VarChar(100)
  lloji_sportit String                 @db.VarChar(50)
  kapiteni_id   Int
  pershkrim     String?                @db.Text
  created_at    DateTime               @default(now())

  kapiteni      User                   @relation("KapiteniEkipit", fields: [kapiteni_id], references: [id])
  anetaret      StandaloneTeamMember[]

  @@map("standalone_teams")
}

model StandaloneTeamMember {
  id          Int            @id @default(autoincrement())
  ekipi_id    Int
  userId      Int
  roli        String         @default("anetare") // kapiteni, anetare
  joined_at   DateTime       @default(now())

  ekipi       StandaloneTeam @relation(fields: [ekipi_id], references: [id])
  perdoruesi  User           @relation("AnetarEkipit", fields: [userId], references: [id])

  @@unique([ekipi_id, userId])
  @@map("standalone_team_members")
}
```

**Step 2: Also add these new relations to the existing User model.**
Find the User model in schema.prisma and add these lines inside it,
after the existing `ekipet TeamMember[]` line:

```prisma
  // New relations — add these to the existing User model
  njoftimet_e_mia    Announcement[]         @relation("PerdoruesNjoftim")
  pergjigjet_e_mia   AnnouncementResponse[] @relation("PerdoruesPergjigje")
  ekipet_e_mia       StandaloneTeam[]       @relation("KapiteniEkipit")
  anetaresim_ekipe   StandaloneTeamMember[] @relation("AnetarEkipit")
```

**Step 3: Run the migration**

Open PowerShell in the backend/ folder and run:

```powershell
cd backend
npx prisma migrate dev --name add_announcements_and_standalone_teams
npx prisma generate
```

If migration fails with "relation already exists" run:
```powershell
npx prisma migrate resolve --applied "the_migration_name"
npx prisma migrate dev
```

**Step 4: Verify in Prisma Studio**

```powershell
npx prisma studio
```

Confirm that the tables `announcements`, `announcement_responses`,
`standalone_teams`, and `standalone_team_members` all appear with correct columns.

---

## 6. NEW BACKEND API ENDPOINTS REQUIRED

These endpoints must be added to the backend BEFORE building the Flutter screens that use them.
Each endpoint follows the exact same pattern as the existing routes in backend/src/routes/.

**File to create: backend/src/routes/announcement.routes.ts**

```
GET    /api/announcements              — List active announcements (filter: lloji_sportit, tipi)
GET    /api/announcements/:id          — Single announcement with responses
POST   /api/announcements              — Create announcement (authenticated)
PUT    /api/announcements/:id          — Edit own announcement (authenticated, owner only)
DELETE /api/announcements/:id          — Delete own announcement (authenticated, owner only)
POST   /api/announcements/:id/respond  — Respond to an announcement (authenticated)
```

**File to create: backend/src/routes/standalone-team.routes.ts**

```
GET    /api/teams/mine                 — Get teams where user is captain or member
GET    /api/teams/:id                  — Get team details with members
POST   /api/teams                      — Create a new standalone team (authenticated)
PUT    /api/teams/:id                  — Edit team info (captain only)
POST   /api/teams/:id/invite           — Send invitation to a user (captain only)
POST   /api/teams/:id/join             — User joins a team (if invited)
DELETE /api/teams/:id/members/:userId  — Remove member (captain only)
```

**Additions to field owner routes (already exists as /api/fields):**

```
GET    /api/fields/mine                — Get all fields owned by the logged-in pronar_fushe
GET    /api/fields/:id/bookings        — Get all bookings for a specific field (owner only)
PUT    /api/fields/:id/closed-hours    — Set closed hours for a field (owner only)
```

**Add to existing admin routes (backend/src/routes/admin.routes.ts):**

```
GET    /api/admin/announcements        — List all announcements for moderation
DELETE /api/admin/announcements/:id    — Remove inappropriate announcement
GET    /api/admin/teams                — List all standalone teams
```

**Validation schemas to add in backend/src/utils/validators.ts:**

```typescript
export const createAnnouncementSchema = z.object({
  titull:             z.string().min(5).max(150),
  pershkrim:          z.string().min(10),
  lloji_sportit:      z.enum(['futboll', 'basketboll', 'tenis', 'volejboll', 'tjeter']),
  vendndodhja:        z.string().optional(),
  data_lojës:         z.string().datetime().optional(),
  lojtare_nevojitet:  z.number().int().min(1).max(22),
  tipi:               z.enum(['kerko_lojtar', 'kerko_kundershtare', 'kerko_ekip']),
});

export const createStandaloneTeamSchema = z.object({
  emri:           z.string().min(2).max(100),
  lloji_sportit:  z.enum(['futboll', 'basketboll', 'tenis', 'volejboll', 'tjeter']),
  pershkrim:      z.string().optional(),
});
```

---

## 7. DESIGN SYSTEM — COMPLETE SPECIFICATION (OPTION 3)

This section defines every visual token that must be implemented consistently
across ALL platforms. The agent must follow these specifications exactly.
Do not invent new colors, fonts, or spacing values.

**COLOR PALETTE — Update app_colors.dart with these exact values:**

```dart
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
```

**TYPOGRAPHY — Update app_theme.dart with these exact values:**

The font is Nunito from Google Fonts. Use these weights throughout the app:
- Page titles and hero text: Nunito ExtraBold (weight 800)
- Section headings and card titles: Nunito Bold (weight 700)
- Body text and descriptions: Nunito Regular (weight 400)
- Labels, chips, captions: Nunito SemiBold (weight 600)
- Price and number displays: Nunito ExtraBold (weight 800), color primary

**SPACING SYSTEM:**
- xs: 4px
- sm: 8px
- md: 12px
- base: 16px (most common padding)
- lg: 20px
- xl: 24px
- xxl: 32px
- Card padding: 16px all sides
- Page horizontal padding: 16px
- Bottom nav height: 64px
- AppBar height: 56px (standard Material)

**BORDER RADIUS SYSTEM:**
- Cards and containers: 16px
- Buttons (elevated + outlined): 12px
- Chips (sport categories, status badges): 20px (fully rounded)
- Bottom sheets: 24px top corners only
- Input fields: 12px
- Image clips on cards: 16px top corners only, 0 bottom corners

**SHADOW SYSTEM (use for cards only, never for buttons):**
```dart
BoxShadow(
  color: Colors.black.withOpacity(0.06),
  blurRadius: 12,
  offset: Offset(0, 4),
)
```

**UPDATED app_theme.dart — Replace the existing file entirely:**

```dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get light => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary:          AppColors.primary,
      onPrimary:        Colors.white,
      primaryContainer: AppColors.primaryLight,
      onPrimaryContainer: Colors.white,
      secondary:        AppColors.secondary,
      onSecondary:      Colors.white,
      error:            AppColors.error,
      onError:          Colors.white,
      surface:          AppColors.surface,
      onSurface:        AppColors.textPrimary,
    ),
    scaffoldBackgroundColor: AppColors.background,
    textTheme: GoogleFonts.nunitoTextTheme().copyWith(
      displayLarge:  GoogleFonts.nunito(fontSize: 32, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
      displayMedium: GoogleFonts.nunito(fontSize: 28, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
      titleLarge:    GoogleFonts.nunito(fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
      titleMedium:   GoogleFonts.nunito(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
      titleSmall:    GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
      bodyLarge:     GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.w400, color: AppColors.textPrimary),
      bodyMedium:    GoogleFonts.nunito(fontSize: 14, fontWeight: FontWeight.w400, color: AppColors.textSecondary),
      bodySmall:     GoogleFonts.nunito(fontSize: 12, fontWeight: FontWeight.w400, color: AppColors.textHint),
      labelLarge:    GoogleFonts.nunito(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
      labelMedium:   GoogleFonts.nunito(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: GoogleFonts.nunito(
        fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white,
      ),
    ),
    cardTheme: CardTheme(
      color: AppColors.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: EdgeInsets.zero,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
        textStyle: GoogleFonts.nunito(fontSize: 15, fontWeight: FontWeight.w700),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,
        side: const BorderSide(color: AppColors.primary, width: 1.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
        textStyle: GoogleFonts.nunito(fontSize: 15, fontWeight: FontWeight.w700),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primary,
        textStyle: GoogleFonts.nunito(fontSize: 14, fontWeight: FontWeight.w600),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.error),
      ),
      hintStyle: GoogleFonts.nunito(fontSize: 14, color: AppColors.textHint),
      labelStyle: GoogleFonts.nunito(fontSize: 14, color: AppColors.textSecondary),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.chipBackground,
      selectedColor: AppColors.primary,
      labelStyle: GoogleFonts.nunito(fontSize: 13, fontWeight: FontWeight.w600),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: AppColors.chipBorder),
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: AppColors.surface,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.textHint,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
      selectedLabelStyle: GoogleFonts.nunito(fontSize: 11, fontWeight: FontWeight.w600),
      unselectedLabelStyle: GoogleFonts.nunito(fontSize: 11, fontWeight: FontWeight.w400),
    ),
    dividerTheme: const DividerThemeData(
      color: AppColors.divider,
      thickness: 1,
      space: 1,
    ),
  );
}
```

**SPORT ICONS MAP (use this everywhere a sport type needs an icon):**

```dart
// Add this to a new file: lib/core/constants/sport_icons.dart
import 'package:flutter/material.dart';

class SportIcons {
  SportIcons._();

  static IconData getIcon(String lloji) {
    switch (lloji.toLowerCase()) {
      case 'futboll':      return Icons.sports_soccer;
      case 'basketboll':   return Icons.sports_basketball;
      case 'tenis':        return Icons.sports_tennis;
      case 'volejboll':    return Icons.sports_volleyball;
      default:             return Icons.sports;
    }
  }

  static Color getColor(String lloji) {
    switch (lloji.toLowerCase()) {
      case 'futboll':      return const Color(0xFF2E7D32);  // green
      case 'basketboll':   return const Color(0xFFE65100);  // deep orange
      case 'tenis':        return const Color(0xFFF9A825);  // yellow
      case 'volejboll':    return const Color(0xFF1565C0);  // blue
      default:             return const Color(0xFF616161);  // gray
    }
  }
}
```

**ADD THESE PACKAGES to pubspec.yaml (add to the dependencies section):**

The following are new packages required for this rebuild. Add them to pubspec.yaml
and run flutter pub get before writing any screen code.

```yaml
  # Maps (OpenStreetMap — completely free, no API key needed)
  flutter_map: ^6.1.0
  latlong2: ^0.9.0

  # Launch Google Maps for navigation ("Më jep rrugën" button)
  url_launcher: ^6.2.6

  # Smooth page transitions and animations
  page_transition: ^2.1.0

  # Image placeholder and shimmer loading
  shimmer: ^3.0.0

  # Pull to refresh
  easy_refresh: ^3.3.4

  # Bottom sheet with drag handle
  modal_bottom_sheet: ^3.0.0

  # Badge count for notifications
  badges: ^3.1.2

  # Timeago (shows "2 minuta më parë" style timestamps)
  timeago: ^3.6.1

  # Lottie animations (for empty states and success screens)
  lottie: ^3.1.2
```

After adding, run:
```powershell
cd apps/mobile
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

---

## 8. COMPLETE APP MAP — EVERY SCREEN, EVERY PLATFORM

**FLUTTER MOBILE APP — 28 Screens**

The app has 5 main tabs in the bottom navigation bar:
Tab 1: Kryefaqja (Home)
Tab 2: Fushat (Fields)
Tab 3: Komuniteti (Community / Matchmaking)
Tab 4: Ekipet & Turneu (Teams & Tournaments)
Tab 5: Profili (Profile)

The Field Owner has 3 additional screens accessible from the Profile tab.

AUTHENTICATION FLOW (before the main app):
Screen 01: SplashScreen — logo animation, checks token, redirects
Screen 02: OnboardingScreen — 3-slide onboarding for new users
Screen 03: LoginPage — email + password, login button, link to register
Screen 04: RegisterPage — name, email, password, role selector (user or field owner)

MAIN APP — TAB 1 (HOME):
Screen 05: HomePage — hero header with dark gradient, greeting, city selector,
           horizontal sport category chips, "Fushat e Rekomanduara" section,
           "Njoftime Aktive" (latest 2 matchmaking announcements),
           "Eventet e Ardhshme" (next 2 upcoming tournaments)

MAIN APP — TAB 2 (FIELDS):
Screen 06: FieldListPage — search bar, filter chips (city + sport type),
           vertical list of FieldCards with shimmer loading
Screen 07: FieldDetailPage — full-screen header image, field info, amenities chips,
           OpenStreetMap embedded widget, "Më jep rrugën" button,
           availability preview, "Rezervo Tani" CTA button
Screen 08: BookingPage — date strip (horizontal scroll of 14 days),
           time slot grid (available=green, taken=gray, selected=red),
           booking summary card at bottom, "Konfirmo" button
Screen 09: BookingConfirmationPage — success animation (Lottie), booking summary,
           "Shto në Kalendarë" button, "Kthehu në Faqen Kryesore" button
Screen 10: MyBookingsPage — TabBar with "Aktive" and "Historia",
           BookingCard for each booking with status badge and cancel option

MAIN APP — TAB 3 (COMMUNITY / MATCHMAKING):
Screen 11: AnnouncementFeedPage — filter chips (Të gjitha, Kërko Lojtar,
           Kërko Kundërshtar, Kërko Ekip), vertical list of AnnouncementCards,
           FloatingActionButton "+" to create new announcement
Screen 12: AnnouncementDetailPage — poster info, announcement details, response list,
           "Përgjigju" button
Screen 13: CreateAnnouncementPage — form: title, sport type, type selector
           (need player / need opponent / need team), description, date/time,
           location, players needed counter

MAIN APP — TAB 4 (TEAMS & TOURNAMENTS):
Screen 14: TeamsAndTournamentsPage — TabBar with "Ekipet e Mia" and "Turneu & Evente"
Screen 15: MyTeamsPage — list of user's teams (as captain or member),
           "Krijo Ekip të Ri" button
Screen 16: CreateTeamPage — form: team name, sport type, description
Screen 17: TeamDetailPage — team name, sport icon, members list with roles,
           "Ftoni Anëtar" button (captain only), "Regjistrohu për Event" button
Screen 18: EventListPage — filter by sport type and status,
           EventCard for each tournament (dates, field, teams count, status badge)
Screen 19: EventDetailPage — event info, registered teams list, BracketView widget
           (round-robin), "Regjistro Ekipin Tim" button
Screen 20: RegisterTeamForEventPage — select from user's existing teams or create new
Screen 21: BracketPage — full-screen horizontal scrollable bracket view
           with round columns and match cards (team vs team + score if available)
Screen 22: MatchResultPage — update score for a match (organizer only)

MAIN APP — TAB 5 (PROFILE):
Screen 23: ProfilePage — avatar, name, role badge, stats (bookings count,
           teams count, events participated), "Rezervimet e Mia" quick link,
           settings gear icon, logout button
Screen 24: EditProfilePage — edit name, phone number, profile photo (placeholder)

FIELD OWNER ADDITIONAL SCREENS (accessible from Profile tab when role = pronar_fushe):
Screen 25: OwnerDashboardPage — my fields list, today's bookings count, revenue stats
Screen 26: RegisterFieldPage — form: field name, sport type, city, address,
           price per hour, capacity, amenities checkboxes, GPS coordinates picker
Screen 27: OwnerBookingsPage — list of all bookings for owner's fields,
           "Konfirmo" / "Anulo" actions, filter by date

---

**REACT WEB — 12 Pages (apps/web/)**

Page W01: HomePage — hero banner with search bar (desktop: large, mobile: responsive),
          sport category buttons, featured fields grid, upcoming events section
Page W02: FieldsPage — search + filter sidebar, responsive fields grid
Page W03: FieldDetailPage — field photos, info, embedded OpenStreetMap, booking widget
Page W04: BookingPage — calendar + time slot picker + confirmation
Page W05: MyBookingsPage — table view of bookings with status and actions
Page W06: CommunityPage — matchmaking announcements feed + create announcement form
Page W07: EventsPage — tournaments list with filters
Page W08: EventDetailPage — bracket view, teams, results
Page W09: LoginPage — centered card with form
Page W10: RegisterPage — centered card with form and role selector
Page W11: ProfilePage — user info, stats, quick links

---

**REACT ADMIN PANEL — 8 Pages (apps/admin/)**

Page A01: DashboardPage — stats cards (users, fields, bookings, events, announcements),
          weekly bookings bar chart, recent activity feed
Page A02: UsersPage — searchable table, role management, suspend/activate user
Page A03: FieldsPage — all fields table, status override, map preview per field
Page A04: BookingsPage — all bookings table with filters by date, field, status
Page A05: EventsPage — all events table, create/edit events, fixture management
Page A06: AnnouncementsPage — all announcements with moderation (delete inappropriate)
Page A07: TeamsPage — all standalone teams with member counts
Page A08: LoginPage — admin-only login (checks role === admin, rejects otherwise)

---

## 9. USER JOURNEY MAPS — STEP-BY-STEP FOR EVERY USER TYPE

These are the complete paths each user follows. The Flutter router must support
every transition listed here. These are not optional — they are derived directly
from PMP §14 (Decision Trees) and §16 (System Interfaces).

**JOURNEY 1: Regular User books a sports field**

SplashScreen
→ (if no token) LoginPage
→ (after login) HomePage
→ Tab 2 (Fushat) → FieldListPage
→ (taps a field card) → FieldDetailPage
→ (taps "Rezervo Tani") → BookingPage
→ (selects date and time slot) → (taps "Konfirmo") → confirmation dialog
→ (taps "Po, Rezervo") → BookingConfirmationPage (success animation)
→ (taps "Kthehu") → HomePage

**JOURNEY 2: User creates a matchmaking announcement**

HomePage
→ Tab 3 (Komuniteti) → AnnouncementFeedPage
→ (taps FAB "+") → CreateAnnouncementPage
→ (fills form, selects type "Kërko Lojtar", submits) → AnnouncementFeedPage
→ (new announcement appears at top of feed)

**JOURNEY 3: User responds to a matchmaking announcement**

AnnouncementFeedPage
→ (taps an announcement card) → AnnouncementDetailPage
→ (taps "Përgjigju") → small bottom sheet with text input
→ (submits response) → success snackbar → AnnouncementDetailPage (response count updated)

**JOURNEY 4: User creates a team and registers for a tournament**

Tab 4 → TeamsAndTournamentsPage → "Ekipet e Mia" tab
→ (taps "Krijo Ekip të Ri") → CreateTeamPage
→ (fills name + sport, submits) → TeamDetailPage (newly created team)
→ (taps "Regjistrohu për Event") → EventListPage (filtered by same sport type)
→ (taps an event) → EventDetailPage
→ (taps "Regjistro Ekipin Tim") → RegisterTeamForEventPage
→ (selects the newly created team, confirms) → EventDetailPage (team now shown in list)

**JOURNEY 5: Field owner sets up their field and manages bookings**

RegisterPage → (selects role "Pronar Fushe") → LoginPage → HomePage
→ Tab 5 (Profili) → ProfilePage
→ (taps "Paneli Im" — visible only for pronar_fushe role) → OwnerDashboardPage
→ (taps "Regjistro Fushë të Re") → RegisterFieldPage
→ (fills full form including GPS coordinates) → (submits) → OwnerDashboardPage
→ (sees new field in list with "0 rezervime sot")
→ (taps "Menaxho Rezervimet") → OwnerBookingsPage
→ (sees a pending booking, taps "Konfirmo") → booking status changes to konfirmuar
→ success snackbar

**JOURNEY 6: Admin manages the platform (Web Admin Panel)**

apps/admin/ at http://localhost:3002
→ LoginPage (only admin role JWT accepted)
→ DashboardPage (sees all stats)
→ (sees a field with status "joaktiv", navigates to) → FieldsPage
→ (finds field, taps "Aktivizo") → field status changes to aktiv
→ (navigates to) → AnnouncementsPage
→ (sees inappropriate announcement, taps "Fshij") → announcement removed

---
## 10. FLUTTER MOBILE APP — SCREEN-BY-SCREEN BUILD GUIDE (PRIMARY)

> Activate skills before starting: @mobile-app-dev @ui-pro-max
> Build screens in the exact order listed here. Do not skip ahead.
> Every screen that references a BLoC assumes that BLoC already exists.
> If a BLoC does not exist, create it following the pattern in SKILL_FLUTTER.md.

---

### SCREEN 01: SplashScreen

File: lib/presentation/splash/splash_screen.dart

This screen shows the TeFusha logo centered on a white background, runs a short
fade-in animation, checks if a JWT token exists in flutter_secure_storage, and
then navigates to either /home or /auth/login.

```dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../data/datasources/local/token_storage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeIn);
    _ctrl.forward();
    _navigate();
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(milliseconds: 2000));
    if (!mounted) return;
    final loggedIn = await TokenStorage.isLoggedIn();
    if (mounted) {
      context.go(loggedIn ? '/home' : '/onboarding');
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FadeTransition(
        opacity: _fade,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo — red circle with a soccer ball icon
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.3),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Icon(Icons.sports_soccer, color: Colors.white, size: 48),
              ),
              const SizedBox(height: 20),
              Text(
                'TeFusha',
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Rezervo fushën tënde sportive',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

---

### SCREEN 02: OnboardingScreen

File: lib/presentation/onboarding/onboarding_screen.dart

Three slides with a PageView. Each slide has a large icon, a title, and a subtitle.
After the last slide, a "Fillo" button navigates to /auth/login.
A "Kalo" skip button on slides 1 and 2 also goes to /auth/login.
After completing onboarding once, save a flag so it does not show again.

Slide 1: Icon = search, Title = "Gjej Fushën Perfekte",
         Subtitle = "Kërko fushat sportive sipas qytetit, llojit dhe çmimit."
Slide 2: Icon = calendar_today, Title = "Rezervo Online",
         Subtitle = "Zgjidh orarin dhe rezervo fushën tënde në sekonda."
Slide 3: Icon = emoji_events, Title = "Lëro & Garoje",
         Subtitle = "Regjistrohu në turneu, gjej lojtar ose kundërshtar."

The background of each slide uses the hero gradient (AppColors.heroStart to heroEnd)
in the top 40% and white in the bottom 60%. The icon and title are in the top section
(white text), the subtitle and dots indicator are in the bottom white section.

---

### SCREEN 03: LoginPage

File: lib/presentation/auth/login_page.dart

Layout: White background. Top 30% has the hero gradient with centered "TeFusha" title
and subtitle "Hyr në llogarinë tënde". Bottom 70% has the form on a white card with
rounded top corners (24px) that overlaps the gradient slightly.

Form fields (from top to bottom):
1. Email input — keyboard type emailAddress, prefix icon: email
2. Password input — obscureText toggle with visibility icon suffix
3. "Hyr" ElevatedButton (full width, primary red)
4. Divider with "ose" text
5. "Regjistrohu" TextButton that navigates to /auth/register
6. Error message shown in a red Container below the button if login fails

Auth BLoC events: LoginSubmitted(email, password)
Auth BLoC states: AuthLoading (shows CircularProgressIndicator in the button),
AuthAuthenticated (GoRouter navigates to /home), AuthError (shows error message)

---

### SCREEN 04: RegisterPage

File: lib/presentation/auth/register_page.dart

Same layout as LoginPage. Form fields:
1. Full name input — prefix icon: person
2. Email input — prefix icon: email
3. Password input — obscureText toggle
4. Role selector — two tappable cards side by side:
   Left card: "Lojtar" with sports icon. Right card: "Pronar Fushe" with storefront icon.
   Selected card has a primary red border and a checkmark badge.
5. "Regjistrohu" ElevatedButton (full width)
6. "Ke llogari? Hyr" TextButton → /auth/login

---

### SCREEN 05: HomePage

File: lib/presentation/home/home_page.dart

This is the most important screen. It is a StatefulWidget with a BottomNavigationBar.
The body switches between the 5 tab pages.

The bottom nav bar has these 5 items:
Index 0: icon = home_outlined / home (selected), label = "Kryefaqja"
Index 1: icon = stadium_outlined / stadium (selected), label = "Fushat"
Index 2: icon = groups_outlined / groups (selected), label = "Komuniteti"
Index 3: icon = emoji_events_outlined / emoji_events (selected), label = "Turneu"
Index 4: icon = person_outlined / person (selected), label = "Profili"

The home tab (index 0) content is built inline in home_page.dart. It has:

Section A — HERO HEADER (dark gradient):
A Container with a LinearGradient (heroStart to heroEnd), height 220px.
Inside it (from top): a Row with greeting text on left ("Mirëmëngjes, [Name]! 👋")
and a notification bell icon (with red badge if notifications > 0) on the right.
Below: a Row with city selector (dropdown with Albanian cities) and a search bar.
The search bar navigates to FieldListPage with the search query when submitted.

Section B — SPORT CATEGORY CHIPS:
A horizontal SingleChildScrollView with FilterChips for:
"Të gjitha", "Futboll", "Basketboll", "Tenis", "Volejboll"
When a chip is selected, the field list below filters by that sport type.

Section C — FUSHAT E REKOMANDUARA (Recommended Fields):
Title row "Fushat e Rekomanduara" with "Shiko të gjitha →" TextButton.
A horizontal SingleChildScrollView with FeaturedFieldCards (smaller than the
full FieldCard — 200px wide, 150px tall image). Each card shows: image, name, city,
price, sport icon.

Section D — NJOFTIME AKTIVE (Active Matchmaking):
Title row "Njoftime Aktive" with "Shiko të gjitha →" TextButton.
Shows 2 AnnouncementCards (compact size). Each card shows: poster name,
announcement type badge, sport icon, title, time ago.

Section E — EVENTET E ARDHSHME (Upcoming Tournaments):
Title row "Eventet e Ardhshme" with "Shiko të gjitha →" TextButton.
Shows 2 EventCards (compact). Each shows: event name, field name, date, teams count.

Use BlocBuilder for each section. Show shimmer loading placeholders while data loads.
Show an empty state illustration (Lottie animation) if data is empty.

---

### SCREEN 06: FieldListPage

File: lib/presentation/fields/field_list_page.dart

AppBar: white background, "Fushat Sportive" title in black, search icon on right.

Body layout from top to bottom:
1. Search bar — full width with gray background, rounded 20px,
   placeholder "Kërko sipas emrit ose qytetit..."
2. Horizontal filter row — a SingleChildScrollView with FilterChips:
   city chips (Tiranë, Durrës, Vlorë, Shkodër, Elbasan) and
   a "Filtro ▼" button that opens a bottom sheet with full filter options
3. Result count text: "23 fusha u gjetën" (updates as filters change)
4. ListView.builder with FieldCards, each separated by 12px SizedBox

FieldCard widget spec (lib/presentation/fields/widgets/field_card.dart):
- White card with 16px border radius and the standard box shadow
- ClipRRect image (height 160px, full width, rounded top corners)
- If no image URL: a gradient Container with the sport icon centered
- Below image: Padding(16px) containing:
  Row 1: Field name (titleSmall, bold, flex:1) | Price badge (red pill: "1200 L/orë")
  Row 2: location icon + city text | sport icon + sport type (both in textSecondary)
  Row 3: capacity icon + capacity | a "Rezervo" outlined button (small, right-aligned)
- Tap anywhere on card → FieldDetailPage(fieldId: field.id)

Shimmer loading: Show 5 FieldCardSkeleton widgets while loading.
FieldCardSkeleton uses Shimmer.fromColors with baseColor: Color(0xFFE0E0E0)
and highlightColor: Color(0xFFF5F5F5).

---

### SCREEN 07: FieldDetailPage

File: lib/presentation/fields/field_detail_page.dart

Use a CustomScrollView with SliverAppBar for the header image effect.

SliverAppBar:
- expandedHeight: 260px
- pinned: true (so the title stays when scrolled)
- flexibleSpace: FlexibleSpaceBar with the field image as background
  If no image: gradient Container with the sport icon centered (large, white)
- Leading: back arrow button with white background circle
- Actions: share icon button

SliverList content (scroll below the image):

Section 1 — FIELD INFO CARD (white card, padding 16px):
Row: Field name (titleLarge) | sport type chip (colored by AppColors)
Row: location_on icon + full address text (secondary color)
Divider
Row with 3 equal stats: Price | Capacity | Status badge
If status = joaktiv: show a red banner "Kjo fushë nuk është aktive aktualisht"

Section 2 — PAJISJET (Amenities) — if field.pajisjet is not null:
"Pajisjet dhe Lehtësirat" heading
Horizontal Wrap of chips for each amenity from the pajisjet text field.
Parse the text by commas and render each as an outlined chip with a check icon.

Section 3 — VENDNDODHJA (Location — OpenStreetMap):
"Vendndodhja" heading
SizedBox(height: 200) containing the OpenStreetMap widget.
IMPORTANT: Only render the map if field.lat and field.lng are not null.
If coordinates are null: show a gray Container with "Vendndodhja nuk është e disponueshme".
Below the map: Row with two buttons:
Left button: OutlinedButton with map icon "Harta e plotë" (expands map to full screen)
Right button: ElevatedButton with directions icon "Më jep rrugën" (launches Google Maps)

Section 4 — DISPONUESHMËRIA (Availability preview):
"Disponueshmëria e Sotme" heading
Show today's available time slots as a Wrap of small green chips.
If all slots are taken: show "Sot nuk ka orare të lira"
"Shiko kalendarë të plotë" TextButton → BookingPage

BOTTOM FLOATING BUTTON:
A Container at the bottom of the screen (not inside the scroll) with white background
and a top shadow, containing a full-width ElevatedButton "Rezervo Tani — [price] L/orë".
This button navigates to BookingPage(fieldId: field.id).

---

### MAP WIDGET IMPLEMENTATION

File: lib/presentation/fields/widgets/field_map_widget.dart

This widget uses the flutter_map package with OpenStreetMap tiles.
It is completely free. No API key required. No Google Cloud account needed.

```dart
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/constants/app_colors.dart';

class FieldMapWidget extends StatelessWidget {
  final double lat;
  final double lng;
  final String fieldName;

  const FieldMapWidget({
    super.key,
    required this.lat,
    required this.lng,
    required this.fieldName,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        height: 200,
        child: FlutterMap(
          options: MapOptions(
            initialCenter: LatLng(lat, lng),
            initialZoom: 15.0,
            interactionOptions: const InteractionOptions(
              flags: InteractiveFlag.none, // disable all interaction on the small preview
            ),
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'al.tefusha',
            ),
            MarkerLayer(
              markers: [
                Marker(
                  point: LatLng(lat, lng),
                  width: 40,
                  height: 40,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.4),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.sports_soccer, color: Colors.white, size: 20),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
```

**"MË JEP RRUGËN" BUTTON IMPLEMENTATION:**

This button opens Google Maps on the user's phone with a pre-set destination
so the user gets turn-by-turn navigation. It is completely free.
No API key. Uses the url_launcher package.

```dart
// Place this function in the FieldDetailPage state class

Future<void> _openGoogleMapsNavigation(double lat, double lng) async {
  // This URL scheme opens Google Maps directly with destination set
  // It works on both Android (Google Maps) and iOS (Apple Maps as fallback)
  final googleMapsUrl = Uri.parse(
    'https://www.google.com/maps/dir/?api=1&destination=$lat,$lng&travelmode=driving',
  );

  // Try Google Maps first
  if (await canLaunchUrl(googleMapsUrl)) {
    await launchUrl(googleMapsUrl, mode: LaunchMode.externalApplication);
  } else {
    // Fallback: open coordinates in any available map app
    final fallbackUrl = Uri.parse('geo:$lat,$lng?q=$lat,$lng');
    if (await canLaunchUrl(fallbackUrl)) {
      await launchUrl(fallbackUrl);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Nuk u gjet asnjë aplikacion harte')),
        );
      }
    }
  }
}

// The button widget:
ElevatedButton.icon(
  onPressed: () => _openGoogleMapsNavigation(field.lat!, field.lng!),
  icon: const Icon(Icons.directions),
  label: const Text('Më jep rrugën'),
  style: ElevatedButton.styleFrom(
    backgroundColor: AppColors.secondary,
    foregroundColor: Colors.white,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  ),
),
```

Also add this to AndroidManifest.xml in apps/mobile/android/app/src/main/ inside
the <queries> element (add before </manifest>):
```xml
<queries>
  <intent>
    <action android:name="android.intent.action.VIEW" />
    <data android:scheme="https" />
  </intent>
  <intent>
    <action android:name="android.intent.action.VIEW" />
    <data android:scheme="geo" />
  </intent>
</queries>
```

---

### SCREEN 08: BookingPage

File: lib/presentation/booking/booking_page.dart

AppBar: "Rezervo Fushën" title, back arrow.

Body (SingleChildScrollView):

Section 1 — FIELD SUMMARY (top card):
Small card showing field name, sport type, and price per hour.
This reminds the user what they are booking.

Section 2 — ZGJIDH DATËN (Date Picker):
"Zgjidh Datën" label (titleSmall)
A horizontal SingleChildScrollView showing 14 days starting from today.
Each day is a DayChip: a Column with abbreviated day name (Hën, Mar, etc.) above
and date number below. Selected day has red background with white text.
Tapping a day loads availability for that day from the API.

Section 3 — ORARET E LIRA (Time Slots):
"Oraret e Disponueshme" label with the selected date shown
A GridView.builder with 2 columns showing time slots from 08:00 to 21:00.
Each slot is a GestureDetector wrapping a Container:
- Available slot: white background, green border, dark text (e.g., "09:00 - 10:00")
- Taken slot: light gray background, no border, gray text, strikethrough
- Selected slot: primary red background, white text, checkmark icon

Loading state: show shimmer skeleton grid.

Section 4 — DETAJET E REZERVIMIT (Booking Summary):
Only visible once a time slot is selected.
A light gray card showing:
Row: "Fusha:" — field name
Row: "Data:" — selected date in format "E Hënë, 5 Maj 2026"
Row: "Ora:" — selected slot "09:00 - 10:00"
Row: "Çmimi total:" — calculated price in bold red
Divider
"Konfirmo Rezervimin" full-width ElevatedButton (red)

Tapping Konfirmo shows an AlertDialog:
Title: "Konfirmo Rezervimin"
Content: booking summary in small text
Buttons: "Anulo" (cancel, no action) | "Po, Rezervo" (calls CreateBookingEvent)

---

### SCREEN 09: BookingConfirmationPage

File: lib/presentation/booking/booking_confirmation_page.dart

White background. No AppBar (full-screen experience).

Center column:
1. Lottie animation — a green checkmark success animation (use free Lottie from
   lottiefiles.com/animations/success-checkmark or any free success animation)
   Width: 200px, height: 200px, repeat: false (plays once)
2. "Rezervimi u Krye!" in titleLarge, green color
3. "Rezervimi juaj është konfirmuar." in bodyMedium, secondary text color
4. Booking summary card (white card with shadow):
   field name, date, time, total price
5. SizedBox(height: 32)
6. ElevatedButton "Kthehu në Faqen Kryesore" — navigates to /home (replaces entire stack)

---

### SCREEN 10: MyBookingsPage

File: lib/presentation/booking/my_bookings_page.dart

AppBar: "Rezervimet e Mia" title.

TabBar with 2 tabs: "Aktive" | "Historia"

Active tab shows: bookings with status ne_pritje or konfirmuar.
History tab shows: bookings with status anuluar or past dates.

Each BookingCard shows:
- Left color accent strip (yellow=pending, green=confirmed, red=cancelled)
- Field name in bold, sport type chip
- Date and time in secondary color
- "Konfirmuar" / "Në Pritje" / "Anuluar" status badge (pill shape)
- If status is ne_pritje: small "Anulo" TextButton in red
- Tap card → FieldDetailPage (so user can rebook or see field details)

Empty state: Lottie animation with "Nuk keni rezervime aktive" text and
"Rezervo Tani" button that navigates to FieldListPage.

---

### SCREEN 11: AnnouncementFeedPage

File: lib/presentation/community/announcement_feed_page.dart

AppBar: "Komuniteti" title, no back button (this is a main tab).

Body:
FilterChip row (horizontal scroll):
"Të gjitha" | "Kërko Lojtar" | "Kërko Kundërshtar" | "Kërko Ekip"

ListView of AnnouncementCards:

AnnouncementCard widget spec (lib/presentation/community/widgets/announcement_card.dart):
White card with 16px radius and standard shadow.
Row at top: User avatar circle (first letter of name on colored background) |
            user name + time ago (using timeago package) |
            announcement type badge on right
Below: titull in titleSmall (bold)
       pershkrim in bodyMedium (max 2 lines, overflow ellipsis)
       Row: sport icon chip | location chip (if available) | players needed count
Divider
Row at bottom: "Përgjigjet (N)" in gray | "Përgjigju" TextButton on right

FloatingActionButton (+ icon) positioned at bottom right.
Tapping FAB → CreateAnnouncementPage.

---

### SCREEN 12: CreateAnnouncementPage

File: lib/presentation/community/create_announcement_page.dart

AppBar: "Njoftim i Ri" title, back button.

Form (SingleChildScrollView):
1. "Çfarë kërkon?" — TypeSelector: 3 tappable cards in a row:
   "Kërko Lojtar" (blue), "Kërko Kundërshtar" (pink), "Kërko Ekip" (purple).
   Selected card has a colored border and filled background.
2. Titull input (label: "Titulli, p.sh. Na duhet 1 lojtar për kalçeto sot")
3. Sport type dropdown (same 5 options as field filtering)
4. Description input — multiline, 4 rows
5. Location input (optional) — label: "Vendndodhja (opsionale)"
6. Date and time picker row (optional) — "Data dhe Ora e Lojës (opsionale)"
   Opens a DateTimePicker bottom sheet when tapped
7. Players needed counter (only shown if type = kerko_lojtar):
   A Row with minus button, count number, plus button. Range 1-10.
8. "Posto Njoftimin" full-width ElevatedButton

Submit calls CreateAnnouncementEvent on AnnouncementBloc.
On success: pop page and show SnackBar "Njoftimi u postua me sukses!"

---

### SCREEN 15: MyTeamsPage (inside Teams & Tournaments tab)

File: lib/presentation/teams/my_teams_page.dart

Shows a list of StandaloneTeams where the user is captain or member.
Each TeamCard shows: team name, sport icon + type, member count, captain name,
"Kapitan" badge if user is captain of this team.

Empty state: "Nuk jeni anëtar i asnjë ekipi" with
"Krijo Ekipin Tënd" ElevatedButton.

---

### SCREEN 17: TeamDetailPage

File: lib/presentation/teams/team_detail_page.dart

AppBar: team name as title, edit icon (only visible for captain).

Hero section: Large sport icon with team name and sport type.

Members list:
Each member row: avatar circle | name | role badge (Kapitan / Anëtar) | remove button (captain only)

Action buttons at bottom:
"Ftoni Anëtar" button (ElevatedButton, captain only)
"Regjistrohu për Event" button (OutlinedButton, all members)

---

### SCREEN 19: EventDetailPage

File: lib/presentation/events/event_detail_page.dart

AppBar: event name as title.

Sections:
1. Event info card: field name, dates, sport type, status badge, organizer
2. "Ekipet e Regjistruara" (Registered Teams) section:
   ListTile for each team with rank number, team name, team member count
3. "Tabela / Fixtures" section:
   TabBar with tab labels per round ("Raundi 1", "Raundi 2", etc.)
   Each tab shows the matches for that round as MatchCards
   MatchCard: home team name | score (or "vs" if not played) | away team name
4. Bottom button: "Regjistro Ekipin Tim" (only if event.statusi = planifikuar
   and user has a team of the same sport type)

---

### SCREEN 25: OwnerDashboardPage

File: lib/presentation/owner/owner_dashboard_page.dart

AppBar: "Paneli Im" title.

Stats row at top: 3 equal cards
"Fushat" count | "Rezervime Sot" count | "Rezervime Muajore" count

"Fushat e Mia" section:
List of fields owned by this user. Each FieldOwnerCard shows:
Field name | status badge | "Rezervimet" count | edit button | bookings button.
"Regjistro Fushë të Re" button at bottom of list (or centered if list is empty).

---

### SCREEN 26: RegisterFieldPage

File: lib/presentation/owner/register_field_page.dart

AppBar: "Regjistro Fushë" title.

Stepper widget (3 steps, horizontal at top):
Step 1 — INFORMACIONI BAZË:
  Field name input
  Sport type dropdown
  City dropdown
  Full address input
  Price per hour input (number keyboard)
  Capacity input (number keyboard)

Step 2 — PAJISJET:
  Checkboxes for common amenities:
  "Drita artificiale" | "Dhomat e zhveshjes" | "Parkim" | "Wi-Fi" |
  "Fryerje topi" | "Tualete" | "Restorant/Bar"
  Optional text input for additional amenities

Step 3 — VENDNDODHJA:
  Lat/Lng text inputs (labeled "Gjerësia Gjeografike" and "Gjatësia Gjeografike")
  Helper text: "Hapni Google Maps, shtypni dhe mbani mbi vendndodhjen tuaj
               dhe kopjoni koordinatat."
  A small preview of the map if both lat and lng are filled (FieldMapWidget)

"Kalo" button advances to next step. "Prapa" goes back.
"Regjistro Fushën" on step 3 submits the form.

---

## 11. WEB PLATFORM — SCREEN-BY-SCREEN BUILD GUIDE

> Activate skills before starting: @ui-pro-max
> The web platform uses the same color palette and typography hierarchy as Flutter.
> All pages are responsive (mobile-first, with breakpoints at 768px and 1200px).
> All API calls use the Axios client defined in SKILL_WEB.md.

---

### PAGE W01: Web HomePage

File: apps/web/src/pages/HomePage.tsx

Desktop layout (max-width: 1200px, centered):

Hero section: a div with heroStart-to-heroEnd gradient background, height 480px.
  Inside: centered text "Rezervo Fushën Tënde Sportive" (large white heading)
  Subtitle: "Kërko, rezervo dhe lëro. Mbi 5 fusha sportive në të gjithë Shqipërinë."
  Search bar (white, full-width on mobile, 600px on desktop) with city dropdown
  and sport type dropdown. On submit: navigates to /fields with query params.
  "Kërko" button in primary red.

Sport categories row below hero:
5 clickable cards, each with sport icon, sport name, fields count.
On click: navigates to /fields?lloji=[sport]

Featured Fields grid: 3 columns on desktop, 1 on mobile.
Each card uses the same visual spec as the Flutter FieldCard.

Events section: 2 upcoming event cards. Each shows name, date, field, teams.

Community teaser section: 3 latest announcements as compact list items.
"Shiko të gjitha njoftimet" link → /community

---

### PAGE W03: FieldDetailPage (Web)

File: apps/web/src/pages/FieldDetailPage.tsx

Two-column layout on desktop: left column (60%) for info + map, right (40%) for booking widget.

Left column:
- Hero image (or sport gradient placeholder), 350px height
- Field info section (same content as Flutter FieldDetailPage)
- OpenStreetMap embed: use a simple iframe with OpenStreetMap embed URL
  Format: https://www.openstreetmap.org/export/embed.html?bbox=[lng-0.01]%2C[lat-0.01]%2C[lng+0.01]%2C[lat+0.01]&layer=mapnik&marker=[lat]%2C[lng]
  Set width 100%, height 300px, border 0, border-radius 12px
- "Hap në Google Maps" link button below the map iframe

Right column (sticky on scroll):
- "Rezervo Tani" card with white background and border
- Date picker (use a simple HTML date input styled consistently)
- Time slot grid (same logic as Flutter, fetched from /api/fields/:id/availability)
- Price summary and confirm button

On mobile: single column, map above booking form.

---

### PAGE W06: CommunityPage (Web)

File: apps/web/src/pages/CommunityPage.tsx

Two-column layout on desktop: left = announcement feed, right = create announcement form.

Left column: Filter tabs + AnnouncementCard list (same data, styled as web cards).
Right column: "Posto Njoftim" card with the create form inline.

On mobile: form collapses behind a "Posto Njoftim" button that opens a modal.

---

## 12. ADMIN PANEL — SCREEN-BY-SCREEN BUILD GUIDE

> Activate skills before starting: @ui-pro-max
> The admin panel uses MUI (Material UI) components for faster development.
> All pages require admin role — redirect to /login if role !== admin.

---

### PAGE A01: DashboardPage (Admin)

File: apps/admin/src/pages/DashboardPage.tsx

Layout: Left sidebar (240px, dark navy #1A1A2E) + main content area.

Sidebar items:
Dashboard (home icon) | Përdoruesit (people icon) | Fushat (stadium icon) |
Rezervimet (calendar icon) | Eventet (trophy icon) |
Njoftime (campaign icon) | Ekipet (groups icon) | Dil (logout icon)

Stats cards row (4 cards):
Pérdorues Total | Fusha Aktive | Rezervime Sot | Njoftime Aktive

Weekly bookings bar chart (Recharts BarChart, same as existing but with proper
color from design system: bars should be AppColors.primary #E8002D)

Recent activity table: last 10 bookings with user name, field name, date, status.

---

### PAGE A06: AnnouncementsPage (Admin)

File: apps/admin/src/pages/AnnouncementsPage.tsx

This page is new. It shows all announcements for moderation.

DataGrid table columns:
ID | Poster | Tipi (badge) | Titulli | Sporti | Data | Statusi | Veprimet

Veprimet column has two icon buttons per row:
- Eye icon: view full announcement text in a dialog
- Delete icon (red): calls DELETE /api/admin/announcements/:id with confirmation dialog

Filter toolbar above table:
Search input | Type filter dropdown | Sport filter dropdown

---

## 13. COMPLETE GOROUTER CONFIGURATION

Replace the entire app_router.dart with this final version that covers all 28 screens:

```dart
import 'package:go_router/go_router.dart';
import '../../data/datasources/local/token_storage.dart';
// Import all page files here

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
    GoRoute(path: '/booking/success', builder: (_, __) => const BookingConfirmationPage()),
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
      builder: (_, s) => TeamDetailPage(teamId: int.parse(s.pathParameters['id']!)),
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

    // Profile
    GoRoute(path: '/profile',        builder: (_, __) => const ProfilePage()),
    GoRoute(path: '/profile/edit',   builder: (_, __) => const EditProfilePage()),

    // Field Owner
    GoRoute(path: '/owner',          builder: (_, __) => const OwnerDashboardPage()),
    GoRoute(path: '/owner/fields/new', builder: (_, __) => const RegisterFieldPage()),
    GoRoute(path: '/owner/bookings', builder: (_, __) => const OwnerBookingsPage()),
  ],
);
```

---

## 14. COMMON ERRORS & FIXES (GUI-SPECIFIC)

These are errors specific to the new GUI work. General errors are covered in SKILL_FLUTTER.md.

### Error: flutter_map tiles not loading, white tiles show
Cause: The userAgentPackageName does not match your app identifier.
Fix: Ensure userAgentPackageName in TileLayer matches the package name in pubspec.yaml.
Also check your internet permission in AndroidManifest.xml:
Add `<uses-permission android:name="android.permission.INTERNET" />` before `<application>`

### Error: url_launcher "Could not launch" even with valid URL
Cause: Missing <queries> element in AndroidManifest.xml on Android 11+.
Fix: Add the <queries> block from the map section above to AndroidManifest.xml.
Also make sure url_launcher version is ^6.2.6 or higher.

### Error: Lottie animation not playing
Cause: The .json file is not in the assets folder or not declared in pubspec.yaml.
Fix: Create assets/animations/ folder. Download any free success animation from
lottiefiles.com and save as success.json. Then in pubspec.yaml add:
```yaml
  assets:
    - assets/animations/
```
Then use: Lottie.asset('assets/animations/success.json')

### Error: GoRouter redirect causes infinite loop with splash screen
Cause: The /splash route is not excluded from the auth check.
Fix: The router config above already handles this. Make sure /splash is in authRoutes list.

### Error: "setState called on disposed widget" in SplashScreen
Cause: The _navigate() future completes after the widget is disposed.
Fix: Add `if (!mounted) return;` check before every context.go() call inside async functions.

### Error: BottomNavigationBar does not preserve state when switching tabs
Cause: Flutter rebuilds the entire tab content on each switch by default.
Fix: Wrap each tab body in AutomaticKeepAliveClientMixin or use IndexedStack:
Replace the switch statement in HomePage._buildBody with:
```dart
IndexedStack(
  index: _idx,
  children: const [
    HomeTabContent(),
    FieldListPage(),
    AnnouncementFeedPage(),
    TeamsAndTournamentsPage(),
    ProfilePage(),
  ],
)
```

### Error: shimmer package "Shimmer.fromColors" not found
Cause: The import path changed between versions.
Fix: Import as: `import 'package:shimmer/shimmer.dart';`

### Error: build_runner fails after adding new models
Run in order (do not skip any step):
```powershell
flutter clean
flutter pub get
flutter pub run build_runner clean
flutter pub run build_runner build --delete-conflicting-outputs
```

### Error: FilterChip not updating visually when selected
Cause: FilterChip requires a StatefulWidget or BLoC to manage the selected state.
Fix: Manage selectedSports as a Set<String> in the parent StatefulWidget and call setState.
Never try to manage chip selection purely from a BLoC state — keep it local UI state.

### Error: OpenStreetMap shows "Loading" text but never loads on Android emulator
Cause: The emulator does not have internet access or certificate issues.
Fix 1: Check internet permission in manifest.
Fix 2: Test on a real device instead of the emulator for map testing.
Fix 3: If still failing, add `nonRotatedChildren` to FlutterMap and try again.

---

## 15. TESTING CHECKLIST — PLATFORM BY PLATFORM

Complete these in order. Do not move to the next group until the current one is all checked.

**GROUP 1: Database and Backend**
Before any frontend work on new features, verify:
- [ ] npx prisma migrate dev ran without errors
- [ ] npx prisma studio shows announcements, announcement_responses,
      standalone_teams, standalone_team_members tables
- [ ] POST /api/announcements creates a record (test with Invoke-RestMethod)
- [ ] GET /api/announcements returns array
- [ ] POST /api/announcements/:id/respond creates a response
- [ ] POST /api/teams creates a standalone team
- [ ] GET /api/teams/mine returns user's teams

**GROUP 2: Flutter Core**
- [ ] flutter analyze returns 0 errors after all new files are added
- [ ] SplashScreen navigates to /onboarding for new users, /home for returning users
- [ ] Onboarding completes and navigates to /auth/login
- [ ] Login and Register work and store tokens correctly
- [ ] Bottom navigation switches between all 5 tabs without errors
- [ ] BottomNavigationBar preserves scroll state when switching tabs (IndexedStack)

**GROUP 3: Flutter Fields Module**
- [ ] FieldListPage loads field cards with Nunito font and correct colors
- [ ] Shimmer loading shows while fields load
- [ ] Filtering by city and sport type works
- [ ] FieldDetailPage shows OpenStreetMap for fields that have lat/lng
- [ ] "Më jep rrugën" button opens Google Maps on Android emulator
- [ ] BookingPage shows correct time slots (green/gray/red)
- [ ] Cannot book a taken slot (grey slot tap does nothing)
- [ ] Booking confirmation screen shows Lottie animation
- [ ] MyBookingsPage shows active and history tabs with correct data

**GROUP 4: Flutter Community Module**
- [ ] AnnouncementFeedPage loads and displays announcement cards
- [ ] Filter chips filter announcements by type correctly
- [ ] FAB navigates to CreateAnnouncementPage
- [ ] Form validation works (empty title shows error, empty type shows error)
- [ ] Creating announcement adds it to the feed
- [ ] Tapping an announcement opens AnnouncementDetailPage
- [ ] Responding to an announcement works and updates response count

**GROUP 5: Flutter Teams & Tournaments Module**
- [ ] MyTeamsPage shows empty state for new users
- [ ] CreateTeamPage creates a team and navigates back to MyTeamsPage
- [ ] TeamDetailPage shows members with correct role badges
- [ ] EventListPage loads tournaments from backend
- [ ] EventDetailPage shows bracket widget with round tabs
- [ ] RegisterTeamForEventPage allows selecting an existing team

**GROUP 6: Flutter Field Owner Module**
- [ ] When logged in as pronar_fushe: Profile tab shows "Paneli Im" button
- [ ] OwnerDashboardPage loads with stats
- [ ] RegisterFieldPage stepper works (next/back between 3 steps)
- [ ] Submitting RegisterFieldPage creates a new field visible in OwnerDashboardPage
- [ ] OwnerBookingsPage shows incoming bookings with confirm/cancel actions

**GROUP 7: Web Platform**
- [ ] npm run build succeeds with no TypeScript errors
- [ ] HomePage hero section renders with dark gradient
- [ ] Field search on HomePage navigates to /fields with correct query params
- [ ] FieldDetailPage shows OpenStreetMap iframe
- [ ] "Hap në Google Maps" link opens correctly in new browser tab
- [ ] Booking flow works end-to-end on web
- [ ] Community page shows and creates announcements

**GROUP 8: Admin Panel**
- [ ] Admin login rejects non-admin users
- [ ] Dashboard stats load from /api/admin/stats
- [ ] AnnouncementsPage (new) loads all announcements
- [ ] Delete announcement works with confirmation dialog
- [ ] All existing pages (Users, Fields, Bookings, Events) still work after new additions

---

## 16. DEPLOYMENT ORDER

Follow this exact order when deploying to production on Vercel.

Step 1: Run final database migration on Supabase (production DB):
Set DATABASE_URL in your .env to the Supabase production URL, then:
```powershell
cd backend
npx prisma migrate deploy
```
This runs all pending migrations including the new announcements and teams tables.

Step 2: Deploy backend to Vercel:
```powershell
cd backend
vercel --prod
```
Note the production URL (e.g., https://tefusha-api.vercel.app).
Set all environment variables in the Vercel dashboard:
DATABASE_URL, JWT_SECRET, JWT_EXPIRY, REFRESH_TOKEN_EXPIRY, ALLOWED_ORIGINS, PORT=4000

Step 3: Deploy web to Vercel:
Update apps/web/.env.production: REACT_APP_API_URL=https://tefusha-api.vercel.app
```powershell
cd apps/web
vercel --prod
```

Step 4: Deploy admin to Vercel:
Update apps/admin/.env.production: REACT_APP_API_URL=https://tefusha-api.vercel.app
```powershell
cd apps/admin
vercel --prod
```

Step 5: Update Flutter app with production URL:
In apps/mobile/lib/core/constants/api_constants.dart, change:
```dart
static const String baseUrl = 'https://tefusha-api.vercel.app';
```
Then build the release APK:
```powershell
cd apps/mobile
flutter build apk --release
flutter build appbundle --release
```
The .apk file is at: build/app/outputs/flutter-apk/app-release.apk
The .aab file is at: build/app/outputs/bundle/release/app-release.aab

---

## FINAL PRE-LAUNCH CHECKLIST

These must all be done before the pilot phase (Maj 2026 — PMP Phase A20).

**Platform delivery:**
- [ ] Flutter APK builds without errors and installs on a real Android device
- [ ] Web platform is live on Vercel
- [ ] Admin panel is live on Vercel (different subdomain from web)
- [ ] All 3 platforms connect to the same production backend
- [ ] Backend is live on Vercel with SSL (HTTPS active automatically on Vercel)

**Feature delivery:**
- [ ] All 5 PMP core modules work: Listing, Search, Booking, Events, Admin Panel
- [ ] Map integration works (OpenStreetMap in app + Google Maps navigation)
- [ ] Matchmaking announcements work on Flutter and Web
- [ ] Independent teams work on Flutter
- [ ] Tournament brackets generate correctly
- [ ] Field owner can register and manage their field

**Quality:**
- [ ] All UI text is in Albanian (no English strings visible to users)
- [ ] All screens use Nunito font (no default system font visible)
- [ ] All screens use the correct color palette (no hardcoded hex in widget files)
- [ ] No console errors or flutter analyze warnings in the final build

**Documentation (PMP §12.3):**
- [ ] docs/user-guide.md written by Alban Cela
- [ ] docs/admin-guide.md written by Alban Cela
- [ ] docs/test-report.md written by Alban Cela with pilot results

**Pilot targets (PMP §12.1):**
- [ ] Minimum 5 real sports fields registered and active
- [ ] Minimum 50 registered users reached
- [ ] No KRITIK priority bugs open at launch time

---

*TeFusha SKILL_GUI_FINAL.md — Generated for Gemini CLI execution.*
*Covers: Flutter 28 screens + React Web 12 pages + React Admin 8 pages.*
*Design: Option 3 Multi-Sports Field Booking — Albanian red, Nunito, light surfaces.*
*New features: OpenStreetMap + Google Maps navigation, Matchmaking/Announcements,*
*Standalone Teams, full Tournament bracket module, Field Owner Dashboard.*
*Skills to activate: @mobile-app-dev @ui-pro-max*
