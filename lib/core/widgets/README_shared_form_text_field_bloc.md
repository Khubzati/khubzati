# SharedFormTextField with BLoC Pattern

A comprehensive form management solution using BLoC pattern for state management, providing reactive form fields with validation, change detection, and loading states.

## 🏗️ Architecture

The BLoC-based form system consists of three main components:

### 1. FormFieldBloc
Manages individual form field state including:
- Text value changes
- Focus state
- Validation status
- Error messages
- Change detection

### 2. FormBloc
Manages the entire form state including:
- Multiple field values
- Form-wide validation
- Change detection across all fields
- Submission state
- Error aggregation

### 3. SharedFormTextFieldBloc
A reactive form field widget that:
- Integrates with FormFieldBloc
- Provides visual feedback (focus, error states)
- Handles user interactions
- Supports validation and change callbacks

## 📁 File Structure

```
lib/core/
├── bloc/
│   ├── form_field/
│   │   └── form_field_bloc.dart          # Individual field state management
│   └── form/
│       └── form_bloc.dart                # Form-wide state management
└── widgets/
    ├── shared_form_text_field_bloc.dart  # BLoC-based form field widget
    └── shared_form_text_field.dart       # Original non-BLoC version
```

## 🚀 Usage Examples

### Basic Form Field

```dart
SharedFormTextFieldBlocVariants.standard(
  label: 'اسم المستخدم',
  hint: 'أدخل اسم المستخدم',
  initialValue: 'John Doe',
  onChanged: (value) {
    // Handle value changes
    print('Name changed: $value');
  },
)
```

### Form with Validation

```dart
class MyFormScreen extends StatefulWidget {
  @override
  _MyFormScreenState createState() => _MyFormScreenState();
}

class _MyFormScreenState extends State<MyFormScreen> {
  late final form_bloc.FormBloc _formBloc;

  @override
  void initState() {
    super.initState();
    
    _formBloc = form_bloc.FormBloc(
      initialValues: {
        'name': '',
        'email': '',
        'phone': '',
      },
      validators: {
        'name': (value) {
          if (value == null || value.trim().isEmpty) {
            return 'الاسم مطلوب';
          }
          return null;
        },
        'email': (value) {
          if (value == null || !value.contains('@')) {
            return 'بريد إلكتروني صحيح مطلوب';
          }
          return null;
        },
        'phone': (value) {
          if (value == null || value.length < 10) {
            return 'رقم هاتف صحيح مطلوب';
          }
          return null;
        },
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _formBloc,
      child: Scaffold(
        body: Column(
          children: [
            // Name Field
            SharedFormTextFieldBlocVariants.standard(
              label: 'الاسم',
              hint: 'أدخل اسمك',
              initialValue: '',
              onChanged: (value) {
                _formBloc.add(form_bloc.FormFieldValueChanged(
                  fieldId: 'name',
                  value: value,
                ));
              },
            ),
            
            // Email Field
            SharedFormTextFieldBlocVariants.email(
              label: 'البريد الإلكتروني',
              hint: 'أدخل بريدك الإلكتروني',
              initialValue: '',
              onChanged: (value) {
                _formBloc.add(form_bloc.FormFieldValueChanged(
                  fieldId: 'email',
                  value: value,
                ));
              },
            ),
            
            // Phone Field
            SharedFormTextFieldBlocVariants.phone(
              label: 'رقم الهاتف',
              hint: 'أدخل رقم هاتفك',
              initialValue: '',
              onChanged: (value) {
                _formBloc.add(form_bloc.FormFieldValueChanged(
                  fieldId: 'phone',
                  value: value,
                ));
              },
            ),
            
            // Submit Button
            BlocBuilder<form_bloc.FormBloc, form_bloc.FormState>(
              builder: (context, state) {
                final hasChanges = state is form_bloc.FormUpdated ? state.hasChanges : false;
                final isValid = state is form_bloc.FormUpdated ? state.isValid : false;
                final isSubmitting = state is form_bloc.FormUpdated ? state.isSubmitting : false;
                
                return ElevatedButton(
                  onPressed: hasChanges && isValid && !isSubmitting ? _submitForm : null,
                  child: isSubmitting 
                    ? CircularProgressIndicator() 
                    : Text('إرسال'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _submitForm() {
    _formBloc.add(const form_bloc.FormValidationRequested());
    
    if (_formBloc.isFormValid) {
      _formBloc.add(const form_bloc.FormSubmitted());
      
      // Handle form submission
      final values = _formBloc.fieldValues;
      print('Form submitted with values: $values');
    }
  }

  @override
  void dispose() {
    _formBloc.close();
    super.dispose();
  }
}
```

