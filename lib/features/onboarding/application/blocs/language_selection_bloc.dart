import 'dart:ui';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:khubzati/core/services/localization_service.dart'; // Assuming this service exists

part 'language_selection_event.dart';
part 'language_selection_state.dart';

class LanguageSelectionBloc extends Bloc<LanguageSelectionEvent, LanguageSelectionState> {
  final LocalizationService localizationService;

  LanguageSelectionBloc({required this.localizationService}) : super(LanguageSelectionInitial()) {
    on<LoadInitialLanguage>(_onLoadInitialLanguage);
    on<SelectLanguage>(_onSelectLanguage);
  }

  Future<void> _onLoadInitialLanguage(LoadInitialLanguage event, Emitter<LanguageSelectionState> emit) async {
    emit(LanguageLoadInProgress());
    final currentLocale = await localizationService.getCurrentLocale();
    emit(LanguageSelected(currentLocale));
  }

  Future<void> _onSelectLanguage(SelectLanguage event, Emitter<LanguageSelectionState> emit) async {
    emit(LanguageLoadInProgress());
    await localizationService.setLocale(event.locale);
    emit(LanguageSelected(event.locale));
  }
}

