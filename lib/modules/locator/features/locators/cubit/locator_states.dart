import 'package:equatable/equatable.dart';
import 'package:oneshout/modules/locator/domain/domain.dart';

enum LocatorStatus { initial, loading, loaded, failed, network, empty }

class LocatorState extends Equatable {
  const LocatorState({
    this.status = LocatorStatus.initial,
    this.error = '',
    this.locators = const <Locator>[],
    this.locatorsMe = const <String>[],
    this.locatorsMeTemp = const <String>[],
    this.canLocateMe = false,
    this.isDirty = false,
  });

  final LocatorStatus status;
  final String error;
  final List<Locator> locators;
  final List<String> locatorsMe;
  final List<String> locatorsMeTemp;
  final bool canLocateMe;
  final bool isDirty;

  @override
  List<Object?> get props => [
        status,
        error,
        locators,
        locatorsMe,
        locatorsMeTemp,
        canLocateMe,
        isDirty,
      ];

  LocatorState copyWith({
    LocatorStatus? status,
    String? error,
    List<Locator>? locators,
    List<String>? locatorsMe,
    List<String>? locatorsMeTemp,
    bool? canLocateMe,
    bool? isDirty,
  }) {
    return LocatorState(
      status: status ?? this.status,
      error: error ?? this.error,
      locators: locators ?? this.locators,
      locatorsMe: locatorsMe ?? this.locatorsMe,
      locatorsMeTemp: locatorsMeTemp ?? this.locatorsMeTemp,
      canLocateMe: canLocateMe ?? this.canLocateMe,
      isDirty: isDirty ?? this.isDirty,
    );
  }
}
