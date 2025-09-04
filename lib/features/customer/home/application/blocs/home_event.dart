part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class FetchHomeData extends HomeEvent {}

class SearchVendors extends HomeEvent {
  final String query;
  const SearchVendors(this.query);

  @override
  List<Object> get props => [query];
}

// Add other events like RefreshHomeData, SelectCategory, etc. if needed

