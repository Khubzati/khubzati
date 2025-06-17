import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:khubzati/core/extensions/context.dart';
import 'package:khubzati/core/widgets/app_elevated_button.dart';
import 'package:khubzati/core/widgets/app_text_field.dart';
import 'package:khubzati/gen/translations/locale_keys.g.dart';

// TODO: Implement AuthBloc for state management and API calls for sending reset password OTP/link
// TODO: Implement navigation to OTP verification screen or a confirmation screen

class ForgotPasswordScreen extends StatefulWidget {
  static const String routeName = '/forgot-password';

  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _sendResetLink() {
    if (_formKey.currentState!.validate()) {
      // TODO: Call AuthBloc to send password reset link/OTP
      print('Sending password reset link to: ${_emailController.text}');
      // Placeholder for navigation or showing success/error
      // Example: Navigator.pushNamed(context, OtpVerificationScreen.routeName, arguments: _emailController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.auth_forgot_password_title.tr()),
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
                  LocaleKeys.auth_forgot_password_heading.tr(),
                  style: context.theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  LocaleKeys.auth_forgot_password_subheading.tr(),
                  style: context.theme.textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                AppTextField(
                  controller: _emailController,
                  labelText: LocaleKeys.form_email_label.tr(),
                  hintText: LocaleKeys.form_email_hint.tr(),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return LocaleKeys.form_validation_required.tr(args: [LocaleKeys.form_email_label.tr()]);
                    }
                    if (!value.contains('@')) { // Basic email validation
                      return LocaleKeys.form_validation_invalid_email.tr();
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),
                AppElevatedButton(
                  text: LocaleKeys.auth_forgot_password_send_button.tr(),
                  onPressed: _sendResetLink,
                ),
                const SizedBox(height: 24),
                TextButton(
                    onPressed: () {
                        Navigator.of(context).pop(); // Go back to the previous screen (likely Login)
                    },
                    child: Text(LocaleKeys.common_back_button.tr()),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

