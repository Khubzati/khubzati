import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

// Events
abstract class FormFieldEvent extends Equatable {
  const FormFieldEvent();

  @override
  List<Object?> get props => [];
}

class FormFieldTextChanged extends FormFieldEvent {
  final String text;

  const FormFieldTextChanged(this.text);

  @override
  List<Object> get props => [text];
}

class FormFieldFocusChanged extends FormFieldEvent {
  final bool isFocused;

  const FormFieldFocusChanged(this.isFocused);

  @override
  List<Object> get props => [isFocused];
}

class FormFieldValidationRequested extends FormFieldEvent {
  const FormFieldValidationRequested();
}

class FormFieldReset extends FormFieldEvent {
  const FormFieldReset();
}

// States
abstract class FormFieldState extends Equatable {
  const FormFieldState();

  @override
  List<Object?> get props => [];
}

class FormFieldInitial extends FormFieldState {
  const FormFieldInitial();
}

class FormFieldUpdated extends FormFieldState {
  final String text;
  final bool isFocused;
  final bool isValid;
  final String? errorMessage;
  final bool hasChanged;

  const FormFieldUpdated({
    required this.text,
    required this.isFocused,
    required this.isValid,
    this.errorMessage,
    required this.hasChanged,
  });

  @override
  List<Object?> get props =>
      [text, isFocused, isValid, errorMessage, hasChanged];

  FormFieldUpdated copyWith({
    String? text,
    bool? isFocused,
    bool? isValid,
    String? errorMessage,
    bool? hasChanged,
  }) {
    return FormFieldUpdated(
      text: text ?? this.text,
      isFocused: isFocused ?? this.isFocused,
      isValid: isValid ?? this.isValid,
      errorMessage: errorMessage ?? this.errorMessage,
      hasChanged: hasChanged ?? this.hasChanged,
    );
  }
}

// BLoC
class FormFieldBloc extends Bloc<FormFieldEvent, FormFieldState> {
  final String? Function(String?)? validator;
  final String initialValue;

  FormFieldBloc({
    this.validator,
    this.initialValue = '',
  }) : super(const FormFieldInitial()) {
    on<FormFieldTextChanged>(_onTextChanged);
    on<FormFieldFocusChanged>(_onFocusChanged);
    on<FormFieldValidationRequested>(_onValidationRequested);
    on<FormFieldReset>(_onReset);

    // Initialize with initial value
    add(FormFieldTextChanged(initialValue));
  }

  void _onTextChanged(
      FormFieldTextChanged event, Emitter<FormFieldState> emit) {
    final currentState = state;

    if (currentState is FormFieldUpdated) {
      final hasChanged = event.text != initialValue;
      final validationResult = _validateText(event.text);

      emit(currentState.copyWith(
        text: event.text,
        isValid: validationResult.isValid,
        errorMessage: validationResult.errorMessage,
        hasChanged: hasChanged,
      ));
    } else {
      final hasChanged = event.text != initialValue;
      final validationResult = _validateText(event.text);

      emit(FormFieldUpdated(
        text: event.text,
        isFocused: false,
        isValid: validationResult.isValid,
        errorMessage: validationResult.errorMessage,
        hasChanged: hasChanged,
      ));
    }
  }

  void _onFocusChanged(
      FormFieldFocusChanged event, Emitter<FormFieldState> emit) {
    final currentState = state;

    if (currentState is FormFieldUpdated) {
      emit(currentState.copyWith(isFocused: event.isFocused));
    }
  }

  void _onValidationRequested(
      FormFieldValidationRequested event, Emitter<FormFieldState> emit) {
    final currentState = state;

    if (currentState is FormFieldUpdated) {
      final validationResult = _validateText(currentState.text);

      emit(currentState.copyWith(
        isValid: validationResult.isValid,
        errorMessage: validationResult.errorMessage,
      ));
    }
  }

  void _onReset(FormFieldReset event, Emitter<FormFieldState> emit) {
    emit(FormFieldUpdated(
      text: initialValue,
      isFocused: false,
      isValid: true,
      errorMessage: null,
      hasChanged: false,
    ));
  }

  ValidationResult _validateText(String text) {
    if (validator != null) {
      final errorMessage = validator!(text);
      return ValidationResult(
        isValid: errorMessage == null,
        errorMessage: errorMessage,
      );
    }
    return const ValidationResult(isValid: true, errorMessage: null);
  }
}

class ValidationResult {
  final bool isValid;
  final String? errorMessage;

  const ValidationResult({
    required this.isValid,
    this.errorMessage,
  });
}
