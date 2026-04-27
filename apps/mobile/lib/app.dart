import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';
import 'core/di/injection.dart';
import 'presentation/auth/bloc/auth_bloc.dart';
import 'presentation/fields/bloc/field_bloc.dart';
import 'presentation/community/bloc/announcement_bloc.dart';
import 'presentation/events/bloc/event_bloc.dart';
import 'presentation/teams/bloc/standalone_team_bloc.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthBloc(getIt())),
        BlocProvider(create: (context) => FieldBloc(getIt())),
        BlocProvider(create: (context) => AnnouncementBloc(getIt())),
        BlocProvider(create: (context) => EventBloc(getIt())),
        BlocProvider(create: (context) => StandaloneTeamBloc(getIt())),
      ],
      child: ScreenUtilInit(
        designSize: const Size(375, 812), // iPhone X/11/12/13/14 size
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp.router(
            title: 'TeFusha',
            theme: AppTheme.light,
            routerConfig: appRouter,
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
