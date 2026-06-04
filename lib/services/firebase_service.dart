import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/appointment_model.dart';
import '../models/doctor_model.dart';

class FirebaseService {
  FirebaseService({
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
  })  : auth = auth ?? FirebaseAuth.instance,
        firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  User? get currentUser => auth.currentUser;

  Stream<List<DoctorModel>> doctorsStream() {
    return firestore.collection('doctors').snapshots().map(
          (snapshot) => snapshot.docs.map(DoctorModel.fromDoc).toList(),
        );
  }

  Stream<List<AppointmentModel>> appointmentsStream(String uid) {
    return firestore
        .collection('appointments')
        .where('uid', isEqualTo: uid)
        .snapshots()
        .map((snapshot) => _sortAppointments(snapshot.docs.map(AppointmentModel.fromDoc).toList()));
  }

  Future<List<AppointmentModel>> fetchAppointments(String uid) async {
    final snapshot = await firestore
        .collection('appointments')
        .where('uid', isEqualTo: uid)
        .get();
    return _sortAppointments(snapshot.docs.map(AppointmentModel.fromDoc).toList());
  }

  Future<String> bookAppointment(Map<String, dynamic> data) async {
    final doc = await firestore.collection('appointments').add(data);
    return doc.id;
  }

  Future<bool> updateWelcomeState() async {
    final user = auth.currentUser;
    if (user == null) return false;

    final userRef = firestore.collection('users').doc(user.uid);
    final doc = await userRef.get();
    if (!doc.exists) {
      await userRef.set({
        'uid': user.uid,
        'phoneNumber': user.phoneNumber,
        'createdAt': FieldValue.serverTimestamp(),
        'lastLogin': FieldValue.serverTimestamp(),
      });
      return true;
    }

    await userRef.update({'lastLogin': FieldValue.serverTimestamp()});
    return false;
  }

  List<AppointmentModel> _sortAppointments(List<AppointmentModel> appointments) {
    appointments.sort((a, b) {
      final left = a.bookedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      final right = b.bookedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      return right.compareTo(left);
    });
    return appointments;
  }
}
