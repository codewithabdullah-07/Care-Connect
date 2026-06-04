import 'package:cloud_firestore/cloud_firestore.dart';

import '../utils/constants.dart';

class DoctorModel {
  const DoctorModel({
    required this.id,
    required this.name,
    required this.speciality,
    required this.imageUrl,
    required this.rating,
    required this.available,
    required this.experience,
    required this.patientsCount,
    required this.about,
    required this.slots,
  });

  final String id;
  final String name;
  final String speciality;
  final String imageUrl;
  final double rating;
  final bool available;
  final String experience;
  final int patientsCount;
  final String about;
  final List<String> slots;

  factory DoctorModel.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    return DoctorModel(
      id: doc.id,
      name: data['name']?.toString() ?? 'Doctor',
      speciality: data['speciality']?.toString() ?? data['specialty']?.toString() ?? 'General Physician',
      imageUrl: data['imageUrl']?.toString() ?? '',
      rating: (data['rating'] as num?)?.toDouble() ?? 4.8,
      available: data['available'] as bool? ?? true,
      experience: data['experience']?.toString() ?? '5 years',
      patientsCount: (data['patientsCount'] as num?)?.toInt() ?? (data['patients'] as num?)?.toInt() ?? 120,
      about: data['about']?.toString() ?? 'Compassionate care with a patient-first approach.',
      slots: (data['slots'] as List<dynamic>?)?.map((slot) => slot.toString()).toList() ?? AppConstants.defaultSlots,
    );
  }

  static const providedDoctors = [
    DoctorModel(
      id: 'dr-sumera-nawaz',
      name: 'Dr. Sumera Nawaz - MBBS, MCPS, MD (Internal Med)',
      speciality: 'Assistant Professor, Medicine',
      imageUrl: 'assets/doctors/dr_sumera_nawaz.webp',
      rating: 4.8,
      available: true,
      experience: '11 years',
      patientsCount: 980,
      about:
          'Dr. Sumera Nawaz is an Assistant Professor in Medicine with clinical expertise in internal medicine, routine medical care, and patient follow-ups.',
      slots: ['09:00 AM', '10:30 AM', '12:00 PM', '03:00 PM', '05:00 PM'],
    ),
    DoctorModel(
      id: 'dr-nadeem-baloch',
      name: 'Dr. Nadeem A Baloch',
      speciality: 'Professor, Orthopedics',
      imageUrl: 'assets/doctors/dr_nadeem_baloch.webp',
      rating: 4.7,
      available: true,
      experience: '14 years',
      patientsCount: 1250,
      about:
          'Dr. Nadeem A Baloch is listed as Professor in Orthopedics, providing orthopedic consultation and musculoskeletal care.',
      slots: ['09:30 AM', '11:00 AM', '01:00 PM', '04:00 PM', '06:00 PM'],
    ),
    DoctorModel(
      id: 'dr-muhammad-nauman-zahir',
      name: 'Dr. Muhammad Nauman Zahir - MBBS, FCPS (Internal Medicine), FCPS (Medical Oncology), FACP, SCE Medical Oncology (UK)',
      speciality: 'Associate Professor, Medical Oncology',
      imageUrl: 'assets/doctors/dr_muhammad_nauman_zahir.webp',
      rating: 4.9,
      available: true,
      experience: '12 years',
      patientsCount: 1430,
      about:
          'Dr. Muhammad Nauman Zahir is an Associate Professor in Medical Oncology with training in internal medicine, medical oncology, and UK SCE certification.',
      slots: ['10:00 AM', '11:30 AM', '02:00 PM', '04:30 PM', '06:30 PM'],
    ),
    DoctorModel(
      id: 'dr-heena-rais',
      name: 'Dr. Heena Rais - MBBS, FCPS (PAEDS)',
      speciality: 'Associate Professor, Paediatrics',
      imageUrl: 'assets/doctors/dr_heena_rais.webp',
      rating: 4.8,
      available: true,
      experience: '9 years',
      patientsCount: 870,
      about:
          'Dr. Heena Rais is an Associate Professor in Paediatrics, providing pediatric consultation and child health care.',
      slots: ['09:00 AM', '12:30 PM', '02:30 PM', '05:00 PM', '07:00 PM'],
    ),
    DoctorModel(
      id: 'dr-atif-mansha',
      name: 'Dr. Atif Mansha - MBBS, FCPS',
      speciality: 'Consultant Medical Oncologist',
      imageUrl: 'assets/doctors/dr_atif_mansha.jpeg',
      rating: 4.7,
      available: true,
      experience: '10 years',
      patientsCount: 760,
      about:
          'Dr. Atif Mansha is a Consultant Medical Oncologist with clinical interest in solid tumor oncology and evidence-based cancer care.',
      slots: ['10:00 AM', '12:00 PM', '03:30 PM', '05:30 PM', '07:30 PM'],
    ),
    DoctorModel(
      id: 'dr-adnan-abdul-jabbar',
      name: 'Dr. Adnan Abdul Jabbar - MBBS, MD, Ph.D., Diplomate American Board of Internal Medicine, Diplomate American Board of Medical Oncology',
      speciality: 'Professor Medical Oncology & Chairman, Department of Oncology',
      imageUrl: 'assets/doctors/dr_adnan_abdul_jabbar.png',
      rating: 4.9,
      available: true,
      experience: '16 years',
      patientsCount: 1520,
      about:
          'Dr. Adnan Abdul Jabbar is Professor of Medical Oncology and Chairman of the Department of Oncology, with American Board credentials in internal medicine and medical oncology.',
      slots: ['09:30 AM', '11:30 AM', '01:30 PM', '04:00 PM', '06:00 PM'],
    ),
  ];
}
