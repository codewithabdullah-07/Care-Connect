import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/doctor_model.dart';
import '../providers/appointment_provider.dart';
import '../utils/colors.dart';
import 'confirmation_screen.dart';

class BookAppointmentScreen extends StatefulWidget {
  const BookAppointmentScreen({super.key, required this.doctor});

  final DoctorModel doctor;

  @override
  State<BookAppointmentScreen> createState() => _BookAppointmentScreenState();
}

class _BookAppointmentScreenState extends State<BookAppointmentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _issueController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => context.read<AppointmentProvider>().resetBooking(
        widget.doctor.slots.first,
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _issueController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Book Appointment')),
      body: Consumer<AppointmentProvider>(
        builder: (context, provider, child) {
          return Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Theme.of(context).dividerColor),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _Label('Patient name'),
                      TextFormField(
                        controller: _nameController,
                        validator: (value) =>
                            value == null || value.trim().isEmpty
                            ? 'Enter patient name'
                            : null,
                      ),
                      const SizedBox(height: 16),
                      _Label('Age'),
                      TextFormField(
                        controller: _ageController,
                        keyboardType: TextInputType.number,
                        validator: (value) =>
                            value == null || value.trim().isEmpty
                            ? 'Enter age'
                            : null,
                      ),
                      const SizedBox(height: 16),
                      _Label('Gender'),
                      Row(
                        children: ['Male', 'Female', 'Other']
                            .map(
                              (gender) => _GenderChip(
                                gender: gender,
                                selected: provider.selectedGender == gender,
                                onSelected: () => provider.selectGender(gender),
                              ),
                            )
                            .toList(),
                      ),
                      const SizedBox(height: 16),
                      _Label('Date of birth'),
                      InkWell(
                        onTap: () async {
                          final now = DateTime.now();
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: DateTime(now.year - 25),
                            firstDate: DateTime(1900),
                            lastDate: now,
                            builder: (context, child) {
                              return Theme(
                                data: Theme.of(context).copyWith(
                                  colorScheme: Theme.of(context).colorScheme
                                      .copyWith(primary: AppColors.gold),
                                ),
                                child: child!,
                              );
                            },
                          );
                          if (picked != null && context.mounted)
                            provider.selectDob(picked);
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: InputDecorator(
                          decoration: const InputDecoration(
                            suffixIcon: Icon(
                              Icons.calendar_today_outlined,
                              color: AppColors.gold,
                            ),
                          ),
                          child: Text(
                            provider.selectedDob == null
                                ? 'Select date'
                                : DateFormat(
                                    'MMM d, yyyy',
                                  ).format(provider.selectedDob!),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      _Label('Describe your issue'),
                      TextFormField(
                        controller: _issueController,
                        minLines: 4,
                        maxLines: 6,
                        validator: (value) =>
                            value == null || value.trim().isEmpty
                            ? 'Describe your issue'
                            : null,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: provider.isLoading ? null : () => _book(context),
                  child: provider.isLoading
                      ? SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            color: Theme.of(context).colorScheme.onPrimary,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text('Book Appointment'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _book(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;
    try {
      final data = await context.read<AppointmentProvider>().bookAppointment(
        doctor: widget.doctor,
        patientName: _nameController.text.trim(),
        age: _ageController.text.trim(),
        issue: _issueController.text.trim(),
      );
      if (!context.mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ConfirmationScreen(appointmentData: data),
        ),
      );
    } catch (error) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error.toString())));
    }
  }
}

class _Label extends StatelessWidget {
  const _Label(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(text, style: Theme.of(context).textTheme.titleMedium),
    );
  }
}

class _GenderChip extends StatelessWidget {
  const _GenderChip({
    required this.gender,
    required this.selected,
    required this.onSelected,
  });

  final String gender;
  final bool selected;
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(right: gender == 'Other' ? 0 : 8),
        child: ChoiceChip(
          label: SizedBox(
            width: double.infinity,
            child: Text(gender, textAlign: TextAlign.center),
          ),
          selected: selected,
          selectedColor: AppColors.gold,
          backgroundColor: Theme.of(context).colorScheme.surface,
          showCheckmark: false,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(
              color: selected ? AppColors.gold : Theme.of(context).dividerColor,
            ),
          ),
          labelStyle: TextStyle(
            color: selected
                ? AppColors.plum
                : Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.w700,
          ),
          onSelected: (_) => onSelected(),
        ),
      ),
    );
  }
}
