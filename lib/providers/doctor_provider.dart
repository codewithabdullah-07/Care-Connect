import 'dart:async';

import 'package:flutter/material.dart';

import '../models/doctor_model.dart';
import '../services/firebase_service.dart';

class DoctorProvider extends ChangeNotifier {
  DoctorProvider({FirebaseService? firebaseService}) : _firebase = firebaseService ?? FirebaseService();

  final FirebaseService _firebase;
  StreamSubscription<List<DoctorModel>>? _subscription;
  List<DoctorModel> _doctors = DoctorModel.providedDoctors;
  String _searchQuery = '';
  String? errorMessage;
  bool isLoading = false;

  List<DoctorModel> get doctors {
    if (_searchQuery.isEmpty) return _doctors;
    final query = _searchQuery.toLowerCase();
    return _doctors
        .where((doctor) => doctor.name.toLowerCase().contains(query) || doctor.speciality.toLowerCase().contains(query))
        .toList();
  }

  void listenDoctors() {
    _subscription?.cancel();
    isLoading = _doctors.isEmpty;
    notifyListeners();
    _subscription = _firebase.doctorsStream().listen(
      (items) {
        _doctors = items.isEmpty ? DoctorModel.providedDoctors : items;
        isLoading = false;
        errorMessage = null;
        notifyListeners();
      },
      onError: (Object error) {
        _doctors = DoctorModel.providedDoctors;
        errorMessage = null;
        isLoading = false;
        notifyListeners();
      },
    );
  }

  void updateSearch(String value) {
    _searchQuery = value.trim();
    notifyListeners();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
