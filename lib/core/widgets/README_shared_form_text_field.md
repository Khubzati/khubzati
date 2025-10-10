# SharedFormTextField Widget

A reusable, responsive form text field widget designed for the Khubzati app that supports multiple languages and follows the app's design system.

## Features

- ✅ **Responsive Design**: Uses `flutter_screenutil` for consistent scaling across devices
- ✅ **Multi-language Support**: RTL/LTR text alignment and proper font handling
- ✅ **App Design System**: Uses `AppColors` and `AppTextStyles` for consistency
- ✅ **Optional Labels**: Labels are optional and can be hidden
- ✅ **Validation Support**: Built-in validation with custom error messages
- ✅ **Multiple Variants**: Predefined variants for common use cases
- ✅ **Customizable**: Highly customizable with many optional parameters
- ✅ **Accessibility**: Proper semantic structure and keyboard support

## Basic Usage

```dart
import 'package:khubzati/core/widgets/shared_form_text_field.dart';

// Basic text field
SharedFormTextFieldVariants.standard(
  label: 'اسم المستخدم',
  hint: 'أدخل اسم المستخدم',
  controller: _nameController,
  onChanged: (value) => print('Name: $value'),
)
```

## Available Variants

### 1. Standard Text Field
```dart
SharedFormTextFieldVariants.standard(
  controller: _controller,
  label: 'Label',
  hint: 'Hint text',
  validator: (value) => value?.isEmpty == true ? 'Required' : null,
  onChanged: (value) => print(value),
)
```

### 2. Number Field
```dart
SharedFormTextFieldVariants.number(
  controller: _controller,
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
)
```

### 3. Email Field
```dart
SharedFormTextFieldVariants.email(
  controller: _controller,
  label: 'البريد الإلكتروني',
  hint: 'أدخل بريدك الإلكتروني',
  validator: (value) {
    if (value == null || !value.contains('@')) {
      return 'يرجى إدخال بريد إلكتروني صحيح';
    }
    return null;
  },
)
```

### 4. Phone Field
```dart
SharedFormTextFieldVariants.phone(
  controller: _controller,
  label: 'رقم الهاتف',
  hint: 'أدخل رقم الهاتف',
)
```

### 5. Password Field
```dart
SharedFormTextFieldVariants.password(
  controller: _controller,
  label: 'كلمة المرور',
  hint: 'أدخل كلمة المرور',
  obscureText: true,
  validator: (value) {
    if (value == null || value.length < 6) {
      return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
    }
    return null;
  },
)
```

### 6. Multiline Field
```dart
SharedFormTextFieldVariants.multiline(
  controller: _controller,
  label: 'الوصف',
  hint: 'أدخل الوصف',
  maxLines: 4,
)
```

## Custom Usage

For more control, use the base `SharedFormTextField` class:

```dart
SharedFormTextField(
  controller: _controller,
  label: 'Custom Field',
  hint: 'Enter text',
  keyboardType: TextInputType.text,
  maxLines: 1,
  maxLength: 50,
  enabled: true,
  prefixIcon: Icon(Icons.person),
  suffixIcon: Icon(Icons.check),
  isRequired: true,
  validator: (value) => value?.isEmpty == true ? 'Required' : null,
  onChanged: (value) => print(value),
)
```

## Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `controller` | `TextEditingController?` | `null` | Controller for the text field |
| `label` | `String?` | `null` | Optional label text |
| `hint` | `String?` | `null` | Hint text displayed when field is empty |
| `validator` | `String? Function(String?)?` | `null` | Validation function |
| `onChanged` | `void Function(String)?` | `null` | Callback when text changes |
| `keyboardType` | `TextInputType?` | `TextInputType.text` | Keyboard type |
| `obscureText` | `bool` | `false` | Whether to obscure text (for passwords) |
| `maxLines` | `int?` | `1` | Maximum number of lines |
| `maxLength` | `int?` | `null` | Maximum character length |
| `enabled` | `bool` | `true` | Whether the field is enabled |
| `prefixIcon` | `Widget?` | `null` | Icon before the text |
| `suffixIcon` | `Widget?` | `null` | Icon after the text |
| `contentPadding` | `EdgeInsetsGeometry?` | `null` | Custom padding |
| `textAlign` | `TextAlign` | `TextAlign.right` | Text alignment |
| `isRequired` | `bool` | `false` | Whether to show required asterisk |
| `errorText` | `String?` | `null` | Custom error text |

## Styling

The widget uses the app's design system:

- **Colors**: `AppColors` for consistent theming
- **Typography**: `AppTextStyles` for text styling
- **Spacing**: `flutter_screenutil` for responsive sizing
- **Font**: Tajawal font for Arabic text support

## Validation Examples

### Required Field
```dart
validator: (value) {
  if (value == null || value.trim().isEmpty) {
    return 'هذا الحقل مطلوب';
  }
  return null;
}
```

### Email Validation
```dart
validator: (value) {
  if (value == null || value.trim().isEmpty) {
    return 'يرجى إدخال البريد الإلكتروني';
  }
  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
    return 'يرجى إدخال بريد إلكتروني صحيح';
  }
  return null;
}
```

### Number Validation
```dart
validator: (value) {
  if (value == null || value.trim().isEmpty) {
    return 'يرجى إدخال الرقم';
  }
  if (double.tryParse(value) == null) {
    return 'يرجى إدخال رقم صحيح';
  }
  if (double.parse(value) <= 0) {
    return 'يرجى إدخال رقم أكبر من الصفر';
  }
  return null;
}
```

### Password Validation
```dart
validator: (value) {
  if (value == null || value.trim().isEmpty) {
    return 'يرجى إدخال كلمة المرور';
  }
  if (value.length < 8) {
    return 'كلمة المرور يجب أن تكون 8 أحرف على الأقل';
  }
  if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)').hasMatch(value)) {
    return 'كلمة المرور يجب أن تحتوي على حرف كبير وصغير ورقم';
  }
  return null;
}
```

## Best Practices

1. **Always use variants** for common use cases (standard, number, email, etc.)
2. **Provide meaningful validation messages** in the appropriate language
3. **Use controllers** for form management and state persistence
4. **Handle onChanged** for real-time validation or state updates
5. **Set appropriate keyboard types** for better user experience
6. **Use isRequired** for required fields to show visual indicators
7. **Test on different screen sizes** to ensure responsive design works

## Integration with Forms

```dart
Form(
  key: _formKey,
  child: Column(
    children: [
      SharedFormTextFieldVariants.standard(
        controller: _nameController,
        label: 'الاسم',
        hint: 'أدخل الاسم',
        validator: (value) => value?.isEmpty == true ? 'مطلوب' : null,
      ),
      SharedFormTextFieldVariants.email(
        controller: _emailController,
        label: 'البريد الإلكتروني',
        hint: 'أدخل البريد الإلكتروني',
        validator: (value) => _validateEmail(value),
      ),
      ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            // Form is valid, proceed
          }
        },
        child: Text('إرسال'),
      ),
    ],
  ),
)
```

This widget provides a consistent, accessible, and responsive form input experience across the entire Khubzati application.
