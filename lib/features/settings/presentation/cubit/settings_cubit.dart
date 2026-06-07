import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:business_card/core/constants/app_constants.dart';

class SettingsState {
  final ThemeMode themeMode;
  final String languageCode;

  const SettingsState({
    this.themeMode = ThemeMode.system,
    this.languageCode = 'en',
  });

  SettingsState copyWith({ThemeMode? themeMode, String? languageCode}) {
    return SettingsState(
      themeMode: themeMode ?? this.themeMode,
      languageCode: languageCode ?? this.languageCode,
    );
  }
}

class SettingsCubit extends Cubit<SettingsState> {
  final SharedPreferences _prefs;

  SettingsCubit(this._prefs) : super(const SettingsState()) {
    _loadSettings();
  }

  void _loadSettings() {
    final themeIndex = _prefs.getInt(AppConstants.themeKey) ?? 0;
    final lang = _prefs.getString(AppConstants.languageKey) ?? 'en';

    emit(SettingsState(
      themeMode: ThemeMode.values[themeIndex],
      languageCode: lang,
    ));
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    await _prefs.setInt(AppConstants.themeKey, mode.index);
    emit(state.copyWith(themeMode: mode));
  }

  Future<void> setLanguage(String code) async {
    await _prefs.setString(AppConstants.languageKey, code);
    emit(state.copyWith(languageCode: code));
  }
}
