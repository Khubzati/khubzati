import 'package:flutter/material.dart';
import 'package:khubzati/core/widgets/shared_form_text_field.dart';

/// Examples of how to use SharedFormTextField in different scenarios
class SharedFormTextFieldExamples extends StatelessWidget {
  const SharedFormTextFieldExamples({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Form Field Examples')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Basic text field
            const Text('Basic Text Field:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SharedFormTextFieldVariants.standard(
              label: 'اسم المستخدم',
              hint: 'أدخل اسم المستخدم',
              onChanged: (value) => print('Name: $value'),
            ),

            // Required field
            const Text('Required Field:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SharedFormTextFieldVariants.standard(
              label: 'البريد الإلكتروني',
              hint: 'أدخل بريدك الإلكتروني',
              isRequired: true,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'هذا الحقل مطلوب';
                }
                if (!value.contains('@')) {
                  return 'يرجى إدخال بريد إلكتروني صحيح';
                }
                return null;
              },
            ),

            // Number field
            const Text('Number Field:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SharedFormTextFieldVariants.number(
              label: 'الكمية',
              hint: 'أدخل الكمية',
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'يرجى إدخال الكمية';
                }
                if (double.tryParse(value) == null) {
                  return 'يرجى إدخال رقم صحيح';
                }
                return null;
              },
            ),

            // Email field
            const Text('Email Field:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SharedFormTextFieldVariants.email(
              label: 'البريد الإلكتروني',
              hint: 'أدخل بريدك الإلكتروني',
            ),

            // Phone field
            const Text('Phone Field:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SharedFormTextFieldVariants.phone(
              label: 'رقم الهاتف',
              hint: 'أدخل رقم الهاتف',
            ),

            // Password field
            const Text('Password Field:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SharedFormTextFieldVariants.password(
              label: 'كلمة المرور',
              hint: 'أدخل كلمة المرور',
              validator: (value) {
                if (value == null || value.length < 6) {
                  return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
                }
                return null;
              },
            ),

            // Multiline field
            const Text('Multiline Field:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SharedFormTextFieldVariants.multiline(
              label: 'الوصف',
              hint: 'أدخل الوصف',
              maxLines: 4,
            ),

            // Custom field
            const Text('Custom Field:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SharedFormTextField(
              label: 'حقل مخصص',
              hint: 'أدخل النص',
              keyboardType: TextInputType.text,
              maxLength: 50,
              prefixIcon: Icon(Icons.person),
              suffixIcon: Icon(Icons.check),
            ),

            // Field without label
            const Text('Field Without Label:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SharedFormTextField(
              hint: 'حقل بدون تسمية',
              onChanged: (value) => print('No label field: $value'),
            ),
          ],
        ),
      ),
    );
  }
}
