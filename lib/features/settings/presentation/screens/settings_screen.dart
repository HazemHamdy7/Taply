import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:business_card/features/settings/presentation/cubit/settings_cubit.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
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
                      child: Text('Appearance',
                          style: theme.textTheme.titleMedium),
                    ),
                    SwitchListTile(
                      title: const Text('Dark Mode'),
                      subtitle: Text(
                        state.themeMode == ThemeMode.dark
                            ? 'Dark mode is enabled'
                            : state.themeMode == ThemeMode.light
                                ? 'Light mode is enabled'
                                : 'Follow system setting',
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
                      child: Text('Language',
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
                            title: const Text('English'),
                            subtitle: const Text('English language'),
                            value: 'en',
                          ),
                          RadioListTile<String>(
                            title: const Text('العربية'),
                            subtitle: const Text('اللغة العربية'),
                            value: 'ar',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              Center(
                child: Text(
                  'Digital Business Card v1.0.0',
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
