import 'package:go_router/go_router.dart';
import 'package:business_card/features/business_card/presentation/screens/create_card_screen.dart';
import 'package:business_card/features/business_card/presentation/screens/card_preview_screen.dart';
import 'package:business_card/features/qr/presentation/screens/qr_screen.dart';
import 'package:business_card/features/nfc/presentation/screens/nfc_screen.dart';
import 'package:business_card/features/settings/presentation/screens/settings_screen.dart';

abstract final class AppRouter {
  static const String createCard = '/create-card';
  static const String cardPreview = '/card-preview';
  static const String qr = '/qr';
  static const String nfc = '/nfc';
  static const String settings = '/settings';

  static final GoRouter router = GoRouter(
    initialLocation: cardPreview,
    routes: [
      GoRoute(
        path: cardPreview,
        name: 'cardPreview',
        builder: (context, state) => const CardPreviewScreen(),
      ),
      GoRoute(
        path: createCard,
        name: 'createCard',
        builder: (context, state) => const CreateCardScreen(),
      ),
      GoRoute(
        path: qr,
        name: 'qr',
        builder: (context, state) => const QRScreen(),
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
    ],
  );
}
