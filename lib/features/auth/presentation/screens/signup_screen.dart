import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:khubzati/core/extenstions/context.dart';

import 'package:khubzati/core/widgets/app_elevated_button.dart';
import 'package:khubzati/core/widgets/app_text_field.dart';
import 'package:khubzati/gen/translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';

// TODO: Implement AuthBloc for state management and API calls
// TODO: Implement navigation to Login and OTP screens
// TODO: Implement Terms & Conditions checkbox logic and navigation

@RoutePage()
class SignupScreen extends StatefulWidget {
  static const String routeName = '/signup';

  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _agreeToTerms = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _signup() {
    if (_formKey.currentState!.validate()) {
      if (!_agreeToTerms) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(LocaleKeys.app_form_validation_agree_terms.tr())),
        );
        return;
      }
      print('Username: ${_usernameController.text}');
      print('Email: ${_emailController.text}');
      print('Phone: ${_phoneController.text}');
      print('Password: ${_passwordController.text}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.app_auth_signup_title.tr()),
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
                const SizedBox(height: 32),
                Text(
                  LocaleKeys.app_auth_signup_heading.tr(),
                  style: context.theme.textTheme.headlineMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  LocaleKeys.app_auth_signup_subheading.tr(),
                  style: context.theme.textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                AppTextFormField(
                  textEditingController: _usernameController,
                  label: LocaleKeys.app_form_username_label.tr(),
                  hintText: LocaleKeys.app_form_username_hint.tr(),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return LocaleKeys.app_form_validation_required
                          .tr(args: [LocaleKeys.app_form_username_label.tr()]);
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                AppTextFormField(
                  textEditingController: _emailController,
                  label: LocaleKeys.app_form_email_label.tr(),
                  hintText: LocaleKeys.app_form_email_hint.tr(),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return LocaleKeys.app_form_validation_required
                          .tr(args: [LocaleKeys.app_form_email_label.tr()]);
                    }
                    if (!value.contains('@')) {
                      return LocaleKeys.app_form_validation_invalid_email.tr();
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                AppTextFormField(
                  textEditingController: _phoneController,
                  label: LocaleKeys.app_form_phone_label.tr(),
                  hintText: LocaleKeys.app_form_phone_hint.tr(),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return LocaleKeys.app_form_validation_required
                          .tr(args: [LocaleKeys.app_form_phone_label.tr()]);
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                AppTextFormField(
                  textEditingController: _passwordController,
                  label: LocaleKeys.app_form_password_label.tr(),
                  hintText: LocaleKeys.app_form_password_hint.tr(),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return LocaleKeys.app_form_validation_required
                          .tr(args: [LocaleKeys.app_form_password_label.tr()]);
                    }
                    if (value.length < 6) {
                      return LocaleKeys.app_form_validation_password_short.tr();
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                AppTextFormField(
                  textEditingController: _confirmPasswordController,
                  label: LocaleKeys.app_form_confirm_password_label.tr(),
                  hintText: LocaleKeys.app_form_confirm_password_hint.tr(),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return LocaleKeys.app_form_validation_required.tr(args: [
                        LocaleKeys.app_form_confirm_password_label.tr()
                      ]);
                    }
                    if (value != _passwordController.text) {
                      return LocaleKeys.app_form_validation_password_mismatch
                          .tr();
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Checkbox(
                      value: _agreeToTerms,
                      onChanged: (bool? value) {
                        setState(() {
                          _agreeToTerms = value ?? false;
                        });
                      },
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          print('Terms & Conditions Tapped');
                        },
                        child: Text(
                          LocaleKeys.app_auth_terms_and_conditions_prompt.tr(),
                          style: context.theme.textTheme.bodyMedium
                              ?.copyWith(decoration: TextDecoration.underline),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                AppElevatedButton(
                  child: Text(LocaleKeys.app_auth_signup_button.tr()),
                  onPressed: _signup,
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(LocaleKeys.app_auth_already_have_account_prompt.tr()),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(LocaleKeys.app_auth_login_link.tr()),
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
