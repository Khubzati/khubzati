import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

// Events
abstract class FormEvent extends Equatable {
  const FormEvent();

  @override
  List<Object?> get props => [];
}

class FormFieldAdded extends FormEvent {
  final String fieldId;
  final String? Function(String?)? validator;
  final String initialValue;

  const FormFieldAdded({
    required this.fieldId,
    this.validator,
    this.initialValue = '',
  });

  @override
  List<Object?> get props => [fieldId, validator, initialValue];
}

class FormFieldValueChanged extends FormEvent {
  final String fieldId;
  final String value;

  const FormFieldValueChanged({
    required this.fieldId,
    required this.value,
  });

  @override
  List<Object> get props => [fieldId, value];
}

class FormValidationRequested extends FormEvent {
  const FormValidationRequested();
}

class FormSubmitted extends FormEvent {
  const FormSubmitted();
}

class FormReset extends FormEvent {
  const FormReset();
}

// States
abstract class FormState extends Equatable {
  const FormState();

  @override
  List<Object?> get props => [];
}

class FormInitial extends FormState {
  const FormInitial();
}

class FormUpdated extends FormState {
  final Map<String, String> fieldValues;
  final Map<String, String?> fieldErrors;
  final bool isValid;
  final bool hasChanges;
  final bool isSubmitting;

  const FormUpdated({
    required this.fieldValues,
    required this.fieldErrors,
    required this.isValid,
    required this.hasChanges,
    required this.isSubmitting,
  });

  @override
  List<Object?> get props =>
      [fieldValues, fieldErrors, isValid, hasChanges, isSubmitting];

  FormUpdated copyWith({
    Map<String, String>? fieldValues,
    Map<String, String?>? fieldErrors,
    bool? isValid,
    bool? hasChanges,
    bool? isSubmitting,
  }) {
    return FormUpdated(
      fieldValues: fieldValues ?? this.fieldValues,
      fieldErrors: fieldErrors ?? this.fieldErrors,
      isValid: isValid ?? this.isValid,
      hasChanges: hasChanges ?? this.hasChanges,
      isSubmitting: isSubmitting ?? this.isSubmitting,
    );
  }
}

// BLoC
class FormBloc extends Bloc<FormEvent, FormState> {
  final Map<String, String> initialValues;
  final Map<String, String? Function(String?)> validators;

  FormBloc({
    this.initialValues = const {},
    this.validators = const {},
  }) : super(const FormInitial()) {
    on<FormFieldAdded>(_onFieldAdded);
    on<FormFieldValueChanged>(_onFieldValueChanged);
    on<FormValidationRequested>(_onValidationRequested);
    on<FormSubmitted>(_onFormSubmitted);
    on<FormReset>(_onFormReset);

    // Initialize form state
    add(const FormValidationRequested());
  }

  void _onFieldAdded(FormFieldAdded event, Emitter<FormState> emit) {
    final currentState = state;
    final newFieldValues = Map<String, String>.from(
      currentState is FormUpdated ? currentState.fieldValues : {},
    );
    final newFieldErrors = Map<String, String?>.from(
      currentState is FormUpdated ? currentState.fieldErrors : {},
    );

    newFieldValues[event.fieldId] = event.initialValue;

    if (event.validator != null) {
      final error = event.validator!(event.initialValue);
      newFieldErrors[event.fieldId] = error;
    }

    final isValid = newFieldErrors.values.every((error) => error == null);
    final hasChanges = _hasChanges(newFieldValues);

    emit(FormUpdated(
      fieldValues: newFieldValues,
      fieldErrors: newFieldErrors,
      isValid: isValid,
      hasChanges: hasChanges,
      isSubmitting: false,
    ));
  }

