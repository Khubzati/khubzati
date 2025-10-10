part of 'role_selection_bloc.dart';

abstract class RoleSelectionEvent extends Equatable {
  const RoleSelectionEvent();

  @override
  List<Object?> get props => [];
}

class SelectRole extends RoleSelectionEvent {
  final String role;

  const SelectRole({required this.role});

  @override
  List<Object?> get props => [role];
}

class LoadSelectedRole extends RoleSelectionEvent {
  const LoadSelectedRole();
}