import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../utils/constants.dart';

class StorageService {
  Future<void> saveAppointment(Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    final appointments = await getAppointments();
    final id = data['appointmentId']?.toString() ?? data['id']?.toString();
    final filtered = appointments.where((item) {
      final itemId = item['appointmentId']?.toString() ?? item['id']?.toString();
      return id == null || itemId != id;
    }).toList();
    filtered.insert(0, data);
    await prefs.setString(AppConstants.localAppointmentsKey, jsonEncode(filtered));
  }

  Future<List<Map<String, dynamic>>> getAppointments() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(AppConstants.localAppointmentsKey);
    if (raw == null || raw.isEmpty) return [];
    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded.map((item) => Map<String, dynamic>.from(item as Map)).toList();
  }

  Future<void> saveThemeMode(String mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.themeModeKey, mode);
  }

  Future<String> getThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(AppConstants.themeModeKey) ?? 'system';
  }

  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.localAppointmentsKey);
  }
}
