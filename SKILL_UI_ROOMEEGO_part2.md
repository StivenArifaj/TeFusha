## 8. SCREEN-BY-SCREEN BUILD GUIDE — AUTHENTICATION FLOW

**AGENT RULE: Build every screen in the exact order listed.**
**After each screen, run `flutter analyze` and fix ALL errors before moving to the next.**
**Never skip a screen. Never combine two screens into one file.**

---

### S01 — SplashScreen
File: lib/presentation/splash/splash_screen.dart

White scaffold. Centered column with:
1. Lottie.asset('assets/animations/logo_animation.json') — width 200, repeat: false
2. Below lottie: Text 'TeFusha' in Outfit Bold 32, color AppColors.primary
3. Below name: Text 'Rezervo fushën tënde sportive' in Outfit Regular 14, color AppColors.textMedium

Behavior:
- On initState: start a Future.delayed of 3 seconds
- After 3 seconds: check TokenStorage.isLoggedIn()
- If true → context.go('/home')
- If false, check if onboarding was seen (use SharedPreferences key 'onboarding_done')
- If onboarding not seen → context.go('/onboarding')
- If onboarding seen → context.go('/welcome')
- Always check mounted before calling context.go

Status bar: transparent, dark icons (already set in main.dart).

---

### S02 — WelcomeScreen
File: lib/presentation/welcome/welcome_screen.dart

This maps to RoomeeGo's WelcomeScreen — full-screen image with overlay.

Layout:
- Scaffold with no AppBar
- Stack as body:
  - Bottom layer: full-screen image (use a football field photo from assets/images/)
    If no photo available yet, use a Container with a LinearGradient from
    AppColors.heroDark to AppColors.heroMid, width/height: double.infinity
  - Top layer: a Column anchored to the bottom with Padding(horizontal: 20, bottom: 40):
    - Image or SVG logo (white version) OR Text 'TeFusha' in white Bold 36
    - SizedBox(height: 8)
    - Text 'Gjej dhe rezervo fushën tënde sportive' — white Regular 16, center
    - SizedBox(height: 40)
    - ElevatedButton 'Hyr në Llogari' — full width, primary red, navigates to /login
    - SizedBox(height: 12)
    - OutlinedButton 'Krijo Llogari' — full width, white border and white text,
      override the default outlined style here with:
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.white,
        side: const BorderSide(color: Colors.white, width: 1.5),
      )
      Navigates to /sign-up

---

### S03 — OnboardingScreen
File: lib/presentation/onboarding/onboarding_screen.dart

PageView with 3 pages. Uses smooth_page_indicator for dots.
Each page has:
- Top 55% of screen: colored gradient background with a large icon centered
  Page 1 bg: LinearGradient(AppColors.primaryLight → white), icon: Icons.search (size 120, primary)
  Page 2 bg: LinearGradient(Color(0xFFE8F5E9) → white), icon: Icons.calendar_today (size 120, sportFootball)
  Page 3 bg: LinearGradient(Color(0xFFE3F2FD) → white), icon: Icons.emoji_events (size 120, sportVolleyball)
- Bottom 45%: white, Padding(horizontal: 24):
  Title in Outfit Bold 26, color textDark
  SizedBox(height: 12)
  Body text in Outfit Regular 14, color textMedium, textAlign center
  SizedBox(height: 32)
  smooth_page_indicator dots (activeDot: primary, dot: divider, dotHeight: 8, dotWidth: 8, activeDotScale: 1.4)
  SizedBox(height: 32)
  ElevatedButton (full width):
    Pages 1 & 2: 'Vazhdo' → advance to next page
    Page 3: 'Fillo' → save onboarding_done = true in SharedPreferences, navigate to /welcome
  TextButton 'Kalo' (only on pages 1 & 2) → same as Fillo on page 3

Slide data:
  Page 1: title='Gjej Fushën Perfekte', body='Kërko qindra fusha sportive sipas qytetit, llojit dhe çmimit tuaj.'
  Page 2: title='Rezervo me Një Klik', body='Zgjidh datën dhe orarin dhe konfirmo rezervimin tënd brenda sekondave.'
  Page 3: title='Lëro & Garoje', body='Gjej lojtar, formo ekipin tënd dhe regjistrohu në kampionate lokale.'

---

### S04 — LoginScreen
File: lib/presentation/auth/login_screen.dart

AppBar: transparent, no elevation, leading back arrow (only if can pop, else null).

Body — SingleChildScrollView, Padding(horizontal: 20):
1. SizedBox(height: 40)
2. Text 'Mirë se vjen!' — Outfit Bold 28, textDark
3. SizedBox(height: 8)
4. Text 'Hyr në llogarinë tënde për të vazhduar.' — Outfit Regular 14, textMedium
5. SizedBox(height: 32)
6. TextFormField — label: 'Email', prefixIcon: Icons.email_outlined, keyboardType: email
7. SizedBox(height: 16)
8. TextFormField — label: 'Fjalëkalimi', prefixIcon: Icons.lock_outlined,
   obscureText toggled by eye icon suffix. Use StatefulWidget to manage _obscure bool.
9. SizedBox(height: 8)
10. Align(right): TextButton 'Harrove fjalëkalimin?' → /forgot-password, color: primary
11. SizedBox(height: 24)
12. ElevatedButton 'Hyr' — full width.
    If AuthBloc state is AuthLoading: show SizedBox(height:24,width:24,child:CircularProgressIndicator(color:white,strokeWidth:2))
    inside the button instead of text.
13. SizedBox(height: 20)
14. Row with Divider — Expanded(Divider) | Padding 'ose' text | Expanded(Divider)
    Divider color: AppColors.divider
15. SizedBox(height: 20)
16. Row centered with 2 social buttons:
    Each is an OutlinedButton with logo SVG icon, 60x60, circular border radius:
    Left: Google icon → (future: Google Sign-In — for now show SnackBar 'Së shpejti...')
    Right: Apple icon → same
17. SizedBox(height: 24)
18. Row centered: Text 'Nuk ke llogari? ' | TextButton 'Regjistrohu' → /sign-up

BLoC: Use existing AuthBloc.
Events: LoginSubmitted(email, password)
On AuthError: show red SnackBar with error message from state.
On AuthAuthenticated: context.go('/home')

---

### S05 — SignUpScreen
File: lib/presentation/auth/sign_up_screen.dart

Same layout structure as LoginScreen. Fields:
1. Title: 'Krijo Llogari', subtitle: 'Plotëso të dhënat e mëposhtme.'
2. TextFormField — 'Emri i plotë', prefix: Icons.person_outlined
3. TextFormField — 'Email', prefix: Icons.email_outlined
4. TextFormField — 'Fjalëkalimi', prefix: Icons.lock_outlined, obscure toggle
5. TextFormField — 'Konfirmo fjalëkalimin', prefix: Icons.lock_outlined, obscure toggle
6. SizedBox(height: 20)
7. Text 'Unë jam:' in Outfit Medium 14, textDark
8. SizedBox(height: 12)
9. Row with 2 RoleCard widgets (see Reusable Widgets section):
   Left: role='Lojtar', icon=Icons.sports_soccer, value='perdorues'
   Right: role='Pronar Fushe', icon=Icons.storefront_outlined, value='pronar_fushe'
   Selected card has primary red border (1.5px) and primaryLight background.
   Unselected: divider border, white background.
