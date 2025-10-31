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

/// App router configuration using GoRouter
class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(
        path: '/splash',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/sentiment',
        name: 'sentiment',
        builder: (context, state) => const SentimentScreen(),
      ),
      GoRoute(
        path: '/translation',
        name: 'translation',
        builder: (context, state) => const TranslationScreen(),
      ),
      GoRoute(
        path: '/paraphrasing',
        name: 'paraphrasing',
        builder: (context, state) => const ParaphrasingScreen(),
      ),
      GoRoute(
        path: '/ner',
        name: 'ner',
        builder: (context, state) => const NERScreen(),
      ),
      GoRoute(
        path: '/summarization',
        name: 'summarization',
        builder: (context, state) => const SummarizationScreen(),
      ),
      GoRoute(
        path: '/history',
        name: 'history',
        builder: (context, state) => const HistoryScreen(),
      ),
      GoRoute(
        path: '/settings',
        name: 'settings',
        builder: (context, state) => const SettingsScreen(),
      ),
    ],
  );
}

