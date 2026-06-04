import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/appointment_model.dart';
import '../models/doctor_model.dart';
import '../services/firebase_service.dart';
import '../services/storage_service.dart';

class AppointmentProvider extends ChangeNotifier {
  AppointmentProvider({
    FirebaseService? firebaseService,
    StorageService? storageService,
  })  : _firebase = firebaseService ?? FirebaseService(),
        _storage = storageService ?? StorageService();

  final FirebaseService _firebase;
  final StorageService _storage;
  StreamSubscription<List<AppointmentModel>>? _subscription;

  List<AppointmentModel> appointments = [];
  bool isLoading = false;
  String? errorMessage;
  String selectedGender = 'Male';
  DateTime? selectedDob;
  String? selectedSlot;

  List<AppointmentModel> get upcomingAppointments => appointments.where(_isUpcoming).toList();
  List<AppointmentModel> get pastAppointments => appointments.where((appointment) => !_isUpcoming(appointment)).toList();
  List<AppointmentModel> get recentAppointments => upcomingAppointments.take(2).toList();
  int get totalAppointments => appointments.length;
  DateTime? get lastVisitDate => pastAppointments.isEmpty ? null : pastAppointments.first.appointmentDate;

  void resetBooking(String slot) {
    selectedGender = 'Male';
    selectedDob = null;
    selectedSlot = slot;
    notifyListeners();
  }

  void selectGender(String gender) {
    selectedGender = gender;
    notifyListeners();
  }

  void selectDob(DateTime date) {
    selectedDob = date;
    notifyListeners();
  }

  void selectSlot(String slot) {
    selectedSlot = slot;
    notifyListeners();
  }

  Future<void> loadAppointments() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    isLoading = true;
    notifyListeners();
    try {
      final remote = await _firebase.fetchAppointments(uid);
      final local = (await _storage.getAppointments())
          .map(AppointmentModel.fromMap)
          .where((appointment) => appointment.uid == uid)
          .toList();
      appointments = _merge(remote, local);
      errorMessage = null;
    } catch (error) {
      final local = (await _storage.getAppointments())
          .map(AppointmentModel.fromMap)
          .where((appointment) => appointment.uid == uid)
          .toList();
      appointments = _merge([], local);
      errorMessage = null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void listenAppointments() {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;
    _subscription?.cancel();
    _subscription = _firebase.appointmentsStream(uid).listen(
      (remote) async {
        final local = (await _storage.getAppointments())
            .map(AppointmentModel.fromMap)
            .where((appointment) => appointment.uid == uid)
            .toList();
        appointments = _merge(remote, local);
        notifyListeners();
      },
      onError: (Object error) {
        errorMessage = null;
        notifyListeners();
      },
    );
  }

  Future<Map<String, dynamic>> bookAppointment({
    required DoctorModel doctor,
    required String patientName,
    required String age,
    required String issue,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw StateError('User is not signed in.');
    final slot = selectedSlot ?? doctor.slots.first;
    final appointmentDate = DateTime.now().add(const Duration(days: 3));

    isLoading = true;
    notifyListeners();
    final data = {
      'uid': user.uid,
      'doctorId': doctor.id,
      'doctorName': doctor.name,
      'doctorSpeciality': doctor.speciality,
      'patientName': patientName,
      'age': age,
      'gender': selectedGender,
      'dob': selectedDob == null ? null : Timestamp.fromDate(selectedDob!),
      'issue': issue,
      'selectedSlot': slot,
      'appointmentDate': Timestamp.fromDate(appointmentDate),
      'bookedAt': FieldValue.serverTimestamp(),
      'status': 'confirmed',
    };

    try {
      final id = await _firebase.bookAppointment(data);
      final localData = {
        ...data,
        'appointmentId': id,
        'dob': selectedDob?.toIso8601String(),
        'appointmentDate': appointmentDate.toIso8601String(),
        'bookedAt': DateTime.now().toIso8601String(),
      };
      await _storage.saveAppointment(localData);
      try {
        await loadAppointments();
      } catch (_) {
        appointments = _merge(appointments, [AppointmentModel.fromMap(localData)]);
      }
      return localData;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  List<AppointmentModel> _merge(List<AppointmentModel> remote, List<AppointmentModel> local) {
    final map = <String, AppointmentModel>{};
    for (final appointment in [...local, ...remote]) {
      final key = appointment.id.isEmpty ? '${appointment.doctorId}-${appointment.selectedSlot}-${appointment.patientName}' : appointment.id;
      map[key] = appointment;
    }
    final merged = map.values.toList();
    merged.sort((a, b) {
      final left = a.appointmentDate ?? a.bookedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      final right = b.appointmentDate ?? b.bookedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      return right.compareTo(left);
    });
    return merged;
  }

  bool _isUpcoming(AppointmentModel appointment) {
    final appointmentDate = appointment.appointmentDate ?? appointment.bookedAt;
    if (appointmentDate == null) return true;
    final today = DateTime.now();
    final todayStart = DateTime(today.year, today.month, today.day);
    final appointmentDay = DateTime(appointmentDate.year, appointmentDate.month, appointmentDate.day);
    return !appointmentDay.isBefore(todayStart);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