10. SizedBox(height: 8)
11. RichText: 'Duke vazhduar, pranon ' + TextSpan('Kushtet e Shërbimit', primary, underline)
    + ' dhe ' + TextSpan('Politikën e Privatësisë', primary, underline)
12. SizedBox(height: 24)
13. ElevatedButton 'Regjistrohu'
14. Row: 'Ke llogari? ' | TextButton 'Hyr' → /login

On success → navigate to /otp-verify (pass email as extra)

---

### S06 — OtpVerifyScreen
File: lib/presentation/auth/otp_verify_screen.dart

AppBar back arrow.
Body, Padding(horizontal: 20):
1. SizedBox(height: 40)
2. Text 'Verifiko Email' — Bold 28
3. SizedBox(height: 8)
4. RichText: 'Një kod 6-shifror u dërgua te ' + TextSpan(email in bold primary)
5. SizedBox(height: 40)
6. Pinput widget — 6 fields, defaultPinTheme:
   PinTheme(
     width: 52, height: 56,
     decoration: BoxDecoration(
       color: AppColors.inputFill,
       borderRadius: BorderRadius.circular(12),
     ),
     textStyle: Outfit Bold 20 textDark,
   )
   focusedPinTheme: same but with border: Border.all(color: primary, width: 1.5)
   submittedPinTheme: same but with border: Border.all(color: success, width: 1.5)
7. SizedBox(height: 32)
8. ElevatedButton 'Verifiko'
9. SizedBox(height: 20)
10. Row centered: Text 'Nuk e more kodin? ' + TextButton 'Dërgo Përsëri' (resend after 60s countdown)

---

### S07 — ForgotPasswordScreen
File: lib/presentation/auth/forgot_password_screen.dart

AppBar with 'Fjalekalim i harruar'.
Body Padding(horizontal: 20):
1. SizedBox(height: 40)
2. Lottie.asset('assets/animations/reset_password.json') — height: 200, repeat: false
3. SizedBox(height: 24)
4. Text 'Dërgoni email rivendosje' — Bold 22
5. Text 'Shkruani email-in tuaj dhe do të merrni udhëzime.' — Regular 14 textMedium
6. SizedBox(height: 32)
7. TextFormField — 'Email-i juaj', prefix: Icons.email_outlined
8. SizedBox(height: 24)
9. ElevatedButton 'Dërgo Kodin' → on success navigate to /otp-verify

---

### S08 — CreateNewPasswordScreen
File: lib/presentation/auth/create_new_password_screen.dart

AppBar 'Fjalëkalim i Ri'.
Two password fields (new + confirm), same style as login.
ElevatedButton 'Ruaj Fjalëkalimin'.
On success: show Lottie success animation in a Dialog, then navigate to /login.

---

### S09 — CreateYourProfileScreen
File: lib/presentation/auth/create_your_profile_screen.dart

Shown only once after first registration. AppBar 'Profili Juaj'.

Body Padding(horizontal: 20):
1. SizedBox(height: 20)
2. Center: Stack with:
   - CircleAvatar(radius: 50, bg: inputFill, child: Icon person 48 textLight)
   - Positioned bottom-right: CircleAvatar(radius:16, bg:primary,
     child: Icon(camera_alt, white, size:16))
   Tap → (future: image picker. For now show SnackBar 'Funksion i ardhshëm')
3. SizedBox(height: 24)
4. TextFormField 'Emri i plotë'
5. SizedBox(height: 16)
6. TextFormField 'Numri i telefonit', prefix: Icons.phone_outlined, keyboardType: phone
7. SizedBox(height: 20)
8. Text 'Sportet tuaja të preferuara:' — Medium 14
9. SizedBox(height: 12)
10. Wrap of sport FilterChips: Futboll | Basketboll | Tenis | Volejboll | Të tjera
    Multi-select. Selected: primary bg white text. Unselected: inputFill bg textMedium.
11. SizedBox(height: 32)
12. ElevatedButton 'Vazhdoni' → navigate to /home

---

## 9. SCREEN-BY-SCREEN BUILD GUIDE — MAIN APP & HOME

---

### S10 — BottomNavigationScreen
File: lib/presentation/main/bottom_navigation_screen.dart

StatefulWidget. Manages _currentIndex (0–4).
Uses IndexedStack to preserve state across tabs.

5 tab pages (in IndexedStack children):
  index 0: HomeScreen()
  index 1: MostPopularScreen()   ← Fields tab
  index 2: AnnouncementFeedScreen()  ← Community tab
  index 3: EventListScreen()     ← Tournaments tab
  index 4: ProfileScreen()

BottomNavigationBar:
```dart
BottomNavigationBar(
  currentIndex: _currentIndex,
  onTap: (i) => setState(() => _currentIndex = i),
  items: [
    BottomNavigationBarItem(icon: Icon(Icons.home_outlined),       activeIcon: Icon(Icons.home),         label: 'Kryefaqja'),
    BottomNavigationBarItem(icon: Icon(Icons.stadium_outlined),    activeIcon: Icon(Icons.stadium),      label: 'Fushat'),
    BottomNavigationBarItem(icon: Icon(Icons.groups_outlined),     activeIcon: Icon(Icons.groups),       label: 'Komuniteti'),
    BottomNavigationBarItem(icon: Icon(Icons.emoji_events_outlined),activeIcon: Icon(Icons.emoji_events),label: 'Turneu'),
    BottomNavigationBarItem(icon: Icon(Icons.person_outlined),     activeIcon: Icon(Icons.person),       label: 'Profili'),
  ],
)
```

Wrap in a Container with top BoxShadow from AppShadows.bottomNav.
The container clips the nav bar from the content above cleanly.

---

### S11 — HomeScreen
File: lib/presentation/home/home_screen.dart

This is the most important screen. The RoomeeGo home has a dark gradient top section
that transitions to a white card-based content area below. Mirror this exactly.

Use a CustomScrollView with SliverList:

