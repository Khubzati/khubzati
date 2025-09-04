import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:khubzati/core/extenstions/context.dart';
import 'package:khubzati/core/widgets/app_elevated_button.dart';
import 'package:khubzati/gen/translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';

// TODO: Implement AuthBloc for state management and API calls for OTP verification and resend
// TODO: Implement navigation to Home screen or relevant next step upon successful verification
// TODO: Implement timer for resend OTP functionality

class OtpVerificationScreen extends StatefulWidget {
  static const String routeName = '/otp-verification';
  final String?
      verificationId; // Or email/phone, depending on what's needed for verification

  const OtpVerificationScreen({super.key, this.verificationId});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final _formKey = GlobalKey<FormState>();
  final List<TextEditingController> _otpControllers = List.generate(
    6,
    (index) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(
    6,
    (index) => FocusNode(),
  );

  @override
  void dispose() {
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  String get _otpCode =>
      _otpControllers.map((controller) => controller.text).join();

  void _verifyOtp() {
    if (_formKey.currentState!.validate()) {
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
        title: Text(LocaleKeys.app_auth_otp_verification_title.tr()),
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
                  LocaleKeys.app_auth_otp_verification_heading.tr(),
                  style: context.theme.textTheme.headlineMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  LocaleKeys.app_auth_otp_verification_subheading.tr(),
                  style: context.theme.textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(
                    6,
                    (index) => SizedBox(
                      width: 45,
                      height: 49,
                      child: TextField(
                        controller: _otpControllers[index],
                        focusNode: _focusNodes[index],
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(1),
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        onChanged: (value) {
                          if (value.length == 1 && index < 5) {
                            _focusNodes[index + 1].requestFocus();
                          } else if (value.isEmpty && index > 0) {
                            _focusNodes[index - 1].requestFocus();
                          }
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                AppElevatedButton(
                  child: Text(LocaleKeys.app_auth_otp_verify_button.tr()),
                  onPressed: _verifyOtp,
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(LocaleKeys.app_auth_otp_did_not_receive_prompt.tr()),
                    TextButton(
                      onPressed: _resendOtp,
                      child: Text(LocaleKeys.app_auth_otp_resend_link.tr()),
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
