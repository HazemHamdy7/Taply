import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:business_card/core/l10n/app_localizations.dart';
import 'package:business_card/features/settings/presentation/cubit/settings_cubit.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.settings)),
      body: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                      child:                       Text(AppLocalizations.of(context)!.appearance,
                          style: theme.textTheme.titleMedium),
                    ),
                    SwitchListTile(
                      title: Text(AppLocalizations.of(context)!.darkMode),
                      subtitle: Text(
                        state.themeMode == ThemeMode.dark
                            ? AppLocalizations.of(context)!.darkModeEnabled
                            : state.themeMode == ThemeMode.light
                                ? AppLocalizations.of(context)!.lightModeEnabled
                                : AppLocalizations.of(context)!.followSystem,
                      ),
                      value: state.themeMode == ThemeMode.dark,
                      onChanged: (value) {
                        context.read<SettingsCubit>().setThemeMode(
                          value ? ThemeMode.dark : ThemeMode.light,
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                      child:                       Text(AppLocalizations.of(context)!.language,
                          style: theme.textTheme.titleMedium),
                    ),
                    RadioGroup<String>(
                      groupValue: state.languageCode,
                      onChanged: (v) {
                        if (v != null) {
                          context.read<SettingsCubit>().setLanguage(v);
                        }
                      },
                      child: Column(
                        children: [
                          RadioListTile<String>(
                            title: Text(AppLocalizations.of(context)!.english),
                            subtitle: Text(AppLocalizations.of(context)!.englishLanguage),
                            value: 'en',
                          ),
                          RadioListTile<String>(
                            title: const Text('العربية'),
                            subtitle: Text(AppLocalizations.of(context)!.arabicLanguage),
                            value: 'ar',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.analytics_outlined),
                  title: const Text('Analytics'),
                  subtitle: const Text('View usage statistics'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push('/analytics'),
                ),
              ),
              const SizedBox(height: 32),
              Center(
                child: Text(
                  AppLocalizations.of(context)!.version,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.disabledColor,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