**SLIVER 1 — HERO HEADER (dark gradient)**
A SliverToBoxAdapter containing:
Container(
  decoration: BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [AppColors.heroDark, AppColors.heroMid],
    ),
  ),
  padding: EdgeInsets.fromLTRB(20, 60, 20, 28),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Mirëmëngjes 👋', style: Outfit Regular 14 white.withOpacity(0.7)),
          Text(userName, style: Outfit Bold 20 white),
        ]),
        // Notification bell with badge
        Stack(children: [
          IconButton(icon: Icon(Icons.notifications_outlined, color: white, size: 28),
            onPressed: () => context.push('/notifications')),
          Positioned(top: 8, right: 8,
            child: Container(width:10, height:10,
              decoration: BoxDecoration(color: AppColors.primary, shape: BoxShape.circle,
                border: Border.all(color: white, width: 1.5)))),
        ]),
      ]),
      SizedBox(height: 20),
      // Search bar — white, tap to navigate to /search
      GestureDetector(
        onTap: () => context.push('/search'),
        child: Container(
          height: 50,
          decoration: BoxDecoration(color: white, borderRadius: BorderRadius.circular(12)),
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Row(children: [
            Icon(Icons.search, color: AppColors.textLight, size: 20),
            SizedBox(width: 8),
            Text('Kërko fusha sportive...', style: Outfit Regular 14, color: textLight),
            Spacer(),
            GestureDetector(
              onTap: () => context.push('/filter'),
              child: Container(
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(color: AppColors.primaryLight, borderRadius: BorderRadius.circular(8)),
                child: Icon(Icons.tune, color: AppColors.primary, size: 18),
              ),
            ),
          ]),
        ),
      ),
    ],
  ),
)

**SLIVER 2 — SPORT CATEGORY CHIPS**
SliverToBoxAdapter, bg: white, Padding(top:20, horizontal:20, bottom:8):
Text 'Kategoritë' Medium 16 textDark
SizedBox(height: 12)
SingleChildScrollView(scrollDirection: Axis.horizontal):
  Row with SportCategoryChip widgets for:
  'Të gjitha' (icon: Icons.sports), 'Futboll' (soccer), 'Basketboll' (basketball),
  'Tenis' (tennis), 'Volejboll' (volleyball)

SportCategoryChip selected state: primary bg, white icon+text.
Unselected: white bg, divider border, textMedium icon+text.
Each chip: rounded 20, padding H:16 V:10.

**SLIVER 3 — FUSHAT AFËR JUSH (Near You)**
SliverToBoxAdapter, bg: white, Padding(H:20, top:16, bottom:8):
SectionHeader('Fushat Afër Jush', onSeeAll: () => context.push('/near-by-fields'))
SizedBox(height: 12)
SizedBox(height: 220, child: BlocBuilder<FieldBloc, FieldState>(
  builder: (ctx, state) {
    if (state is FieldLoading) return _horizontalShimmer();
    if (state is FieldLoaded) return ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: state.fields.length,
      separatorBuilder: (_, __) => SizedBox(width: 16),
      itemBuilder: (_, i) => FieldCardHorizontal(field: state.fields[i]),
    );
    return SizedBox.shrink();
  }
))

**SLIVER 4 — NJOFTIME AKTIVE (Matchmaking)**
SliverToBoxAdapter, bg: white, Padding(H:20, top:16, bottom:8):
SectionHeader('Njoftime Aktive', onSeeAll: () => context.push('/community'))
SizedBox(height: 12)
BlocBuilder: show 2 AnnouncementCardCompact widgets

**SLIVER 5 — TURNETË E ARDHSHME**
SliverToBoxAdapter, bg: white, Padding(H:20, top:16, bottom:24):
SectionHeader('Turnetë e Ardhshme', onSeeAll: () => context.push('/events'))
SizedBox(height: 12)
BlocBuilder: show 2 EventCardCompact widgets

---

### S12 — SearchScreen
File: lib/presentation/search/search_screen.dart

AppBar replaced by a custom search header (white bg):
Row: BackButton | Expanded(TextField autofocus: true, filled, no border) | filter icon

Body:
- If query empty: show 'Kërkimet e fundit' section with recent search chips
  (store in SharedPreferences as List<String>)
- If query not empty: BlocBuilder showing FieldCard list filtered by query
- Each field tap → /field/:id

---

### S13 — FilterScreen
File: lib/presentation/filter/filter_screen.dart

AppBar 'Filtro Fushat' with a 'Pastro' TextButton on right that resets all filters.

Body SingleChildScrollView Padding(H:20):

1. Text 'Lloji i Sportit' — Medium 16
   Wrap with FilterChip for each sport type (multi-select)

2. Divider, SizedBox(height:16)

3. Text 'Qyteti' — Medium 16
   DropdownButtonFormField with Albanian cities:
   Tiranë, Durrës, Vlorë, Shkodër, Elbasan, Korçë, Fier, Berat, Lushnjë

4. Divider, SizedBox(height:16)

5. Text 'Çmimi (L/orë)' — Medium 16
   RangeSlider(min:0, max:5000, divisions:10)
   Row showing selected range: 'L ${values.start.round()} — L ${values.end.round()}'

6. Divider, SizedBox(height:16)

7. Text 'Disponueshmëria' — Medium 16
   Date picker button (shows selected date or 'Zgjidh datën')

8. SizedBox(height:32)
9. ElevatedButton 'Apliko Filtrat' — applies filters and pops with result

---

### S16 — MostPopularScreen (Fields tab)
File: lib/presentation/fields/most_popular_screen.dart

AppBar 'Fushat Sportive' with search icon (→ /search) and filter icon (→ /filter).

Body:
Sport category chips at top (same as home, but updates the list below when tapped).
BlocBuilder below: ListView.separated of FieldCard widgets.
Each FieldCard is the FULL vertical card (not the horizontal one).

---

### S17 — FieldDetailScreen
File: lib/presentation/fields/field_detail_screen.dart

This is the most complex screen. Use CustomScrollView + SliverAppBar.

**SliverAppBar:**
- expandedHeight: 280
- pinned: true
- flexibleSpace: FlexibleSpaceBar(
    background: CachedNetworkImage(url: field.imageUrl, fit: BoxFit.cover)
    If no image: Container with gradient heroDark→heroMid + centered sport icon (white, size 80)
  )
- backgroundColor: white (for pinned state)
- leading: CircleBackButton (white circle, back arrow, slight shadow)
- actions: [ CircleIconButton(Icons.favorite_border) ]

**SliverList content:**

SECTION 1 — NAME & BASIC INFO (white card, padding 20):
Row: Text(field.emri_fushes, Bold 22) | SportTypeBadge(field.lloji_fushes)
SizedBox(height:8)
Row: Icon(location, 14, primary) | Text(field.qyteti + ', ' + field.vendndodhja, Regular 13 textMedium)
SizedBox(height:12)
Row with 3 InfoStatCard:
  Left: price + 'L/orë' label
  Center: capacity + 'Lojtarë' label
  Right: status badge

SECTION 2 — RATING (if reviews exist):
Row: StarWidget(4.8) | Text('4.8') Bold 14 | Text('(24 komente)') Regular 12 textMedium
Tap row → /field/:id/reviews

SECTION 3 — PAJISJET / FACILITIES:
Text 'Pajisjet dhe Lehtësirat' — Medium 16
SizedBox(height:12)
Wrap of FacilityChip widgets (parse field.pajisjet by comma)
TextButton 'Shiko të gjitha →' → /field/:id/facilities

