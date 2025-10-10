import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:khubzati/core/services/localization_service.dart';

part 'language_selection_event.dart';
part 'language_selection_state.dart';

class LanguageSelectionBloc
    extends Bloc<LanguageSelectionEvent, LanguageSelectionState> {
  final LocalizationService localizationService;
  final BuildContext context;

  LanguageSelectionBloc({
    required this.localizationService,
    required this.context,
  }) : super(LanguageSelectionInitial()) {
    on<LoadInitialLanguage>(_onLoadInitialLanguage);
    on<SelectLanguage>(_onSelectLanguage);
  }

  Future<void> _onLoadInitialLanguage(
      LoadInitialLanguage event, Emitter<LanguageSelectionState> emit) async {
    emit(LanguageLoadInProgress());
    final currentLocale = localizationService.getCurrentLocale(context);
    emit(LanguageSelected(currentLocale));
  }

  Future<void> _onSelectLanguage(
      SelectLanguage event, Emitter<LanguageSelectionState> emit) async {
    emit(LanguageLoadInProgress());
    localizationService.setLocaleFromLocale(context, event.locale);
    emit(LanguageSelected(event.locale));
  }
}
