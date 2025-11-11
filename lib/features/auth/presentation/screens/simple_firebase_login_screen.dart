import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:khubzati/features/auth/application/cubits/firebase_otp_cubit.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

/// Simplified login screen using FirebaseOtpCubit
///
/// This is a cleaner, Firebase-only approach without backend integration.
/// Once Firebase auth succeeds, you can then call your backend API.
class SimpleFirebaseLoginScreen extends StatefulWidget {
  const SimpleFirebaseLoginScreen({super.key});

  @override
  State<SimpleFirebaseLoginScreen> createState() =>
      _SimpleFirebaseLoginScreenState();
}

class _SimpleFirebaseLoginScreenState extends State<SimpleFirebaseLoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  String? _formattedPhone;

  @override
  void dispose() {
    _phoneController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  void _sendOtp(BuildContext context) {
    if (_formattedPhone == null || _formattedPhone!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid phone number')),
      );
      return;
    }

    // Send OTP via Firebase
    context.read<FirebaseOtpCubit>().sendOtp(_formattedPhone!);
  }

  void _verifyOtp(BuildContext context) {
    final otp = _otpController.text.trim();
    if (otp.isEmpty || otp.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter the 6-digit OTP code')),
      );
      return;
    }

    // Verify OTP
    context.read<FirebaseOtpCubit>().verifyOtp(otp);
  }

  void _resendOtp(BuildContext context) {
    context.read<FirebaseOtpCubit>().resendOtp();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firebase Phone Login'),
      ),
      body: BlocConsumer<FirebaseOtpCubit, FirebaseOtpState>(
        listener: (context, state) {
          // Show error messages
          if (state.status == OtpAuthStatus.failed && state.error != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error!),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 5),
              ),
            );
          }

          // Show success message when code is sent
          if (state.status == OtpAuthStatus.codeSent) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('OTP sent! Please check your messages.'),
                backgroundColor: Colors.green,
              ),
            );
          }

          // Navigate or proceed when verified
          if (state.status == OtpAuthStatus.verified) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Phone verified successfully!'),
                backgroundColor: Colors.green,
              ),
            );

            // TODO: Now call your backend API with Firebase ID token
            final user = context.read<FirebaseOtpCubit>().currentUser;
            if (user != null) {
              user.getIdToken().then((token) {
                print('Firebase ID Token: $token');
                // Call your backend: POST /api/auth/login with this token
                // Your backend validates the token and returns your app's JWT
              });
            }
          }
        },
        builder: (context, state) {
          final isLoading = state.status == OtpAuthStatus.sending ||
              state.status == OtpAuthStatus.verifying;
          final showOtpInput = state.status == OtpAuthStatus.codeSent;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Phone number input (hide when OTP is sent)
                if (!showOtpInput) ...[
                  const Text(
                    'Enter your phone number',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  IntlPhoneField(
                    controller: _phoneController,
                    decoration: const InputDecoration(
                      labelText: 'Phone Number',
                      border: OutlineInputBorder(),
                    ),
                    initialCountryCode: 'JO', // Jordan
                    onChanged: (phone) {
                      _formattedPhone = phone.completeNumber;
                      print('DEBUG: Phone number: $_formattedPhone');
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: isLoading ? null : () => _sendOtp(context),
                    child: isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Send OTP'),
                  ),
                ],

                // OTP input (show when code is sent)
                if (showOtpInput) ...[
                  const Text(
                    'Enter the OTP code',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Code sent to ${state.phoneNumber}',
                    style: const TextStyle(color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _otpController,
                    decoration: const InputDecoration(
                      labelText: 'OTP Code',
                      hintText: '123456',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 24,
                      letterSpacing: 8,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: isLoading ? null : () => _verifyOtp(context),
                    child: isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Verify OTP'),
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: isLoading ? null : () => _resendOtp(context),
                    child: const Text('Resend OTP'),
                  ),
                  TextButton(
                    onPressed: () {
                      context.read<FirebaseOtpCubit>().reset();
                      _otpController.clear();
                    },
                    child: const Text('Change Phone Number'),
                  ),
                ],

                // Status indicator
                if (isLoading) ...[
                  const SizedBox(height: 20),
                  Center(
                    child: Text(
                      state.status == OtpAuthStatus.sending
                          ? 'Sending OTP...'
                          : 'Verifying...',
                      style: const TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
