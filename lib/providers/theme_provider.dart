import 'package:flutter/material.dart';

import '../services/storage_service.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeProvider({StorageService? storageService}) : _storage = storageService ?? StorageService();

  final StorageService _storage;
  ThemeMode _themeMode = ThemeMode.system;
  String _modeName = 'system';

  ThemeMode get themeMode => _themeMode;
  String get modeName => _modeName;

  Future<void> loadThemeMode() async {
    _modeName = await _storage.getThemeMode();
    _themeMode = _fromString(_modeName);
    notifyListeners();
  }

  Future<void> setThemeMode(String mode) async {
    _modeName = mode;
    _themeMode = _fromString(mode);
    await _storage.saveThemeMode(mode);
    notifyListeners();
  }

  ThemeMode _fromString(String mode) {
    return switch (mode) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
  }
}
