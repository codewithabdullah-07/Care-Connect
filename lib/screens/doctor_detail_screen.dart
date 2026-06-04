import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/doctor_model.dart';
import '../providers/appointment_provider.dart';
import '../utils/colors.dart';
import '../widgets/slot_chip.dart';
import 'book_appointment_screen.dart';

class DoctorDetailScreen extends StatefulWidget {
  const DoctorDetailScreen({super.key, required this.doctor});

  final DoctorModel doctor;

  @override
  State<DoctorDetailScreen> createState() => _DoctorDetailScreenState();
}

class _DoctorDetailScreenState extends State<DoctorDetailScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<AppointmentProvider>().selectSlot(widget.doctor.slots.first));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Doctor Details')),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton(
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => BookAppointmentScreen(doctor: widget.doctor))),
            child: const Text('Book Appointment'),
          ),
        ),
      ),
      body: ListView(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 28),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [AppColors.plum, AppColors.plumGradientEnd],
              ),
            ),
            child: Column(
              children: [
                Container(
                  width: 124,
                  height: 124,
                  padding: const EdgeInsets.all(3),
                  decoration: const BoxDecoration(color: AppColors.gold, shape: BoxShape.circle),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(62),
                    child: _DoctorDetailImage(imageUrl: widget.doctor.imageUrl),
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  widget.doctor.name,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: AppColors.ivory, fontSize: 24),
                ),
                Text(
                  widget.doctor.speciality,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.darkTextSecondary),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(child: _InfoChip(label: 'Experience', value: widget.doctor.experience)),
                    const SizedBox(width: 8),
                    Expanded(child: _InfoChip(label: 'Patients', value: '${widget.doctor.patientsCount}+')),
                    const SizedBox(width: 8),
                    Expanded(child: _InfoChip(label: 'Rating', value: widget.doctor.rating.toStringAsFixed(1))),
                  ],
                ),
                const SizedBox(height: 24),
                Text('About', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 8),
                Text(widget.doctor.about, style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: 24),
                Text('Time slots', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 12),
                Consumer<AppointmentProvider>(
                  builder: (context, provider, child) {
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: widget.doctor.slots
                            .map(
                              (slot) => Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: SlotChip(
                                  slot: slot,
                                  selected: provider.selectedSlot == slot,
                                  onTap: () => provider.selectSlot(slot),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DoctorDetailImage extends StatelessWidget {
  const _DoctorDetailImage({required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    if (imageUrl.startsWith('assets/')) {
      return Image.asset(
        imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => const Icon(Icons.person, color: Colors.white, size: 54),
      );
    }

    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: BoxFit.cover,
      errorWidget: (context, url, error) => const Icon(Icons.person, color: Colors.white, size: 54),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.gold.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(value, style: const TextStyle(color: AppColors.gold, fontWeight: FontWeight.w600)),
          Text(label, style: Theme.of(context).textTheme.bodyMedium, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
