import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:khubzati/core/extensions/context.dart';
import 'package:khubzati/core/widgets/app_elevated_button.dart';
import 'package:khubzati/gen/translations/locale_keys.g.dart';

// TODO: Implement AuthBloc for state management and API calls
// TODO: Implement navigation to Signup, Forgot Password, and Home screens
// TODO: Implement social login buttons and logic

@RoutePage()
class LoginScreen extends StatefulWidget {
  static const String routeName = '/login';

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    if (_formKey.currentState!.validate()) {
      // TODO: Call AuthBloc to perform login
      print('Email: ${_emailController.text}');
      print('Password: ${_passwordController.text}');
      // Placeholder for navigation or showing success/error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.auth_login_title.tr()),
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
                // TODO: Add App Logo or relevant image as per Figma
                const SizedBox(height: 48),
                Text(
                  LocaleKeys.app_login.tr(),
                  style: context.theme.textTheme.headlineMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  LocaleKeys.auth_login_subheading.tr(),
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
                      return LocaleKeys.form_validation_required
                          .tr(args: [LocaleKeys.form_email_label.tr()]);
                    }
                    // TODO: Add more sophisticated email validation if needed
                    if (!value.contains('@')) {
                      // Basic check
                      return LocaleKeys.form_validation_invalid_email.tr();
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                AppTextField(
                  controller: _passwordController,
                  labelText: LocaleKeys.form_password_label.tr(),
                  hintText: LocaleKeys.form_password_hint.tr(),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return LocaleKeys.form_validation_required
                          .tr(args: [LocaleKeys.form_password_label.tr()]);
                    }
                    // TODO: Add password strength validation if needed
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: TextButton(
                    onPressed: () {
                      // TODO: Navigate to Forgot Password screen
                      print('Forgot Password Tapped');
                    },
                    child: Text(LocaleKeys.auth_forgot_password_link.tr()),
                  ),
                ),
                const SizedBox(height: 24),
                AppElevatedButton(
                  text: LocaleKeys.auth_login_button.tr(),
                  onPressed: _login,
                ),
                const SizedBox(height: 32),
                // TODO: Add "Or continue with" text and social login buttons (Google, Apple) as per Figma
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(LocaleKeys.auth_no_account_prompt.tr()),
                    TextButton(
                      onPressed: () {
                        // TODO: Navigate to Signup screen
                        print('Sign Up Tapped');
                      },
                      child: Text(LocaleKeys.auth_signup_link.tr()),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
