import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import '../services/firebase_service.dart';
import '../services/storage_service.dart';

class AuthProvider extends ChangeNotifier {
  AuthProvider({
    FirebaseService? firebaseService,
    StorageService? storageService,
  }) : _firebase = firebaseService ?? FirebaseService(),
       _storage = storageService ?? StorageService();

  final FirebaseService _firebase;
  final StorageService _storage;

  bool isLoading = false;
  bool isFirstTime = false;
  String? errorMessage;
  int? resendToken;
  Timer? _timer;
  int resendSeconds = 0;

  User? get currentUser => _firebase.currentUser;

  Future<void> sendOtp({
    required String phoneNumber,
    required ValueChanged<String> onCodeSent,
    required VoidCallback onVerified,
    required ValueChanged<String> onError,
  }) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    await _firebase.auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      forceResendingToken: resendToken,
      verificationCompleted: (credential) async {
        try {
          await _firebase.auth.signInWithCredential(credential);
          isFirstTime = await _firebase.updateWelcomeState();
          isLoading = false;
          notifyListeners();
          onVerified();
        } on FirebaseAuthException catch (e) {
          _fail(e.message ?? 'Auto verification failed.', onError);
        }
      },
      verificationFailed: (e) {
        _fail(e.message ?? 'Phone verification failed.', onError);
      },
      codeSent: (verificationId, token) {
        resendToken = token;
        startResendCountdown();
        isLoading = false;
        notifyListeners();
        onCodeSent(verificationId);
      },
      codeAutoRetrievalTimeout: (_) {
        isLoading = false;
        notifyListeners();
      },
    );
  }

  Future<void> verifyOtp({
    required String verificationId,
    required String smsCode,
  }) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );
      await _firebase.auth.signInWithCredential(credential);
      isFirstTime = await _firebase.updateWelcomeState();
    } on FirebaseAuthException catch (e) {
      errorMessage = e.message ?? 'Invalid verification code.';
      rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshWelcomeState() async {
    if (_firebase.currentUser == null) return;
    isFirstTime = await _firebase.updateWelcomeState();
    notifyListeners();
  }

  Future<void> logout() async {
    await _firebase.auth.signOut();
    await _storage.clearAll();
    isFirstTime = false;
    notifyListeners();
  }

  void startResendCountdown() {
    _timer?.cancel();
    resendSeconds = 8;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (resendSeconds <= 1) {
        resendSeconds = 0;
        timer.cancel();
      } else {
        resendSeconds -= 1;
      }
      notifyListeners();
    });
  }

  void _fail(String message, ValueChanged<String> onError) {
    errorMessage = message;
    isLoading = false;
    notifyListeners();
    onError(message);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
