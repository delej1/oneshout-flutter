import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class PermissionState extends Equatable {}

class InitialState extends PermissionState {
  @override
  List<Object> get props => [];
}

class ReadyState extends PermissionState {
  @override
  List<Object> get props => [];
}

class RequirePermissionState extends PermissionState {
  @override
  List<Object> get props => [];
}

class LoadedPermisionState extends PermissionState {
  LoadedPermisionState(this.perm);
  final Perm perm;
  @override
  List<Object> get props => [perm];
}

class PermisionStageState extends PermissionState {
  PermisionStageState(this.stage);
  final int stage;
  @override
  List<Object> get props => [stage];
}

class Perm {
  const Perm({
    required this.title,
    required this.body,
    this.icon,
    required this.action,
  });
  final String title;
  final String body;
  final IconData? icon;
  final VoidCallback action;
}
