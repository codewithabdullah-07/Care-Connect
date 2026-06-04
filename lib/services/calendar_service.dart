import 'package:device_calendar_plus/device_calendar_plus.dart';
import 'package:intl/intl.dart';

class CalendarService {
  CalendarService({DeviceCalendar? calendar})
    : _calendar = calendar ?? DeviceCalendar.instance;

  final DeviceCalendar _calendar;

  Future<void> addAppointment({
    required Map<String, dynamic> appointmentData,
  }) async {
    var permission = await _calendar.hasPermissions();
    if (permission != CalendarPermissionStatus.granted) {
      permission = await _calendar.requestPermissions();
    }

    if (permission != CalendarPermissionStatus.granted) {
      throw CalendarServiceException(
        'Calendar permission is required to add this appointment.',
      );
    }

    final calendars = await _calendar.listCalendars();
    final writableCalendars = calendars
        .where((calendar) => !calendar.readOnly && !calendar.hidden)
        .toList();
    if (writableCalendars.isEmpty) {
      throw CalendarServiceException(
        'No writable calendar was found on this device.',
      );
    }

    final calendar = writableCalendars.firstWhere(
      (calendar) => calendar.isPrimary,
      orElse: () => writableCalendars.first,
    );

    final startDate = _appointmentStart(appointmentData);
    final endDate = startDate.add(const Duration(hours: 1));
    final doctor = appointmentData['doctorName']?.toString() ?? 'Doctor';
    final speciality = appointmentData['doctorSpeciality']?.toString() ?? '';
    final patient = appointmentData['patientName']?.toString() ?? '';
    final issue = appointmentData['issue']?.toString() ?? '';

    await _calendar.createEvent(
      calendarId: calendar.id,
      title: 'Appointment with $doctor',
      startDate: startDate,
      endDate: endDate,
      description: [
        if (speciality.isNotEmpty) 'Speciality: $speciality',
        if (patient.isNotEmpty) 'Patient: $patient',
        if (issue.isNotEmpty) 'Issue: $issue',
      ].join('\n'),
      availability: EventAvailability.busy,
    );
  }

  DateTime _appointmentStart(Map<String, dynamic> appointmentData) {
    final date =
        _readDate(appointmentData['appointmentDate']) ?? DateTime.now();
    final slot = appointmentData['selectedSlot']?.toString().trim();
    if (slot == null || slot.isEmpty) {
      return DateTime(date.year, date.month, date.day, 9);
    }

    final normalizedSlot = slot.split('-').first.trim();
    for (final format in [
      DateFormat.jm(),
      DateFormat('HH:mm'),
      DateFormat('H:mm'),
    ]) {
      try {
        final parsed = format.parseStrict(normalizedSlot);
        return DateTime(
          date.year,
          date.month,
          date.day,
          parsed.hour,
          parsed.minute,
        );
      } catch (_) {
        continue;
      }
    }

    return DateTime(date.year, date.month, date.day, 9);
  }

  DateTime? _readDate(dynamic value) {
    if (value is DateTime) return value;
    if (value is String) return DateTime.tryParse(value);
    return null;
  }
}

class CalendarServiceException implements Exception {
  const CalendarServiceException(this.message);

  final String message;

  @override
  String toString() => message;
}