SECTION 4 — VENDNDODHJA (Map):
Text 'Vendndodhja' — Medium 16
SizedBox(height:12)
if (field.lat != null && field.lng != null):
  FieldMapWidget(lat, lng, fieldName) — height 200, border radius 16
  SizedBox(height:12)
  Row(mainAxisAlignment: spaceBetween, children: [
    Expanded(child: OutlinedButton.icon(
      icon: Icon(Icons.map_outlined), label: Text('Harta e plotë'),
      onPressed: () → show full-screen FlutterMap in a showModalBottomSheet
    )),
    SizedBox(width:12),
    Expanded(child: ElevatedButton.icon(
      icon: Icon(Icons.directions),
      label: Text('Më jep rrugën'),
      style: ElevatedButton.styleFrom(backgroundColor: AppColors.sportFootball),
      onPressed: () → _openGoogleMapsNavigation(lat, lng)
    )),
  ])
else:
  Container(height:100, decoration:BoxDecoration(color:inputFill, borderRadius:BorderRadius.circular(16)),
    child: Center(child: Text('Vendndodhja nuk disponohet', Regular 13 textLight)))

BOTTOM PERSISTENT BUTTON (NOT in scroll, anchored at bottom):
Container(
  padding: EdgeInsets.fromLTRB(20, 12, 20, 28),
  decoration: BoxDecoration(
    color: white,
    boxShadow: AppShadows.bottomNav,
  ),
  child: Row(children: [
    Column(crossAxisAlignment: start, children: [
      Text('Çmimi', Regular 12 textLight),
      Text('L ${field.cmimi_orari}/orë', Bold 22 primary),
    ]),
    SizedBox(width: 16),
    Expanded(child: ElevatedButton('Rezervo Tani', → /book/:id)),
  ]),
)

Google Maps navigation function:
```dart
Future<void> _openGoogleMapsNavigation(double lat, double lng) async {
  final url = Uri.parse(
    'https://www.google.com/maps/dir/?api=1&destination=$lat,$lng&travelmode=driving',
  );
  if (await canLaunchUrl(url)) {
    await launchUrl(url, mode: LaunchMode.externalApplication);
  } else {
    final geo = Uri.parse('geo:$lat,$lng?q=$lat,$lng');
    if (await canLaunchUrl(geo)) await launchUrl(geo);
  }
}
```

---

## 10. SCREEN-BY-SCREEN BUILD GUIDE — BOOKING FLOW

---

### S20 — RequestToBookScreen
File: lib/presentation/booking/request_to_book_screen.dart

AppBar 'Rezervo Fushën'.

Body — SingleChildScrollView, Padding(H:20):

SECTION 1 — FIELD SUMMARY CARD (use FieldSummaryMiniCard widget):
White card with shadow, padding 16, border radius 16:
Row: field image (60x60, borderRadius 12) | Column(field name Bold 16 | city + type Regular 13 textMedium) | price right-aligned Bold 16 primary

SECTION 2 — DATE STRIP:
Text 'Zgjidh Datën' — Medium 16
SizedBox(height:12)
SizedBox(height: 90, child: ListView.builder(
  scrollDirection: Axis.horizontal,
  itemCount: 30, // 30 days from today
  itemBuilder: (_, i) {
    final day = DateTime.now().add(Duration(days: i));
    final isSelected = isSameDay(day, _selectedDate);
    return GestureDetector(
      onTap: () { setState(() => _selectedDate = day); _loadSlots(day); },
      child: Container(
        width: 58, margin: EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.cardBg,
          borderRadius: BorderRadius.circular(14),
          border: isSelected ? null : Border.all(color: AppColors.divider),
          boxShadow: isSelected ? AppShadows.button : AppShadows.card,
        ),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(DateFormat('EEE', 'sq').format(day).toUpperCase(),
            style: Outfit Medium 11, color: isSelected ? white.withOpacity(0.8) : textLight),
          SizedBox(height: 4),
          Text('${day.day}',
            style: Outfit Bold 20, color: isSelected ? white : textDark),
          SizedBox(height: 4),
          Text(DateFormat('MMM', 'sq').format(day),
            style: Outfit Regular 11, color: isSelected ? white.withOpacity(0.8) : textLight),
        ]),
      ),
    );
  }
))

SECTION 3 — TIME SLOT GRID:
Text 'Oraret e Disponueshme' — Medium 16
SizedBox(height:8)
Text selected date string — Regular 13 textMedium
SizedBox(height:12)

BlocBuilder:
  Loading: GridView 4-column shimmer
  Loaded(slots): GridView.builder(
    shrinkWrap: true, physics: NeverScrollableScrollPhysics(),
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 4, crossAxisSpacing: 10, mainAxisSpacing: 10, childAspectRatio: 2.2
    ),
    itemBuilder: (_, i) {
      final slot = slots[i];
      final isAvailable = slot.available;
      final isSelected = slot.time == _selectedSlot;
      return GestureDetector(
        onTap: isAvailable ? () => setState(() => _selectedSlot = slot.time) : null,
        child: Container(
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary
                 : isAvailable ? AppColors.cardBg
                 : AppColors.inputFill,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected ? AppColors.primary
                   : isAvailable ? AppColors.divider
                   : AppColors.divider.withOpacity(0.5),
            ),
          ),
          child: Center(child: Text(slot.time,
            style: Outfit Medium 13,
            color: isSelected ? white : isAvailable ? textDark : textLight)),
        ),
      );
    }
  )

SECTION 4 — BOOKING SUMMARY (visible only when _selectedSlot != null):
AnimatedContainer that fades in:
White card, padding 16, border radius 16, shadow:
  BookingSummaryRow('Fusha', field.emri_fushes)
  BookingSummaryRow('Data', formatted date)
  BookingSummaryRow('Ora', _selectedSlot + ' - ' + endTime)
  Divider
  BookingSummaryRow('Totali', 'L ${field.cmimi_orari}', valueStyle: Bold 18 primary)

BOTTOM BUTTON (anchored):
ElevatedButton 'Vazhdo me Checkout' → /checkout (passing booking data as extra)
Disabled and gray when _selectedSlot == null.

---

### S21 — CheckoutScreen
File: lib/presentation/booking/checkout_screen.dart

AppBar 'Konfirmimi'.

Body Padding(H:20):
1. FieldSummaryMiniCard (same as above)
2. SizedBox(height:20)
3. White card with complete booking summary:
   Title: 'Detajet e Rezervimit' Medium 16
   Divider
   BookingSummaryRow for each detail
   Divider
   BookingSummaryRow('Totali', price, Bold 18 primary)
4. SizedBox(height:20)
5. Text 'Metoda e Pagesës' Medium 16
   Note card: Container with lightBlue bg, info icon, text 'Pagesa kryhet fizikisht në fushë gjatë rezervimit.'
   This is enough for pilot phase — no online payment yet.
6. SizedBox(height:32)
7. ElevatedButton 'Konfirmo Rezervimin' → calls CreateBookingEvent

On success → context.go('/booking-complete')
On error → show red SnackBar

---

### S22 — BookingDetailScreen
File: lib/presentation/booking/booking_detail_screen.dart

AppBar 'Detajet e Rezervimit'.

