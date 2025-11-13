import 'package:go_router/go_router.dart';
import '../../features/home/home_screen.dart';
import '../../features/sentiment/sentiment_screen.dart';
import '../../features/translation/translation_screen.dart';
import '../../features/paraphrasing/paraphrasing_screen.dart';
import '../../features/ner/ner_screen.dart';
import '../../features/summarization/summarization_screen.dart';
import '../../features/history/history_screen.dart';
import '../../features/settings/settings_screen.dart';
import '../../features/splash/splash_screen.dart';
import '../constants/api_constants.dart';

/// App router configuration using GoRouter
class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: ApiConstants.routeSplash,
    routes: [
      GoRoute(
        path: ApiConstants.routeSplash,
        name: ApiConstants.routeNameSplash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: ApiConstants.routeHome,
        name: ApiConstants.routeNameHome,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: ApiConstants.routeSentiment,
        name: ApiConstants.routeNameSentiment,
        builder: (context, state) => const SentimentScreen(),
      ),
      GoRoute(
        path: ApiConstants.routeTranslation,
        name: ApiConstants.routeNameTranslation,
        builder: (context, state) => const TranslationScreen(),
      ),
      GoRoute(
        path: ApiConstants.routeParaphrasing,
        name: ApiConstants.routeNameParaphrasing,
        builder: (context, state) => const ParaphrasingScreen(),
      ),
      GoRoute(
        path: ApiConstants.routeNER,
        name: ApiConstants.routeNameNER,
        builder: (context, state) => const NERScreen(),
      ),
      GoRoute(
        path: ApiConstants.routeSummarization,
        name: ApiConstants.routeNameSummarization,
        builder: (context, state) => const SummarizationScreen(),
      ),
      GoRoute(
        path: ApiConstants.routeHistory,
        name: ApiConstants.routeNameHistory,
        builder: (context, state) => const HistoryScreen(),
      ),
      GoRoute(
        path: ApiConstants.routeSettings,
        name: ApiConstants.routeNameSettings,
        builder: (context, state) => const SettingsScreen(),
      ),
    ],
  );
}

