import 'package:equatable/equatable.dart';
import 'package:oneshout/modules/shout/shout.dart';

enum ShoutStatus { initial, sending, successful, tracking, failed, endtracking }

enum BroadcastStatus { idle, busy }

enum ScreenStatus { idle, busy }

class ShoutState extends Equatable {
  const ShoutState({
    this.status = ShoutStatus.initial,
    this.shout = Shout.empty,
    this.error = '',
    this.watchers = '0',
    this.broadcastStatus = BroadcastStatus.idle,
    this.screenStatus = ScreenStatus.busy,
  });

  final ShoutStatus status;
  final Shout shout;
  final String error;
  final String watchers;
  final BroadcastStatus broadcastStatus;
  final ScreenStatus screenStatus;

  @override
  List<Object?> get props => [
        shout,
        status,
        error,
        watchers,
        broadcastStatus,
        screenStatus,
      ];

  ShoutState copyWith({
    ShoutStatus? status,
    Shout? shout,
    String? error,
    String? watchers,
    BroadcastStatus? broadcastStatus,
    ScreenStatus? screenStatus,
  }) {
    return ShoutState(
      status: status ?? this.status,
      shout: shout ?? this.shout,
      error: error ?? this.error,
      watchers: watchers ?? this.watchers,
      broadcastStatus: broadcastStatus ?? this.broadcastStatus,
      screenStatus: screenStatus ?? this.screenStatus,
    );
  }
}

// class InitialShoutState extends ShoutState {
//   @override
//   List<Object> get props => [];
// }

// class SendingShoutState extends ShoutState {
//   @override
//   List<Object> get props => [];
// }

// class ShoutCompleted extends ShoutState {
//   ShoutCompleted(this.result);
//   final Shout result;
//   @override
//   List<Object> get props => [result];
// }

// class ShoutLiveTracking extends ShoutState {
//   ShoutLiveTracking(this.shout);
//   final Shout shout;
//   @override
//   List<Object> get props => [shout];
// }

// class ShoutFailed extends ShoutState {
//   ShoutFailed([this.error = '']);

//   final String error;
//   @override
//   List<Object> get props => [error];
// }

// class NoShoutContact extends ShoutState {
//   @override
//   List<Object> get props => [];
// }

// class StopAlertState extends ShoutState {
//   // AlertCompletedState(this.alert);
//   // final Alert alert;
//   // @override
//   // List<Object> get props => [alert];
//   @override
//   List<Object> get props => [];
// }

// class ErrorState extends ShoutState {
//   @override
//   List<Object> get props => [];
// }

class AlertResult {
  AlertResult({this.sent = 0, this.unsent = 0});

  final int sent;
  final int unsent;
}