Body Padding(H:20):
White card with all booking info + status badge at top.
FieldSummaryMiniCard.
Timeline-style view of: booked → pending confirmation → confirmed.
If status = ne_pritje: show OutlinedButton 'Anulo Rezervimin' in error color.
If status = konfirmuar: show green banner 'Rezervimi juaj është konfirmuar!'.

---

### S23 — BookingCompleteScreen
File: lib/presentation/booking/booking_complete_screen.dart

No AppBar. White scaffold. Full center content:
1. Lottie.asset('assets/animations/login_successful_animation.json') — w:200, repeat:false
2. SizedBox(height:16)
3. Text 'Rezervimi u Krye!' — Bold 28 textDark
4. SizedBox(height:8)
5. Text 'Rezervimi juaj është regjistruar me sukses. Pronari do t\'ju kontaktojë për konfirmim.' — Regular 14 textMedium, center
6. SizedBox(height:32)
7. BookingSummary card (same white card as checkout)
8. SizedBox(height:32)
9. ElevatedButton 'Kthehu në Faqen Kryesore' → context.go('/home')
10. SizedBox(height:12)
11. OutlinedButton 'Shiko Rezervimin' → context.push('/booking/:id')

---

### S24 — MyBookingScreen
File: lib/presentation/booking/my_booking_screen.dart

AppBar 'Rezervimet e Mia'.

TabBar with 2 tabs: 'Aktive' | 'Historia'
TabBarView:
  Tab 1 (Aktive): filter bookings where status = ne_pritje OR konfirmuar
  Tab 2 (Historia): filter bookings where status = anuluar OR date is past

Each booking shown as BookingListCard:
White card, padding 16, border radius 16, shadow:
Left vertical strip (4px wide, border radius 4):
  yellow = ne_pritje, green = konfirmuar, red = anuluar
Row: field image 56x56 rounded | Column(field name Bold 15 | date+time Regular 13 textMedium | status badge)
If ne_pritje: small 'Anulo' TextButton bottom right, color error

Empty state (Lottie or illustration):
Centered column: illustration + 'Nuk keni rezervime aktive' + 'Rezervo Tani' ElevatedButton

---

## 11. SCREEN-BY-SCREEN BUILD GUIDE — COMMUNITY & MATCHMAKING

---

### S25 — AnnouncementFeedScreen
File: lib/presentation/community/announcement_feed_screen.dart

AppBar 'Komuniteti' with no back button (main tab).

Body:
1. FilterChipRow (horizontal scroll, same style as sport chips):
   'Të gjitha' | 'Kërko Lojtar' | 'Kërko Kundërshtar' | 'Kërko Ekip'
   Padding H:20, V:12

2. BlocBuilder: ListView.separated of AnnouncementCard widgets
   separatorBuilder: Divider(height:1, indent:20, endIndent:20)

Each AnnouncementCard (full spec in Reusable Widgets section):
White bg, padding 16:
Row: UserAvatar(initials, color) | username Bold 14 | role badge | timeago text Regular 12 textLight
SizedBox(height:8)
AnnouncementTypeBadge (colored pill: blue/pink/purple)
SizedBox(height:4)
Text(titull, Medium 15, maxLines:2, overflow:ellipsis)
SizedBox(height:4)
Text(pershkrim, Regular 13 textMedium, maxLines:2, overflow:ellipsis)
SizedBox(height:8)
Row: SportChip | LocationChip(if available) | Spacer | Text('${responses} përgjigje', Regular 12 textLight)
Tap card → /community/:id

3. FloatingActionButton (+ icon, primary bg, positioned bottom-right):
   onPressed: () => context.push('/community/new')

---

### S26 — CreateAnnouncementScreen
File: lib/presentation/community/create_announcement_screen.dart

AppBar 'Njoftim i Ri'.

Body SingleChildScrollView Padding(H:20):
1. Text 'Çfarë po kërkon?' — Medium 16
2. SizedBox(height:12)
3. Row with 3 AnnouncementTypeCard (equal width, height:80):
   Each has icon + label, colored border when selected:
   Left: Icon(person_add, blue) | 'Kërko Lojtar' | blue border when selected
   Center: Icon(groups, pink) | 'Kërko Kundërshtar' | pink border
   Right: Icon(search, purple) | 'Kërko Ekip' | purple border

4. SizedBox(height:20)
5. DropdownButtonFormField 'Lloji i Sportit' — same 5 options
6. SizedBox(height:16)
7. TextFormField 'Titulli' — e.g. 'Na duhet 1 lojtar për kalçeto sot'
8. SizedBox(height:16)
9. TextFormField 'Përshkrimi' — multiline: 4 rows
10. SizedBox(height:16)
11. TextFormField 'Vendndodhja (opsionale)' — prefix: Icons.location_on_outlined
12. SizedBox(height:16)
13. if type == kerko_lojtar: show CounterRow:
    Text 'Lojtarë të nevojshëm: ' | IconButton(-) | Text(count, Bold 18) | IconButton(+)
14. SizedBox(height:32)
15. ElevatedButton 'Posto Njoftimin'
    On success: pop + show SnackBar 'Njoftimi u postua!'

---

### S27 — AnnouncementDetailScreen
File: lib/presentation/community/announcement_detail_screen.dart

AppBar with poster's name as title.

Body:
Top section: full AnnouncementCard (expanded, not truncated)
Divider
Section 'Përgjigjet (N)' Medium 16
ListView of ResponseCard:
  UserAvatar | username Bold 14 | timeago | response text Regular 14

BOTTOM INPUT (anchored like chat):
Container(padding: H:16 V:12, border-top: divider, color:white):
Row: Expanded(TextFormField 'Shkruaj një përgjigje...', filled, no border) |
     SizedBox(w:8) | CircleButton(send icon, primary) → submit response

---

## 12. SCREEN-BY-SCREEN BUILD GUIDE — TEAMS & TOURNAMENTS

---

### S28 — MyTeamsScreen
File: lib/presentation/teams/my_teams_screen.dart

AppBar 'Ekipet e Mia' with '+' action (→ /teams/new).

BlocBuilder:
Empty state: centered illustration + 'Nuk jeni anëtar i asnjë ekipi' + ElevatedButton 'Krijo Ekip'
Loaded: ListView of TeamCard:
  White card, padding 16, shadow:
  Row: SportIcon(color, bg:sportColor.withOpacity(0.1), 44x44 rounded) |
       Column(team name Bold 16 | sport + member count Regular 13 textMedium) |
       if captain: 'Kapitan' badge (primary pill)
  Tap → /teams/:id

---

### S29 — CreateTeamScreen
File: lib/presentation/teams/create_team_screen.dart

AppBar 'Krijo Ekip të Ri'.

Body Padding(H:20):
1. Center: DottedBorder(circle, dashed, primary) containing:
   Stack: CircleAvatar(radius:50, placeholder) + camera badge
   (team logo — future feature, placeholder for now)
2. SizedBox(height:24)
3. TextFormField 'Emri i Ekipit'
4. SizedBox(height:16)
5. DropdownButtonFormField 'Lloji i Sportit'
6. SizedBox(height:16)
7. TextFormField 'Përshkrimi (opsional)', multiline: 3
8. SizedBox(height:32)
9. ElevatedButton 'Krijo Ekipin'

