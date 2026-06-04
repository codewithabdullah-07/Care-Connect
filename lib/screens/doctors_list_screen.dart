import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/doctor_provider.dart';
import '../utils/colors.dart';
import '../widgets/doctor_card.dart';
import 'doctor_detail_screen.dart';

class DoctorsListScreen extends StatefulWidget {
  const DoctorsListScreen({super.key});

  @override
  State<DoctorsListScreen> createState() => _DoctorsListScreenState();
}

class _DoctorsListScreenState extends State<DoctorsListScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<DoctorProvider>().listenDoctors());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Find a Doctor'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(72),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 14),
            child: TextField(
              onChanged: context.read<DoctorProvider>().updateSearch,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search, color: AppColors.gold),
                hintText: 'Search by name or speciality',
              ),
            ),
          ),
        ),
      ),
      body: Consumer<DoctorProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.gold),
            );
          }

          if (provider.errorMessage != null) {
            return _DoctorListState(
              icon: Icons.error_outline,
              title: 'Unable to load doctors',
              message: provider.errorMessage!,
            );
          }

          if (provider.doctors.isEmpty) {
            return const _DoctorListState(
              icon: Icons.manage_search_outlined,
              title: 'No doctors found',
              message: 'Try a different name or speciality.',
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(24),
            itemCount: provider.doctors.length,
            itemBuilder: (context, index) {
              final doctor = provider.doctors[index];
              return DoctorCard(
                doctor: doctor,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DoctorDetailScreen(doctor: doctor),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _DoctorListState extends StatelessWidget {
  const _DoctorListState({
    required this.icon,
    required this.title,
    required this.message,
  });

  final IconData icon;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 76,
              height: 76,
              decoration: BoxDecoration(
                color: AppColors.gold.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(icon, color: AppColors.gold, size: 38),
            ),
            const SizedBox(height: 18),
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
