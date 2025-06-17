import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:khubzati/core/extensions/context.dart';
import 'package:khubzati/core/widgets/app_elevated_button.dart';
import 'package:khubzati/core/widgets/otp_input_field.dart'; // Assuming this custom widget exists
import 'package:khubzati/gen/translations/locale_keys.g.dart';

// TODO: Implement AuthBloc for state management and API calls for OTP verification and resend
// TODO: Implement navigation to Home screen or relevant next step upon successful verification
// TODO: Implement timer for resend OTP functionality

class OtpVerificationScreen extends StatefulWidget {
  static const String routeName = '/otp-verification';
  final String? verificationId; // Or email/phone, depending on what's needed for verification

  const OtpVerificationScreen({super.key, this.verificationId});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final _formKey = GlobalKey<FormState>();
  String _otpCode = '';

  void _verifyOtp() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // TODO: Call AuthBloc to perform OTP verification with _otpCode and widget.verificationId
      print('OTP Code: $_otpCode');
      print('Verification ID: ${widget.verificationId}');
      // Placeholder for navigation or showing success/error
    }
  }

  void _resendOtp() {
    // TODO: Call AuthBloc to resend OTP
    print('Resend OTP Tapped for ${widget.verificationId}');
    // Placeholder for showing confirmation or starting timer
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.auth_otp_verification_title.tr()),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const SizedBox(height: 48),
                Text(
                  LocaleKeys.auth_otp_verification_heading.tr(),
                  style: context.theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  // TODO: Add a more specific subheading, possibly including the phone/email the OTP was sent to
                  LocaleKeys.auth_otp_verification_subheading.tr(), 
                  style: context.theme.textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                // Assuming OtpInputField is a custom widget that takes a callback for the completed OTP
                OtpInputField(
                  numberOfFields: 6, // As per common OTP lengths, adjust if Figma specifies otherwise
                  onSubmit: (String verificationCode) {
                    setState(() {
                      _otpCode = verificationCode;
                    });
                    // Optionally, auto-submit when all fields are filled
                    // _verifyOtp(); 
                  },
                ),
                const SizedBox(height: 32),
                AppElevatedButton(
                  text: LocaleKeys.auth_otp_verify_button.tr(),
                  onPressed: _verifyOtp,
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(LocaleKeys.auth_otp_did_not_receive_prompt.tr()),
                    TextButton(
                      onPressed: _resendOtp,
                      child: Text(LocaleKeys.auth_otp_resend_link.tr()),
                    ),
                  ],
                ),
                // TODO: Add timer display for resend OTP cooldown if required by Figma
              ],
            ),
          ),
        ),
      ),
    );
  }
}