---

### S30 — TeamDetailScreen
File: lib/presentation/teams/team_detail_screen.dart

AppBar(team name) with edit IconButton if current user is captain.

Body:
Hero card (same style as announcement card but for team):
  Sport icon large + team name Bold 22 + sport type chip + member count

Section 'Anëtarët' Medium 16:
ListView.separated of MemberListTile:
  UserAvatar | name Bold 14 | role badge (Kapitan = primary pill, Anëtar = gray pill)
  If captain viewing: trailing IconButton(remove member) — red icon

Buttons bottom:
If captain: ElevatedButton 'Ftoni Anëtar' (opens bottom sheet with email input)
ElevatedButton 'Regjistrohu për Event' (outlined) → /events with sport filter pre-applied

---

### S32 — EventDetailScreen
File: lib/presentation/events/event_detail_screen.dart

AppBar(event name).

Body:
Event info card: dates, field name, sport type, organizer, status badge, max teams, registered count.

Section 'Ekipet e Regjistruara' Medium 16:
List of registered teams: rank number | team name | member count

Section 'Tabela / Fixtures':
DefaultTabController with tabs per round: 'Raundi 1', 'Raundi 2', etc.
Each tab: list of MatchCard:
  White card: HomeTeam name | score_or_vs | AwayTeam name
  If score available: bold the winner, color green.
  If not played: 'vs' in textMedium center.

If event.statusi == planifikuar AND user has eligible team:
Sticky bottom button: ElevatedButton 'Regjistro Ekipin Tim' → /events/:id/register

---

## 13. SCREEN-BY-SCREEN BUILD GUIDE — FIELD OWNER

---

### S35 — OwnerDashboardScreen
File: lib/presentation/owner/owner_dashboard_screen.dart

AppBar 'Paneli Im'.

Body Padding(H:20):
Row of 3 StatMiniCard (equal width):
  Card 1: count + 'Fushat' + stadium icon
  Card 2: count + 'Rez. Sot' + calendar icon
  Card 3: count + 'Rez. Javore' + trending icon
  Each card: white, shadow, border radius 16, primary color for count Bold 24, label Regular 12 textMedium

Section 'Fushat e Mia' Medium 16:
ListView of OwnerFieldCard:
  White card, padding 16, shadow, border radius 16:
  Left: field image 70x70, border radius 12
  Right column: field name Bold 16 | city + type Regular 13 | status badge
  Bottom row: 'X rezervime sot' Regular 13 textMedium | edit icon | bookings icon
  Tap bookings icon → /owner/bookings filtered by this field

ElevatedButton 'Regjistro Fushë të Re' at bottom (or shown centered when list is empty)
→ /owner/fields/new

---

### S36 — RegisterFieldScreen
File: lib/presentation/owner/register_field_screen.dart

AppBar 'Regjistro Fushën'.

Use a Stepper with 3 steps (horizontal indicator at top as custom widget, NOT Flutter Stepper):
Build a custom StepIndicator: Row of 3 circles connected by lines.
Active: primary filled circle + primary text.
Completed: primary circle with check icon.
Inactive: inputFill circle + textLight text.

STEP 1 — Informacioni Bazë:
  TextFormField 'Emri i Fushës'
  DropdownBFF 'Lloji i Sportit'
  DropdownBFF 'Qyteti'
  TextFormField 'Adresa e plotë'
  TextFormField 'Çmimi për orë (L)', keyboardType: number
  TextFormField 'Kapaciteti (lojtarë)', keyboardType: number

STEP 2 — Pajisjet:
  Text 'Zgjidh pajisjet dhe lehtësirat e disponueshme:'
  CheckboxListTile for each:
    'Ndriçim artificial', 'Dhomat e zhveshjes', 'Parkim',
    'Wi-Fi', 'Fryerje topi', 'Tualete', 'Bar/Restorant'
  TextFormField 'Pajisje të tjera (opsional)'

STEP 3 — Vendndodhja GPS:
  Text 'Koordinatat GPS' Medium 14
  Helper text small: 'Hapni Google Maps, mbani shtypur mbi vendndodhjen tuaj dhe kopjoni koordinatat.'
  TextFormField 'Gjerësia gjeografike (Lat)' — keyboardType: numberWithOptions(decimal:true)
  SizedBox(height:12)
  TextFormField 'Gjatësia gjeografike (Lng)' — same
  SizedBox(height:16)
  if lat and lng both filled:
    FieldMapWidget(lat, lng, 'Fusha juaj') — height 200

Buttons at bottom:
  Row: OutlinedButton 'Prapa' (if step > 0) | Expanded | ElevatedButton 'Vazhdo' / 'Regjistro'

---

### S37 — OwnerBookingsScreen
File: lib/presentation/owner/owner_bookings_screen.dart

AppBar 'Rezervimet e Fushës'.

Filter row: DropdownButton for date filter (Sot, Kjo Javë, Ky Muaj).

BlocBuilder: ListView of OwnerBookingCard:
White card, padding 16, shadow:
Row: UserAvatar(initials) | Column(user name | date + time | price) | status badge right
If status = ne_pritje:
  Row at bottom: OutlinedButton 'Refuzo' (error color) | ElevatedButton 'Konfirmo' (success color)
If status = konfirmuar:
  Text 'E konfirmuar ✓' — green

---

## 14. SCREEN-BY-SCREEN BUILD GUIDE — PROFILE & SETTINGS

---

### S40 — ProfileScreen
File: lib/presentation/profile/profile_screen.dart

No AppBar. CustomScrollView:

SliverToBoxAdapter — hero section (heroDark gradient, padding top:60 bottom:32):
  Center column:
  CircleAvatar(radius:50, image or initials)
  SizedBox(height:12)
  Text(user.emri, Bold 22, white)
  Text(user.email, Regular 13, white.withOpacity(0.7))
  SizedBox(height:16)
  Row centered, 3 StatBadge: bookings count | teams count | events count
  (white pill bg, textDark text)

SliverToBoxAdapter — menu items (white bg, border radius top 24):
ProfileMenuItem for each:
  Icon + 'Rezervimet e Mia' → /my-bookings
  Icon + 'Të preferuarat' → /favourites
  Icon + 'Njoftimet' → /notifications
  Icon + 'Redakto Profilin' → /profile/edit
  IF role == pronar_fushe: Icon + 'Paneli Im' → /owner (PRIMARY RED TEXT)
  Divider
  Icon + 'Ndërrimi i Fjalëkalimit' → /security
  Icon + 'Njoftimet' → /profile/notifications
  Icon + 'Ndihmë & Mbështetje' → /help
  Icon + 'Politika e Privatësisë' → /privacy
  Divider
  Lottie logout confirmation → ProfileMenuItem 'Dil' (error color icon+text) → logout dialog

ProfileMenuItem spec:
ListTile(
  leading: Container(40x40, color:primaryLight, borderRadius:10, child: Icon(icon, primary)),
  title: Text(label, Medium 15),
  trailing: Icon(chevron_right, textLight),
  onTap: callback,
)

