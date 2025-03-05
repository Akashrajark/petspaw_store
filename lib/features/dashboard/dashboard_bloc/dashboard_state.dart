part of 'dashboard_bloc.dart';

@immutable
abstract class DashboardState {}

class DashboardInitialState extends DashboardState {}

class DashboardLoadingState extends DashboardState {}

class DashboardSuccessState extends DashboardState {
  final Map<String, dynamic> data;

  DashboardSuccessState({required this.data});
}

class DashboardFailureState extends DashboardState {}