## 🎯 Key Features

### 1. Reactive State Management
- **Real-time validation**: Fields validate as user types
- **Change detection**: Track which fields have been modified
- **Focus management**: Visual feedback for focused fields
- **Error handling**: Centralized error state management

### 2. Form-wide Coordination
- **Cross-field validation**: Validate entire form at once
- **Submission state**: Track form submission progress
- **Change tracking**: Know if form has unsaved changes
- **State persistence**: Maintain form state across rebuilds

### 3. Visual Feedback
- **Focus indicators**: Border color changes on focus
- **Error states**: Red borders and error messages
- **Loading states**: Disabled fields during submission
- **Change indicators**: Visual cues for modified fields

### 4. Accessibility
- **Screen reader support**: Proper semantic structure
- **Keyboard navigation**: Full keyboard accessibility
- **Error announcements**: Screen reader error feedback
- **Focus management**: Logical tab order

## 🔧 Available Variants

### Standard Text Field
```dart
SharedFormTextFieldBlocVariants.standard(
  label: 'الاسم',
  hint: 'أدخل اسمك',
  initialValue: '',
  onChanged: (value) => print(value),
)
```

### Number Field
```dart
SharedFormTextFieldBlocVariants.number(
  label: 'الكمية',
  hint: 'أدخل الكمية',
  initialValue: '0',
  onChanged: (value) => print(value),
)
```

### Email Field
```dart
SharedFormTextFieldBlocVariants.email(
  label: 'البريد الإلكتروني',
  hint: 'أدخل بريدك الإلكتروني',
  initialValue: '',
  onChanged: (value) => print(value),
)
```

### Phone Field
```dart
SharedFormTextFieldBlocVariants.phone(
  label: 'رقم الهاتف',
  hint: 'أدخل رقم هاتفك',
  initialValue: '',
  onChanged: (value) => print(value),
)
```

### Password Field
```dart
SharedFormTextFieldBlocVariants.password(
  label: 'كلمة المرور',
  hint: 'أدخل كلمة المرور',
  initialValue: '',
  obscureText: true,
  onChanged: (value) => print(value),
)
```

### Multiline Field
```dart
SharedFormTextFieldBlocVariants.multiline(
  label: 'الوصف',
  hint: 'أدخل الوصف',
  initialValue: '',
  maxLines: 4,
  onChanged: (value) => print(value),
)
```

## 📊 State Management

### FormFieldBloc Events
- `FormFieldTextChanged`: Text value changed
- `FormFieldFocusChanged`: Focus state changed
- `FormFieldValidationRequested`: Request validation
- `FormFieldReset`: Reset field to initial state

### FormFieldBloc States
- `FormFieldInitial`: Initial state
- `FormFieldUpdated`: Updated with current values

### FormBloc Events
- `FormFieldAdded`: Add new field to form
- `FormFieldValueChanged`: Field value changed
- `FormValidationRequested`: Validate entire form
- `FormSubmitted`: Submit form
- `FormReset`: Reset entire form

### FormBloc States
- `FormInitial`: Initial form state
- `FormUpdated`: Updated form state

## 🎨 Styling and Theming

