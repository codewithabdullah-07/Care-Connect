import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/appointment_model.dart';
import '../providers/appointment_provider.dart';
import '../utils/colors.dart';
import '../widgets/appointment_card.dart';

class AppointmentHistoryScreen extends StatefulWidget {
  const AppointmentHistoryScreen({super.key});

  @override
  State<AppointmentHistoryScreen> createState() =>
      _AppointmentHistoryScreenState();
}

class _AppointmentHistoryScreenState extends State<AppointmentHistoryScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<AppointmentProvider>().listenAppointments();
      context.read<AppointmentProvider>().loadAppointments();
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Appointments'),
          bottom: TabBar(
            indicatorColor: AppColors.gold,
            labelColor: AppColors.gold,
            unselectedLabelColor: AppColors.ivory.withValues(alpha: 0.62),
            tabs: const [
              Tab(text: 'Upcoming'),
              Tab(text: 'Past'),
            ],
          ),
        ),
        body: Consumer<AppointmentProvider>(
          builder: (context, provider, child) {
            return TabBarView(
              children: [
                _AppointmentList(
                  appointments: provider.upcomingAppointments,
                  emptyText: 'No upcoming appointments',
                  onRefresh: provider.loadAppointments,
                ),
                _AppointmentList(
                  appointments: provider.pastAppointments,
                  emptyText: 'No past appointments yet',
                  onRefresh: provider.loadAppointments,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _AppointmentList extends StatelessWidget {
  const _AppointmentList({
    required this.appointments,
    required this.emptyText,
    required this.onRefresh,
  });

  final List<AppointmentModel> appointments;
  final String emptyText;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: appointments.isEmpty
          ? ListView(
              padding: const EdgeInsets.all(32),
              children: [
                const SizedBox(height: 120),
                Center(
                  child: Container(
                    width: 82,
                    height: 82,
                    decoration: BoxDecoration(
                      color: AppColors.gold.withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: const Icon(
                      Icons.event_busy_outlined,
                      color: AppColors.gold,
                      size: 42,
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  emptyText,
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 6),
                Text(
                  'Your appointment timeline will appear here after booking.',
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ],
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: appointments.length,
              itemBuilder: (context, index) =>
                  AppointmentCard(appointment: appointments[index]),
            ),
    );
  }
}
