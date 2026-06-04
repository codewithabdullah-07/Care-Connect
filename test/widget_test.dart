import 'package:care_connect/utils/constants.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Care Connect constants are configured', () {
    expect(AppConstants.appName, 'Care Connect');
    expect(AppConstants.themeModeKey, 'theme_mode');
    expect(AppConstants.localAppointmentsKey, 'local_appointments');
  });
}
