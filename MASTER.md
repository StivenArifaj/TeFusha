# TeFusha — MASTER DEVELOPMENT GUIDE FOR GEMINI CLI
> READ THIS FIRST. This is the entry point. It tells you the development order,
> which skill file to load for each platform, and what "done" means before moving on.

---

## PROJECT AT A GLANCE

**TeFusha** = Albanian sports field booking platform
**3 platforms to build** (in this exact order):
1. 🟥 **Backend** (Node.js + Express + PostgreSQL + Prisma)
2. 🟦 **Flutter Mobile App** (iOS + Android)
3. 🟩 **React.js Web + Admin Panel**

**PMP Critical Path**: A3 (UI/UX) → A12 (Booking) → A19 (Testing) → A20 (Pilot) → Launch

---

## DEVELOPMENT ORDER — NEVER SKIP OR REORDER

```
PHASE 1: BACKEND (SKILL_BACKEND.md)
  ↓ All API tests pass
PHASE 2: FLUTTER APP (SKILL_FLUTTER.md)
  ↓ All feature tests pass + APK builds
PHASE 3: WEB + ADMIN (SKILL_WEB.md)
  ↓ All pages work + builds succeed
PHASE 4: INTEGRATION TEST (all 3 platforms talking to the same backend)
PHASE 5: PILOT + DEPLOY
```

**Why this order?** The backend is the single source of truth. Flutter and Web are both clients of the backend. If the backend is broken, nothing else works. Build and fully test it first.

---

## HOW TO USE THE SKILL FILES

Before starting each platform, load the corresponding skill file into your Gemini CLI context:

```bash
# For backend work:
# Load: SKILL_BACKEND.md

# For Flutter work:
# Load: SKILL_FLUTTER.md

# For Web/Admin work:
# Load: SKILL_WEB.md
```

Each skill file contains:
- Absolute rules (never break them)
- Complete folder structure
- All critical code snippets
- Every common error and its fix
- A testing checklist to pass before moving on

---

## REPOSITORY STRUCTURE (monorepo)

```
tefusha/                          ← GitHub repo root
├── apps/
│   ├── mobile/                   ← Flutter app
│   ├── web/                      ← React.js public website
│   └── admin/                    ← React.js admin panel
├── backend/                      ← Node.js + Express API
├── docs/
│   ├── user-guide.md
│   ├── admin-guide.md
│   └── test-report.md
├── skills/                       ← This folder (skill files for Gemini)
│   ├── SKILL_BACKEND.md
│   ├── SKILL_FLUTTER.md
│   ├── SKILL_WEB.md
│   └── MASTER.md                 ← You are reading this
└── README.md
```

---

## PHASE 1: BACKEND — FULL CHECKLIST

**Skill file**: `SKILL_BACKEND.md`
**Duration**: ~2 weeks (January 2026, PMP Phase A3 parallel)

### Step-by-step
1. `mkdir backend && cd backend`
2. Run all setup commands from SKILL_BACKEND.md
3. Create `prisma/schema.prisma` exactly as in SKILL_BACKEND.md
4. Run `npx prisma migrate dev --name init`
5. Run `npx prisma generate`
6. Implement in this order:
   - `src/utils/prisma.ts`
   - `src/utils/jwt.ts`
   - `src/utils/validators.ts` (Zod schemas)
   - `src/middlewares/auth.middleware.ts`
   - `src/middlewares/rate-limit.ts`
   - `src/routes/auth.routes.ts` + `src/controllers/auth.controller.ts`
   - `src/routes/field.routes.ts` + `src/controllers/field.controller.ts`
   - `src/services/booking.service.ts` ← CRITICAL: atomic transaction
   - `src/routes/booking.routes.ts` + `src/controllers/booking.controller.ts`
   - `src/services/fixture.service.ts`
   - `src/routes/event.routes.ts` + `src/controllers/event.controller.ts`
   - `src/routes/admin.routes.ts` + `src/controllers/admin.controller.ts`
   - `src/app.ts` (wire all routes)
   - `src/index.ts` (server listen)
