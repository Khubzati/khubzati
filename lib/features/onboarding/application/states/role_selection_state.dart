part of 'role_selection_bloc.dart';

abstract class RoleSelectionState extends Equatable {
  const RoleSelectionState();

  @override
  List<Object> get props => [];
}

class RoleSelectionInitial extends RoleSelectionState {}

class RoleSelected extends RoleSelectionState {
  final String selectedRole;

  const RoleSelected(this.selectedRole);

  @override
  List<Object> get props => [selectedRole];
}

class RoleSelectionInProgress extends RoleSelectionState {}

class RoleSelectionFailure extends RoleSelectionState {
  final String error;

  const RoleSelectionFailure(this.error);

  @override
  List<Object> get props => [error];
}

