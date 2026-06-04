import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

import '../providers/appointment_provider.dart';
import '../providers/auth_provider.dart';
import '../utils/colors.dart';
import 'home_screen.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({
    super.key,
    required this.verificationId,
    required this.phoneNumber,
  });

  final String verificationId;
  final String phoneNumber;

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final _otpController = TextEditingController();

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pinFill = Theme.of(context).brightness == Brightness.dark
        ? AppColors.darkSurfaceElevated
        : Theme.of(context).colorScheme.surface;
    final defaultPinTheme = PinTheme(
      width: 48,
      height: 56,
      textStyle: TextStyle(
        fontSize: 20,
        color: Theme.of(context).colorScheme.onSurface,
        fontWeight: FontWeight.w600,
      ),
      decoration: BoxDecoration(
        color: pinFill,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Verify OTP')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Consumer<AuthProvider>(
          builder: (context, auth, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Enter verification code',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  'We sent a 6-digit code to ${widget.phoneNumber}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 32),
                Pinput(
                  controller: _otpController,
                  length: 6,
                  defaultPinTheme: defaultPinTheme,
                  focusedPinTheme: defaultPinTheme.copyWith(
                    decoration: defaultPinTheme.decoration!.copyWith(
                      border: Border.all(color: AppColors.gold, width: 2),
                    ),
                  ),
                  submittedPinTheme: defaultPinTheme.copyWith(
                    decoration: defaultPinTheme.decoration!.copyWith(
                      border: Border.all(color: AppColors.plum, width: 1.5),
                    ),
                  ),
                ),
                if (auth.errorMessage != null) ...[
                  const SizedBox(height: 10),
                  Text(
                    auth.errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ],
                const SizedBox(height: 24),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.gold,
                    foregroundColor: AppColors.plum,
                    disabledBackgroundColor: AppColors.gold.withValues(
                      alpha: 0.55,
                    ),
                    disabledForegroundColor: AppColors.plum.withValues(
                      alpha: 0.72,
                    ),
                    minimumSize: const Size(double.infinity, 56),
                  ),
                  onPressed: auth.isLoading
                      ? null
                      : () async {
                          await _verify(context, _otpController.text);
                        },
                  child: auth.isLoading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            color: AppColors.plum,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text('Verify'),
                ),
                const SizedBox(height: 16),
                Center(
                  child: TextButton(
                    onPressed: auth.resendSeconds == 0 && !auth.isLoading
                        ? () => auth.sendOtp(
                            phoneNumber: widget.phoneNumber,
                            onCodeSent: (newVerificationId) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('OTP resent.')),
                              );
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => OtpScreen(
                                    verificationId: newVerificationId,
                                    phoneNumber: widget.phoneNumber,
                                  ),
                                ),
                              );
                            },
                            onVerified: () {
                              context
                                  .read<AppointmentProvider>()
                                  .listenAppointments();
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const HomeScreen(),
                                ),
                                (_) => false,
                              );
                            },
                            onError: (message) => ScaffoldMessenger.of(
                              context,
                            ).showSnackBar(SnackBar(content: Text(message))),
                          )
                        : null,
                    child: Text(
                      auth.resendSeconds == 0
                          ? 'Resend OTP'
                          : 'Resend OTP in ${auth.resendSeconds}s',
                      style: const TextStyle(color: AppColors.gold),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<void> _verify(BuildContext context, String code) async {
    if (code.length != 6) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Enter the 6-digit code.')));
      return;
    }
    try {
      await context.read<AuthProvider>().verifyOtp(
        verificationId: widget.verificationId,
        smsCode: code,
      );
      if (!context.mounted) return;
      context.read<AppointmentProvider>().listenAppointments();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
        (_) => false,
      );
    } catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Verification failed.')));
    }
  }
}
