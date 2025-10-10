part of 'role_selection_bloc.dart';

abstract class RoleSelectionState extends Equatable {
  const RoleSelectionState();

  @override
  List<Object?> get props => [];
}

class RoleSelectionInitial extends RoleSelectionState {}

class RoleSelectionInProgress extends RoleSelectionState {}

class RoleSelected extends RoleSelectionState {
  final String role;

  const RoleSelected(this.role);

  @override
  List<Object?> get props => [role];
}

class RoleSelectionFailure extends RoleSelectionState {
  final String message;

  const RoleSelectionFailure(this.message);

  @override
  List<Object?> get props => [message];
}