The BLoC-based form fields use the same styling system as the original:

- **Colors**: `AppColors` for consistent theming
- **Typography**: `AppTextStyles` for text styling
- **Spacing**: `flutter_screenutil` for responsive sizing
- **Fonts**: Tajawal for Arabic text support

## 🔄 Migration from Non-BLoC Version

### Before (Non-BLoC)
```dart
SharedFormTextFieldVariants.standard(
  controller: _nameController,
  label: 'الاسم',
  hint: 'أدخل اسمك',
  validator: (value) => value?.isEmpty == true ? 'مطلوب' : null,
  onChanged: (value) => _onFieldChanged(),
)
```

### After (BLoC)
```dart
SharedFormTextFieldBlocVariants.standard(
  label: 'الاسم',
  hint: 'أدخل اسمك',
  initialValue: _nameController.text,
  onChanged: (value) {
    _formBloc.add(form_bloc.FormFieldValueChanged(
      fieldId: 'name',
      value: value,
    ));
  },
)
```

## 🧪 Testing

### Unit Tests
```dart
void main() {
  group('FormFieldBloc', () {
    late FormFieldBloc formFieldBloc;

    setUp(() {
      formFieldBloc = FormFieldBloc(
        validator: (value) => value?.isEmpty == true ? 'Required' : null,
        initialValue: '',
      );
    });

    test('should emit updated state when text changes', () {
      // Arrange
      const newText = 'New text';
      
      // Act
      formFieldBloc.add(FormFieldTextChanged(newText));
      
      // Assert
      expectLater(
        formFieldBloc.stream,
        emitsInOrder([
          FormFieldUpdated(
            text: newText,
            isFocused: false,
            isValid: true,
            hasChanged: true,
          ),
        ]),
      );
    });
  });
}
```

### Widget Tests
```dart
void main() {
  group('SharedFormTextFieldBloc', () {
    testWidgets('should display label and hint', (tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: SharedFormTextFieldBlocVariants.standard(
            label: 'Test Label',
            hint: 'Test Hint',
            initialValue: '',
          ),
        ),
      );

      // Assert
      expect(find.text('Test Label'), findsOneWidget);
      expect(find.text('Test Hint'), findsOneWidget);
    });
  });
}
```

## 🚀 Performance Considerations

### Memory Management
- **Automatic disposal**: BLoCs are automatically closed when widgets are disposed
- **Efficient rebuilds**: Only rebuilds when relevant state changes
- **Minimal state**: Only stores necessary state information

### Optimization Tips
1. **Use const constructors** where possible
2. **Minimize rebuilds** by using specific BlocBuilder selectors
3. **Dispose resources** properly in dispose methods
4. **Use keys** for complex forms with many fields

## 🔒 Security Considerations

### Input Validation
- **Client-side validation**: Immediate feedback for user experience
- **Server-side validation**: Always validate on server for security
- **Sanitization**: Sanitize inputs before processing
- **Type safety**: Use appropriate input types (number, email, etc.)

### Best Practices
1. **Never trust client input**: Always validate on server
2. **Use appropriate validators**: Match validation to expected input
3. **Handle errors gracefully**: Provide clear error messages
4. **Secure form submission**: Use HTTPS and proper authentication

## 📱 Responsive Design

The BLoC-based form fields automatically adapt to different screen sizes:

- **Mobile**: Optimized for touch input
- **Tablet**: Larger touch targets
- **Desktop**: Keyboard navigation support
- **Accessibility**: Screen reader compatibility

## 🌍 Internationalization

Full support for multiple languages:

- **RTL/LTR**: Automatic text direction handling
- **Localized validation**: Error messages in user's language
- **Cultural formatting**: Number and date formatting
- **Font support**: Proper font rendering for different scripts

This BLoC-based form system provides a robust, scalable, and maintainable solution for form management in Flutter applications, with excellent user experience and developer experience.
