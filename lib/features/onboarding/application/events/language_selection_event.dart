part of 'language_selection_bloc.dart';

abstract class LanguageSelectionEvent extends Equatable {
  const LanguageSelectionEvent();

  @override
  List<Object> get props => [];
}

class LoadInitialLanguage extends LanguageSelectionEvent {}

class SelectLanguage extends LanguageSelectionEvent {
  final Locale locale;

  const SelectLanguage(this.locale);

  @override
  List<Object> get props => [locale];
}

