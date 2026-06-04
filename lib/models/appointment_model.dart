import 'package:cloud_firestore/cloud_firestore.dart';

class AppointmentModel {
  const AppointmentModel({
    required this.id,
    required this.uid,
    required this.doctorId,
    required this.doctorName,
    required this.doctorSpeciality,
    required this.patientName,
    required this.age,
    required this.gender,
    required this.issue,
    required this.selectedSlot,
    required this.status,
    this.dob,
    this.bookedAt,
    this.appointmentDate,
  });

  final String id;
  final String uid;
  final String doctorId;
  final String doctorName;
  final String doctorSpeciality;
  final String patientName;
  final String age;
  final String gender;
  final String issue;
  final String selectedSlot;
  final String status;
  final DateTime? dob;
  final DateTime? bookedAt;
  final DateTime? appointmentDate;

  factory AppointmentModel.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    return AppointmentModel.fromMap({...?doc.data(), 'appointmentId': doc.id});
  }

  factory AppointmentModel.fromMap(Map<String, dynamic> data) {
    return AppointmentModel(
      id: data['appointmentId']?.toString() ?? data['id']?.toString() ?? '',
      uid: data['uid']?.toString() ?? '',
      doctorId: data['doctorId']?.toString() ?? '',
      doctorName: data['doctorName']?.toString() ?? 'Doctor',
      doctorSpeciality: data['doctorSpeciality']?.toString() ?? 'Specialist',
      patientName: data['patientName']?.toString() ?? '',
      age: data['age']?.toString() ?? '',
      gender: data['gender']?.toString() ?? '',
      issue: data['issue']?.toString() ?? '',
      selectedSlot: data['selectedSlot']?.toString() ?? '',
      status: data['status']?.toString() ?? 'confirmed',
      dob: _date(data['dob']),
      bookedAt: _date(data['bookedAt']),
      appointmentDate: _date(data['appointmentDate']) ?? _fallbackAppointmentDate(_date(data['bookedAt'])),
    );
  }

  Map<String, dynamic> toLocalMap() {
    return {
      'appointmentId': id,
      'uid': uid,
      'doctorId': doctorId,
      'doctorName': doctorName,
      'doctorSpeciality': doctorSpeciality,
      'patientName': patientName,
      'age': age,
      'gender': gender,
      'dob': dob?.toIso8601String(),
      'issue': issue,
      'selectedSlot': selectedSlot,
      'bookedAt': bookedAt?.toIso8601String(),
      'appointmentDate': appointmentDate?.toIso8601String(),
      'status': status,
    };
  }

  static DateTime? _date(dynamic value) {
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    if (value is String) return DateTime.tryParse(value);
    return null;
  }

  static DateTime? _fallbackAppointmentDate(DateTime? bookedAt) {
    if (bookedAt == null) return null;
    return bookedAt.add(const Duration(days: 3));
  }
}