---

### S41 — EditProfileScreen
File: lib/presentation/profile/edit_profile_screen.dart

AppBar 'Redakto Profilin' with 'Ruaj' TextButton action.

Body Padding(H:20):
Center: profile photo with camera badge (same as CreateYourProfileScreen)
SizedBox(height:24)
TextFormField 'Emri i plotë'
SizedBox(height:16)
TextFormField 'Numri i telefonit'
SizedBox(height:16)
TextFormField 'Email' — readOnly: true, hint that email cannot be changed
SizedBox(height:32)
ElevatedButton 'Ruaj Ndryshimet'

---

## 15. REUSABLE WIDGETS — BUILD THESE ONCE, USE EVERYWHERE

All reusable widgets go in: lib/presentation/common/widgets/

---

### FieldCard (vertical — full size)
File: field_card.dart
```dart
// White card, border radius 16, shadow AppShadows.card
// ClipRRect image: height 160, full width, top corners 16, bottom 0
// If no image: gradient Container with centered sport icon (white, size 48)
// Padding(16) below image:
//   Row: field name Bold 15 (flex:1) | price badge (primaryLight bg, primary text, pill)
//   SizedBox(8)
//   Row: location icon + city text Regular 13 textMedium | Spacer | sport type chip
//   SizedBox(8)
//   Row: star rating + count | Spacer | small 'Rezervo' OutlinedButton
// Tap anywhere → context.push('/field/${field.id}')
```

### FieldCardHorizontal (for home screen scroll)
File: field_card_horizontal.dart
Width: 200, height: 220, white card, shadow, border radius 16.
Image: full width, height 130, top corners 16.
Below: Padding(12): name Bold 14 max 2 lines | city Regular 12 textMedium | price Bold 14 primary.

### FieldMapWidget
File: field_map_widget.dart
See Section 9 FieldDetailScreen for full implementation.

### SectionHeader
File: section_header.dart
```dart
Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
  Text(title, style: titleSmall Bold),
  if (onSeeAll != null) TextButton('Shiko të gjitha', onPressed: onSeeAll,
    style: TextButton.styleFrom(foregroundColor: AppColors.primary)),
])
```

### SportCategoryChip
File: sport_category_chip.dart
Chip with icon + label. Selected = primary bg white text. Unselected = white bg border textMedium.
Height: 40. Border radius: 20. Horizontal padding: 16.

### StatusBadge
File: status_badge.dart
Container pill (border radius 100, horizontal padding 10, vertical 4):
  ne_pritje: statusPending bg + statusTextPending text + '⏳ Në Pritje'
  konfirmuar: statusConfirmed bg + statusTextConfirmed text + '✓ Konfirmuar'
  anuluar: statusCancelled bg + statusTextCancelled text + '✗ Anuluar'

### AnnouncementTypeBadge
File: announcement_type_badge.dart
Same pill shape:
  kerko_lojtar: announceNeedPlayer bg + blue text + '👤 Kërko Lojtar'
  kerko_kundershtare: announceNeedOpponent bg + pink text + '⚔️ Kërko Kundërshtar'
  kerko_ekip: announceNeedTeam bg + purple text + '🏃 Kërko Ekip'

### UserAvatar
File: user_avatar.dart
CircleAvatar(radius: size/2, bg: color, child: Text(initials, white Bold)).
Generate bg color deterministically from user name (use hashCode % colors list).
Colors list: primary, sportFootball, sportBasketball, sportTennis, sportVolleyball.

### SportTypeBadge
File: sport_type_badge.dart
Pill chip with sport icon + name. Color from SportConstants.getColor(lloji).

### CircleBackButton
File: circle_back_button.dart
```dart
GestureDetector(
  onTap: () => context.pop(),
  child: Container(
    width: 40, height: 40,
    decoration: BoxDecoration(
      color: Colors.white, shape: BoxShape.circle,
      boxShadow: AppShadows.card,
    ),
    child: Icon(Icons.arrow_back_ios_new, size: 18, color: AppColors.textDark),
  ),
)
```

### BookingSummaryRow
File: booking_summary_row.dart
Row(mainAxisAlignment: spaceBetween, children: [
  Text(label, Regular 14 textMedium),
  Text(value, valueStyle ?? Medium 14 textDark),
])
Padding(vertical: 8).

### FieldCardSkeleton (shimmer)
File: field_card_skeleton.dart
Same dimensions as FieldCard but all content replaced with:
Shimmer.fromColors(
  baseColor: Color(0xFFE0E0E0),
  highlightColor: Color(0xFFF5F5F5),
  child: ... gray boxes matching card layout
)

### RoleCard (for SignUpScreen)
File: role_card.dart
Container(
  padding: EdgeInsets.all(16),
  decoration: BoxDecoration(
    color: isSelected ? AppColors.primaryLight : AppColors.cardBg,
    borderRadius: BorderRadius.circular(12),
    border: Border.all(
      color: isSelected ? AppColors.primary : AppColors.divider,
      width: isSelected ? 1.5 : 1,
    ),
  ),
  child: Column(mainAxisSize: MainAxisSize.min, children: [
    Icon(icon, color: isSelected ? AppColors.primary : AppColors.textLight, size: 32),
    SizedBox(height: 8),
    Text(role, style: Outfit Medium 14, color: isSelected ? primary : textMedium),
  ]),
)

---

## 16. WEB PLATFORM — ADAPT THE SAME DESIGN

File: apps/web/src/ (React.js 18 + TypeScript)

The web platform uses the SAME color tokens, SAME font (Outfit via Google Fonts),
and SAME spacing as the Flutter app. The difference is layout only — web has
more horizontal space so some screens use 2-column layout on desktop.

Add Outfit to web:
In apps/web/public/index.html, add inside <head>:
```html
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Outfit:wght@400;500;700&display=swap" rel="stylesheet">
```

In apps/web/src/index.css:
```css
* { font-family: 'Outfit', sans-serif; }
body { background-color: #F8F9FA; }
```

CSS variables to add in index.css:
```css
:root {
  --primary: #E8002D;
  --primary-dark: #B0001F;
  --primary-light: #FFEBEE;
  --scaffold-bg: #F8F9FA;
  --card-bg: #FFFFFF;
  --input-fill: #F5F5F5;
  --divider: #EEEEEE;
  --hero-dark: #0F1F2F;
  --hero-mid: #1A2F45;
  --text-dark: #1A1A1A;
  --text-medium: #6B7280;
  --text-light: #BABABA;
  --success: #40C63F;
  --card-shadow: 0 4px 16px rgba(0,0,0,0.06);
  --button-shadow: 0 6px 12px rgba(232,0,45,0.30);
  --border-radius-card: 16px;
  --border-radius-button: 12px;
  --border-radius-input: 12px;
}
```

Web pages mirror the Flutter screens 1:1 in content.
For any screen that is mobile-only (like a full-page booking stepper),
on web it becomes a centered card (max-width: 480px) on a gray background.

