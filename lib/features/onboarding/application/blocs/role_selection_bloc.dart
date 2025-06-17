import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:khubzati/core/services/app_preferences.dart'; // Assuming this service exists for storing role

part 'role_selection_event.dart';
part 'role_selection_state.dart';

class RoleSelectionBloc extends Bloc<RoleSelectionEvent, RoleSelectionState> {
  final AppPreferences appPreferences; // Service to persist the selected role

  RoleSelectionBloc({required this.appPreferences}) : super(RoleSelectionInitial()) {
    on<SelectRole>(_onSelectRole);
    on<LoadSelectedRole>(_onLoadSelectedRole);
  }

  Future<void> _onSelectRole(SelectRole event, Emitter<RoleSelectionState> emit) async {
    emit(RoleSelectionInProgress());
    try {
      await appPreferences.setUserRole(event.role); // Persist the role
      emit(RoleSelected(event.role));
    } catch (e) {
      emit(RoleSelectionFailure(e.toString()));
    }
  }

  Future<void> _onLoadSelectedRole(LoadSelectedRole event, Emitter<RoleSelectionState> emit) async {
    emit(RoleSelectionInProgress());
    try {
      final role = await appPreferences.getUserRole();
      if (role != null && role.isNotEmpty) {
        emit(RoleSelected(role));
      } else {
        emit(RoleSelectionInitial()); // No role selected or found
      }
    } catch (e) {
      emit(RoleSelectionFailure(e.toString()));
    }
  }
}

