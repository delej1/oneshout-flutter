import 'package:equatable/equatable.dart';

abstract class HomeState extends Equatable {}

class InitialState extends HomeState {
  @override
  List<Object> get props => [];
}

class ReadyState extends HomeState {
  @override
  List<Object> get props => [];
}

class RequirePermissionState extends HomeState {
  @override
  List<Object> get props => [];
}

class RequireUserState extends HomeState {
  @override
  List<Object> get props => [];
}

class AcceptPolicyState extends HomeState {
  @override
  List<Object> get props => [];
}
