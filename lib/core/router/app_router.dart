import 'package:go_router/go_router.dart';
import 'package:business_card/features/analytics/presentation/screens/analytics_dashboard_screen.dart';
import 'package:business_card/features/business_card/domain/entities/business_card.dart';
import 'package:business_card/features/business_card/presentation/screens/home_screen.dart';
import 'package:business_card/features/business_card/presentation/screens/create_card_screen.dart';
import 'package:business_card/features/business_card/presentation/screens/card_preview_screen.dart';
import 'package:business_card/features/qr/presentation/screens/qr_screen.dart';
import 'package:business_card/features/qr/presentation/screens/qr_scanner_screen.dart';
import 'package:business_card/features/nfc/presentation/screens/nfc_screen.dart';
import 'package:business_card/features/settings/presentation/screens/settings_screen.dart';
import 'package:business_card/features/templates/presentation/screens/template_gallery_screen.dart';

abstract final class AppRouter {
  static const String home = '/';
  static const String createCard = '/create-card';
  static const String cardPreview = '/card-preview';
  static const String qr = '/qr';
  static const String qrScanner = '/qr-scanner';
  static const String nfc = '/nfc';
  static const String settings = '/settings';
  static const String templateGallery = '/template-gallery';
  static const String analytics = '/analytics';

  static final GoRouter router = GoRouter(
    initialLocation: home,
    routes: [
      GoRoute(
        path: home,
        name: 'home',
        builder: (context, state) => HomeScreen(initialTab: state.extra as int? ?? 0),
      ),
      GoRoute(
        path: cardPreview,
        name: 'cardPreview',
        builder: (context, state) => const CardPreviewScreen(),
      ),
      GoRoute(
        path: createCard,
        name: 'createCard',
        builder: (context, state) {
          final existingCard = state.extra as BusinessCard?;
          return CreateCardScreen(existingCard: existingCard);
        },
      ),
      GoRoute(
        path: qr,
        name: 'qr',
        builder: (context, state) => const QRScreen(),
      ),
      GoRoute(
        path: qrScanner,
        name: 'qrScanner',
        builder: (context, state) => const QrScannerScreen(),
      ),
      GoRoute(
        path: nfc,
        name: 'nfc',
        builder: (context, state) => const NfcScreen(),
      ),
      GoRoute(
        path: settings,
        name: 'settings',
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: templateGallery,
        name: 'templateGallery',
        builder: (context, state) {
          final selectedId = state.extra as String?;
          return TemplateGalleryScreen(selectedId: selectedId);
        },
      ),
      GoRoute(
        path: analytics,
        name: 'analytics',
        builder: (context, state) => const AnalyticsDashboardScreen(),
      ),
    ],
  );
}