  void _onFieldValueChanged(
      FormFieldValueChanged event, Emitter<FormState> emit) {
    final currentState = state;

    if (currentState is FormUpdated) {
      final newFieldValues = Map<String, String>.from(currentState.fieldValues);
      final newFieldErrors =
          Map<String, String?>.from(currentState.fieldErrors);

      newFieldValues[event.fieldId] = event.value;

      // Validate the field if validator exists
      if (validators.containsKey(event.fieldId)) {
        final error = validators[event.fieldId]!(event.value);
        newFieldErrors[event.fieldId] = error;
      }

      final isValid = newFieldErrors.values.every((error) => error == null);
      final hasChanges = _hasChanges(newFieldValues);

      emit(currentState.copyWith(
        fieldValues: newFieldValues,
        fieldErrors: newFieldErrors,
        isValid: isValid,
        hasChanges: hasChanges,
      ));
    }
  }

  void _onValidationRequested(
      FormValidationRequested event, Emitter<FormState> emit) {
    final currentState = state;

    if (currentState is FormUpdated) {
      final newFieldErrors = <String, String?>{};

      // Validate all fields
      for (final entry in currentState.fieldValues.entries) {
        if (validators.containsKey(entry.key)) {
          final error = validators[entry.key]!(entry.value);
          newFieldErrors[entry.key] = error;
        }
      }

      final isValid = newFieldErrors.values.every((error) => error == null);
      final hasChanges = _hasChanges(currentState.fieldValues);

      emit(currentState.copyWith(
        fieldErrors: newFieldErrors,
        isValid: isValid,
        hasChanges: hasChanges,
      ));
    } else {
      // Initialize form state
      final newFieldValues = Map<String, String>.from(initialValues);
      final newFieldErrors = <String, String?>{};

      for (final entry in newFieldValues.entries) {
        if (validators.containsKey(entry.key)) {
          final error = validators[entry.key]!(entry.value);
          newFieldErrors[entry.key] = error;
        }
      }

      final isValid = newFieldErrors.values.every((error) => error == null);
      final hasChanges = _hasChanges(newFieldValues);

      emit(FormUpdated(
        fieldValues: newFieldValues,
        fieldErrors: newFieldErrors,
        isValid: isValid,
        hasChanges: hasChanges,
        isSubmitting: false,
      ));
    }
  }

  void _onFormSubmitted(FormSubmitted event, Emitter<FormState> emit) {
    final currentState = state;

    if (currentState is FormUpdated) {
      emit(currentState.copyWith(isSubmitting: true));

      // Here you would typically make an API call
      // For now, we'll just simulate it
      Future.delayed(const Duration(seconds: 2), () {
        if (!isClosed) {
          add(const FormValidationRequested());
        }
      });
    }
  }

  void _onFormReset(FormReset event, Emitter<FormState> emit) {
    final newFieldValues = Map<String, String>.from(initialValues);
    final newFieldErrors = <String, String?>{};

    for (final entry in newFieldValues.entries) {
      if (validators.containsKey(entry.key)) {
        final error = validators[entry.key]!(entry.value);
        newFieldErrors[entry.key] = error;
      }
    }

    final isValid = newFieldErrors.values.every((error) => error == null);

    emit(FormUpdated(
      fieldValues: newFieldValues,
      fieldErrors: newFieldErrors,
      isValid: isValid,
      hasChanges: false,
      isSubmitting: false,
    ));
  }

  bool _hasChanges(Map<String, String> currentValues) {
    for (final entry in currentValues.entries) {
      final initialValue = initialValues[entry.key] ?? '';
      if (entry.value != initialValue) {
        return true;
      }
    }
    return false;
  }

  // Helper methods
  String getFieldValue(String fieldId) {
    final currentState = state;
    if (currentState is FormUpdated) {
      return currentState.fieldValues[fieldId] ?? '';
    }
    return initialValues[fieldId] ?? '';
  }

  String? getFieldError(String fieldId) {
    final currentState = state;
    if (currentState is FormUpdated) {
      return currentState.fieldErrors[fieldId];
    }
    return null;
  }

  bool get isFormValid {
    final currentState = state;
    if (currentState is FormUpdated) {
      return currentState.isValid;
    }
    return false;
  }

  bool get hasFormChanges {
    final currentState = state;
    if (currentState is FormUpdated) {
      return currentState.hasChanges;
    }
    return false;
  }

  bool get isFormSubmitting {
    final currentState = state;
    if (currentState is FormUpdated) {
      return currentState.isSubmitting;
    }
    return false;
  }
}
