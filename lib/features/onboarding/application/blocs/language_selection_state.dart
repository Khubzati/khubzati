part of 'language_selection_bloc.dart';

abstract class LanguageSelectionState extends Equatable {
  const LanguageSelectionState();

  @override
  List<Object?> get props => [];
}

class LanguageSelectionInitial extends LanguageSelectionState {}

class LanguageLoadInProgress extends LanguageSelectionState {}

class LanguageSelected extends LanguageSelectionState {
  final Locale locale;

  const LanguageSelected(this.locale);

  @override
  List<Object?> get props => [locale];
}