import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  const UserModel({
    required this.uid,
    required this.phoneNumber,
    this.createdAt,
    this.lastLogin,
  });

  final String uid;
  final String? phoneNumber;
  final DateTime? createdAt;
  final DateTime? lastLogin;

  factory UserModel.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    return UserModel(
      uid: data['uid']?.toString() ?? doc.id,
      phoneNumber: data['phoneNumber']?.toString(),
      createdAt: _date(data['createdAt']),
      lastLogin: _date(data['lastLogin']),
    );
  }

  static DateTime? _date(dynamic value) {
    if (value is Timestamp) return value.toDate();
    if (value is String) return DateTime.tryParse(value);
    return null;
  }
}
