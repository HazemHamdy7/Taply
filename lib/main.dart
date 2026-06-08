import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:business_card/core/di/service_locator.dart';
import 'package:business_card/core/l10n/app_localizations.dart';
import 'package:business_card/core/router/app_router.dart';
import 'package:business_card/core/theme/app_theme.dart';
import 'package:business_card/features/business_card/presentation/cubit/business_card_cubit.dart';
import 'package:business_card/features/categories/presentation/cubit/category_cubit.dart';
import 'package:business_card/features/nfc/presentation/cubit/nfc_cubit.dart';
import 'package:business_card/features/scanned_cards/presentation/cubit/scanned_card_cubit.dart';
import 'package:business_card/features/settings/presentation/cubit/settings_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  runApp(const BusinessCardApp());
}

class BusinessCardApp extends StatelessWidget {
  const BusinessCardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SettingsCubit>(create: (_) => sl<SettingsCubit>()),
        BlocProvider<BusinessCardCubit>(create: (_) => sl<BusinessCardCubit>()),
        BlocProvider<ScannedCardCubit>(create: (_) => sl<ScannedCardCubit>()),
        BlocProvider<CategoryCubit>(create: (_) => sl<CategoryCubit>()),
        BlocProvider<NfcCubit>(create: (_) => sl<NfcCubit>()),
      ],
      child: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, settings) {
          return Directionality(
            textDirection: settings.languageCode == 'ar'
                ? TextDirection.rtl
                : TextDirection.ltr,
            child: MaterialApp.router(
              title: AppLocalizations.of(context)?.appTitle ?? 'Digital Business Card',
              debugShowCheckedModeBanner: false,
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: settings.themeMode,
              locale: Locale(settings.languageCode),
              supportedLocales: AppLocalizations.supportedLocales,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              localeResolutionCallback: (locale, supportedLocales) {
                if (locale != null) {
                  for (final supported in supportedLocales) {
                    if (supported.languageCode == locale.languageCode) {
                      return supported;
                    }
                  }
                }
                return supportedLocales.first;
              },
              routerConfig: AppRouter.router,
            ),
          );
        },
      ),
    );
  }
}
