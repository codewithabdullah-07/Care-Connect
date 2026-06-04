# CareConnect

CareConnect is a Flutter clinic appointment app with Firebase phone authentication, doctor browsing, appointment booking, history tracking, a themed UI, and device calendar integration for confirmed appointments.

## Features

- Phone number sign-in with OTP verification
- Home dashboard with appointment summary
- Doctor listing with search and detail view
- Appointment booking with patient details, gender, date of birth, and issue notes
- Upcoming and past appointment history
- Appointment confirmation screen with calendar add support
- Light and dark theme toggle

## Tech Stack

- Flutter
- Firebase Authentication
- Cloud Firestore
- Provider
- `device_calendar_plus`
- `intl`
- `pinput`
- `intl_phone_field`

## Project Structure

- `lib/screens/` - app screens and flows
- `lib/providers/` - state management
- `lib/services/` - Firebase, storage, and calendar services
- `lib/widgets/` - reusable UI components
- `lib/utils/` - theme, colors, and constants

## Setup

1. Make sure Flutter is installed and available on your machine.
2. Connect the Firebase project used by the app.
3. Keep the generated Firebase files in place:
   - `lib/firebase_options.dart`
   - `android/app/google-services.json`
4. Fetch dependencies:

```powershell
flutter pub get
```

## Run

```powershell
flutter run
```

## Build

```powershell
flutter build apk --debug --no-pub
```

## Notes

- The app uses a custom branded color theme based on plum and gold.
- Calendar access is requested only when the user taps Add to Calendar on the confirmation screen.
- If you change Firebase configuration, regenerate the platform-specific Firebase files rather than editing them manually.
