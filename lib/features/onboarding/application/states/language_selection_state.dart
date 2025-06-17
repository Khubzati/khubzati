part of 'language_selection_bloc.dart';

abstract class LanguageSelectionState extends Equatable {
  const LanguageSelectionState();

  @override
  List<Object> get props => [];
}

class LanguageSelectionInitial extends LanguageSelectionState {}

class LanguageSelected extends LanguageSelectionState {
  final Locale selectedLocale;

  const LanguageSelected(this.selectedLocale);

  @override
  List<Object> get props => [selectedLocale];
}

class LanguageLoadInProgress extends LanguageSelectionState {}