The hero section on the web HomePage uses the same gradient (#0F1F2F to #1A2F45),
full-width, height: 480px desktop / 300px mobile.

---

## 17. COMMON ERRORS & FIXES

### flutter_screenutil: "ScreenUtil not initialized"
Fix: Wrap entire app in ScreenUtilInit in main.dart (already done in Section 5).
Never call .w, .h, .sp outside of build context. Do not use ScreenUtil in const constructors.

### google_fonts: "Failed to load Outfit"
Fix: Add Outfit as local asset font in pubspec.yaml (already done in Section 3).
The APK ships these files: copy them to assets/fonts/ from the extracted APK:
/home/claude/roomeego_extracted/assets/flutter_assets/assets/font/Outfit-Regular.ttf
/home/claude/roomeego_extracted/assets/flutter_assets/assets/font/Outfit-Medium.ttf
/home/claude/roomeego_extracted/assets/flutter_assets/assets/font/Outfit-Bold.ttf
Then use: fontFamily: 'Outfit' directly instead of GoogleFonts.outfit().

### flutter_map: tiles not loading (blank white/gray)
Fix 1: Add internet permission to AndroidManifest.xml:
  <uses-permission android:name="android.permission.INTERNET"/>
Fix 2: In TileLayer, set:
  userAgentPackageName: 'al.tefusha'
Fix 3: Test on real device, not emulator — emulator often has DNS issues.

### smooth_page_indicator: dots not updating
Fix: Make sure PageController is created in initState, not in build().
Pass the same controller to both PageView and SmoothPageIndicator.

### IndexedStack: BLoC events not firing when switching tabs
Fix: Wrap each tab in BlocProvider at the IndexedStack level:
```dart
IndexedStack(
  index: _currentIndex,
  children: [
    BlocProvider(create: (_) => getIt<HomeBloc>()..add(LoadHomeEvent()), child: HomeScreen()),
    BlocProvider(create: (_) => getIt<FieldBloc>()..add(LoadFieldsEvent()), child: MostPopularScreen()),
    // etc.
  ],
)
```

### CachedNetworkImage: showing broken image
Fix: Always provide a placeholder and errorWidget:
```dart
CachedNetworkImage(
  imageUrl: field.imageUrl ?? '',
  fit: BoxFit.cover,
  placeholder: (_, __) => Container(color: AppColors.inputFill,
    child: Center(child: CircularProgressIndicator(color: AppColors.primary, strokeWidth: 2))),
  errorWidget: (_, __, ___) => Container(
    color: AppColors.inputFill,
    child: Icon(SportIcons.getIcon(field.lloji_fushes),
      size: 48, color: AppColors.textLight)),
)
```

### GoRouter: back button goes to wrong screen
Fix: Use context.push() when you want to be able to go back.
Use context.go() only for tab changes and post-auth navigation (no back).
Never mix the two on the same screen.

### Pinput: keyboard type not numeric
Fix: Set keyboardType: TextInputType.number on Pinput widget directly.

### Lottie: animation not showing
Fix 1: Check file is in assets/animations/ and declared in pubspec.yaml.
Fix 2: Use Lottie.asset() not Lottie.network() for offline reliability.
Fix 3: If animation plays but is invisible: wrap in SizedBox with explicit width+height.

---

## 18. BUILD & TEST CHECKLIST

**GROUP A — Setup (do before any screen)**
- [ ] pubspec.yaml updated and flutter pub get succeeded
- [ ] Outfit font files copied to assets/fonts/
- [ ] Lottie files placed in assets/animations/
- [ ] app_colors.dart created with exact values from Section 2.2
- [ ] app_sizes.dart created
- [ ] app_shadows.dart created
- [ ] app_theme.dart created (Outfit, Material 2, exact specs from Section 5)
- [ ] main.dart updated with ScreenUtilInit and correct setup
- [ ] app_router.dart created with all 42 routes
- [ ] flutter analyze: 0 errors

**GROUP B — Authentication (S01–S09)**
- [ ] SplashScreen shows Lottie logo and navigates correctly
- [ ] WelcomeScreen shows hero image with two buttons
- [ ] Onboarding 3 slides work, page dots update, skip works
- [ ] LoginScreen form validates email + password, shows loading state
- [ ] Login success navigates to /home
- [ ] Login failure shows Albanian error message
- [ ] SignUpScreen role selector works (Lojtar / Pronar Fushe)
- [ ] OTP screen Pinput shows 6 boxes, submits on completion
- [ ] ForgotPassword → OTP → CreateNewPassword flow works

**GROUP C — Main App UI**
- [ ] BottomNavigationScreen shows 5 tabs, IndexedStack preserves state
- [ ] HomeScreen: dark hero gradient renders, search bar navigates to /search
- [ ] HomeScreen: sport category chips filter the content below
- [ ] FieldCard shows correct image/placeholder, price badge, location
- [ ] FieldDetailScreen: SliverAppBar collapses correctly on scroll
- [ ] FieldDetailScreen: OpenStreetMap loads tiles
- [ ] 'Më jep rrugën' button opens Google Maps on device
- [ ] BookingPage: date strip scrolls, slots load from API
- [ ] Taken slots are visually different and non-tappable
- [ ] BookingConfirmation: Lottie plays once on success

**GROUP D — New Features**
- [ ] AnnouncementFeedScreen: loads feed, filter chips work
- [ ] CreateAnnouncementScreen: type selector colored correctly, submits
- [ ] MyTeamsScreen: empty state shows create button
- [ ] CreateTeamScreen: creates team, navigates back with success
- [ ] EventDetailScreen: bracket widget renders rounds in tabs
- [ ] OwnerDashboardScreen: visible only to pronar_fushe role
- [ ] RegisterFieldScreen: 3-step stepper advances and validates each step
- [ ] OwnerBookingsScreen: confirm/cancel actions work

**GROUP E — Profile & Settings**
- [ ] ProfileScreen hero gradient renders, stats show correctly
- [ ] 'Paneli Im' visible only for pronar_fushe users
- [ ] EditProfileScreen saves changes
- [ ] Logout shows confirmation, clears tokens, navigates to /welcome

**GROUP F — Final Build**
- [ ] flutter analyze: 0 errors, 0 warnings
- [ ] flutter test: all tests pass
- [ ] flutter build apk --release: succeeds
- [ ] APK installs and runs on real Android device
- [ ] All text is in Albanian — zero English visible to end users
- [ ] All screens use Outfit font (verify visually)
- [ ] All cards use shadow, white bg, border radius 16
- [ ] Primary color #E8002D used consistently everywhere

---

*TeFusha SKILL_UI_ROOMEEGO.md — Built from RoomeeGo APK reverse-engineering.*
*Font: Outfit (400/500/700) — extracted from APK FontManifest.json.*
*Colors: #E8002D primary, #0F1F2F hero dark, #F8F9FA scaffold — extracted from APK binary.*
*42 screens total. Build in order. Activate @mobile-app-dev @ui-pro-max before starting.*
*Never deviate from the design system in Section 2. Never use a different font.*
