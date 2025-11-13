import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_cubit.dart';
import 'core/theme/theme_state.dart';
import 'core/routing/app_router.dart';

/// Main entry point of LinguaSense app
void main() {
  runApp(const LinguaSenseApp());
}

/// Root widget of the app
class LinguaSenseApp extends StatelessWidget {
  const LinguaSenseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ThemeCubit(),
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) {
          final themeMode = state is ThemeLoaded
              ? state.themeMode
              : ThemeMode.system;

          return MaterialApp.router(
            title: 'LinguaSense',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeMode,
            routerConfig: AppRouter.router,
          );
        },
      ),
    );
  }
}
