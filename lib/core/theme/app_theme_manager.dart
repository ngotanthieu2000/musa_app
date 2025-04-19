import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'app_theme_manager.freezed.dart';

@freezed
class ThemeState with _$ThemeState {
  const factory ThemeState({
    required ThemeMode themeMode,
  }) = _ThemeState;

  factory ThemeState.initial() => const ThemeState(themeMode: ThemeMode.system);
}

class ThemeCubit extends Cubit<ThemeState> {
  final SharedPreferences _prefs;
  static const String _themeKey = 'theme_preference';

  ThemeCubit(this._prefs) : super(ThemeState.initial()) {
    _loadTheme();
  }

  void _loadTheme() {
    final String? themeStr = _prefs.getString(_themeKey);
    if (themeStr != null) {
      ThemeMode themeMode;
      switch (themeStr) {
        case 'light':
          themeMode = ThemeMode.light;
          break;
        case 'dark':
          themeMode = ThemeMode.dark;
          break;
        default:
          themeMode = ThemeMode.system;
      }
      emit(state.copyWith(themeMode: themeMode));
    }
  }

  Future<void> setThemeMode(ThemeMode themeMode) async {
    String themeStr;
    switch (themeMode) {
      case ThemeMode.light:
        themeStr = 'light';
        break;
      case ThemeMode.dark:
        themeStr = 'dark';
        break;
      case ThemeMode.system:
        themeStr = 'system';
        break;
    }
    
    await _prefs.setString(_themeKey, themeStr);
    emit(state.copyWith(themeMode: themeMode));
  }

  Future<void> toggleTheme() async {
    ThemeMode newThemeMode;
    
    switch (state.themeMode) {
      case ThemeMode.light:
        newThemeMode = ThemeMode.dark;
        break;
      case ThemeMode.dark:
        newThemeMode = ThemeMode.system;
        break;
      case ThemeMode.system:
        newThemeMode = ThemeMode.light;
        break;
    }
    
    await setThemeMode(newThemeMode);
  }
} 