7. Write tests in `src/__tests__/`
8. Run the full testing checklist from SKILL_BACKEND.md

### ✅ DONE when ALL of these pass:
- [ ] `npx tsc --noEmit` — zero errors
- [ ] `npm test` — all tests pass
- [ ] Register + Login returns JWT tokens
- [ ] `GET /api/fields` returns array (even if empty)
- [ ] `GET /api/fields/1/availability?date=2026-05-01` returns slot array
- [ ] Booking the same slot twice returns `409 Conflict`
- [ ] Non-admin calling `/api/admin/stats` returns `403 Forbidden`
- [ ] `npx prisma studio` — all tables visible with correct columns

**DO NOT START FLUTTER UNTIL ALL ✅ ABOVE ARE CHECKED.**

---

## PHASE 2: FLUTTER APP — FULL CHECKLIST

**Skill file**: `SKILL_FLUTTER.md`
**Duration**: ~3 weeks (February–March 2026, PMP Phases A9 + A12)

### Step-by-step
1. `flutter create apps/mobile --org al.tefusha --project-name tefusha`
2. Update `pubspec.yaml` exactly as in SKILL_FLUTTER.md
3. Run `flutter pub get`
4. Implement in this order:
   - `core/constants/app_colors.dart`
   - `core/constants/app_strings.dart`
   - `core/constants/api_constants.dart`
   - `core/theme/app_theme.dart`
   - `data/datasources/local/token_storage.dart`
   - `data/datasources/remote/api_client.dart` (Dio + interceptors)
   - `data/models/` — all 4 models with `@JsonSerializable`
   - Run `flutter pub run build_runner build --delete-conflicting-outputs`
   - `data/repositories/` — all 4 repositories
   - `core/router/app_router.dart`
   - `presentation/auth/` — login + register pages + bloc
   - `presentation/home/home_page.dart` — bottom nav
   - `presentation/fields/` — list + detail + bloc + widgets
   - `presentation/booking/` — booking page + my bookings + bloc
   - `presentation/events/` — list + detail + bracket widget + bloc
   - `presentation/profile/profile_page.dart`
   - `main.dart` + `app.dart`

5. Run `flutter analyze` — zero errors
6. Run `flutter test`
7. Run on Android emulator: `flutter run -d emulator-5554`
8. Run `flutter build apk --release` — must succeed

### ✅ DONE when ALL of these pass:
- [ ] `flutter analyze` — zero errors
- [ ] `flutter test` — all tests pass
- [ ] Login/Register works on emulator
- [ ] Field list loads from backend (backend must be running)
- [ ] Filtering by city/type works
- [ ] Booking flow: date → slots → confirm → success
- [ ] Cannot double-book (shows Albanian error message)
- [ ] My Bookings shows history
- [ ] Events list + bracket widget render correctly
- [ ] Logout clears tokens and returns to login screen
- [ ] `flutter build apk --release` succeeds

**DO NOT START WEB UNTIL ALL ✅ ABOVE ARE CHECKED.**

---

## PHASE 3: WEB + ADMIN — FULL CHECKLIST

**Skill file**: `SKILL_WEB.md`
**Duration**: ~2 weeks (March–April 2026, PMP Phases A12 + A14)

### Step-by-step
1. Create both apps from SKILL_WEB.md setup commands
2. For each app:
   - Set `.env` file
   - Implement `api/client.ts` (Axios + interceptors)
   - Implement `api/endpoints.ts`
   - Implement `types/index.ts`
   - Implement `context/AuthContext.tsx`
   - Implement `hooks/` (useFields, useBookings, useEvents)
   - Implement all pages
   - Implement `components/`
3. Web: `npm start` on port 3000
4. Admin: `npm start` on port 3002 (set PORT=3002 in .env)
5. Run `npm run build` for both

