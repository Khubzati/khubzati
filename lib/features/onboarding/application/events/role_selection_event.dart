part of 'role_selection_bloc.dart';

abstract class RoleSelectionEvent extends Equatable {
  const RoleSelectionEvent();

  @override
  List<Object> get props => [];
}

class SelectRole extends RoleSelectionEvent {
  final String role; // e.g., "customer", "bakery_owner", "restaurant_owner"

  const SelectRole(this.role);

  @override
  List<Object> get props => [role];
}

class LoadSelectedRole extends RoleSelectionEvent {}