### ✅ DONE when ALL of these pass:
- [ ] `npm run build` succeeds for both web and admin
- [ ] Web: Field search + filter works
- [ ] Web: Full booking flow works (login → find field → book)
- [ ] Web: Events + bracket visible
- [ ] Admin: Stats dashboard loads with charts
- [ ] Admin: Can view + manage all users/fields/bookings
- [ ] Admin: Cannot be accessed without admin JWT
- [ ] Both apps handle API errors gracefully (show Albanian messages)

---

## PHASE 4: INTEGRATION TEST

Run ALL 3 platforms simultaneously and test the complete user journey:

```bash
# Terminal 1 — Backend
cd backend && npm run dev

# Terminal 2 — Web
cd apps/web && npm start

# Terminal 3 — Admin
cd apps/admin && npm start

# Terminal 4 — Flutter (emulator must be running)
cd apps/mobile && flutter run
```

### Complete user journey to test:
1. **Register** a new user on Web (`http://localhost:3000/register`)
2. **Register** a field owner user on Web
3. **Login as field owner** → create a field
4. **Login as regular user** → find the field → book it
5. **Login as admin** (`http://localhost:3002`) → see the booking in admin panel
6. **Confirm booking** as field owner
7. Do the same flow from **Flutter app** (Android emulator)
8. **Generate an event** → register teams → generate fixtures → update results

### ✅ ALL platforms integration done when:
- [ ] Data created on Web appears in Admin immediately
- [ ] Data created on Flutter appears in Web without refresh issues
- [ ] Admin changes (e.g., field deactivation) reflect on Web and Flutter
- [ ] No CORS errors in browser console

---

## PHASE 5: PILOT + DEPLOY (May 2026, PMP Phase A20)

### Deploy order:
1. Backend to Vercel first
2. Web to Vercel (update REACT_APP_API_URL to backend Vercel URL)
3. Admin to Vercel
4. Update Flutter `ApiConstants.baseUrl` to production Vercel URL → rebuild APK

### Pilot checklist (5 sports fields):
- [ ] 5 real field owners registered and fields active
- [ ] At least 10 real bookings completed
- [ ] Pilot feedback form filled by each field owner
- [ ] No critical bugs (see PMP §18.2 priority table)
- [ ] At least 50 registered users reached

---

## ERROR PRIORITY GUIDE (from PMP §18.2)

| Priority | Response Time | Example |
|----------|--------------|---------|
| KRITIK | Max 2 hours | Server down, DB not responding |
| I LARTE | Max 4 hours | Login broken, booking not saving |
| MESATAR | Max 24 hours | Filter returning wrong results |
| I ULET | Max 72 hours | Image not loading, slow animation |

**For any KRITIK or I LARTE bug: stop all new development, fix immediately.**

---

## TECH STACK REFERENCE (from PMP §15.1 — DO NOT CHANGE)

| Layer | Technology | Version |
|-------|-----------|---------|
| Mobile | Flutter (Dart) | 3.x |
| Web Frontend | React.js | 18 |
| Admin Panel | React.js | 18 |
| Backend | Node.js + Express.js | 18 + 4.x |
| Database | PostgreSQL | 15 |
| ORM | Prisma | latest |
| Auth | JWT + bcrypt | - |
| Hosting | Vercel | - |
| DB Hosting | Supabase (free tier) | - |
| Version Control | GitHub | - |
| Design | Figma | - |

**Any AI agent that suggests switching to a different technology must be rejected.**

---

## TEAM RACI (who is responsible — from PMP §20)

| Task | Who |
|------|-----|
| Backend / API | Stiven Arifaj |
| Flutter Mobile | Gledis Peqini + Rigel Stojku |
| Web Frontend | Gledis Peqini |
| Admin Panel | Stiven + Gledis |
| Database schema | Argi Boshku |
| Testing + Pilot | Alban Cela |
| PM + Deployment | Stiven Arifaj |
| Documentation | Alban Cela |
