import 'package:equatable/equatable.dart';
import 'package:oneshout/common/common.dart';
import 'package:oneshout/modules/shout/shout.dart';

enum ViewShoutStatus { initial, loading, loaded, failed, network }

class ViewShoutState extends Equatable {
  const ViewShoutState({
    this.status = ViewShoutStatus.initial,
    this.shout = Shout.empty,
    this.error = '',
    this.watchers = '0',
    this.shouts = const <Shout>[],
    this.pagination = const Pagination(),
  });

  final ViewShoutStatus status;
  final Shout shout;
  final String error;
  final String watchers;
  final List<Shout> shouts;
  final Pagination pagination;

  @override
  List<Object?> get props => [
        shout,
        status,
        error,
        watchers,
        shouts,
        pagination,
      ];

  ViewShoutState copyWith({
    ViewShoutStatus? status,
    Shout? shout,
    String? error,
    String? watchers,
    List<Shout>? shouts,
    Pagination? pagination,
  }) {
    return ViewShoutState(
      status: status ?? this.status,
      shout: shout ?? this.shout,
      error: error ?? this.error,
      watchers: watchers ?? this.watchers,
      shouts: shouts ?? this.shouts,
      pagination: pagination ?? this.pagination,
    );
  }
}

// class InitialViewShoutState extends ViewShoutState {
//   @override
//   List<Object> get props => [];
// }

// class SendingViewShoutState extends ViewShoutState {
//   @override
//   List<Object> get props => [];
// }

// class ShoutCompleted extends ViewShoutState {
//   ShoutCompleted(this.result);
//   final Shout result;
//   @override
//   List<Object> get props => [result];
// }

// class ShoutLiveTracking extends ViewShoutState {
//   ShoutLiveTracking(this.shout);
//   final Shout shout;
//   @override
//   List<Object> get props => [shout];
// }

// class ShoutFailed extends ViewShoutState {
//   ShoutFailed([this.error = '']);

//   final String error;
//   @override
//   List<Object> get props => [error];
// }

// class NoShoutContact extends ViewShoutState {
//   @override
//   List<Object> get props => [];
// }

// class StopAlertState extends ViewShoutState {
//   // AlertCompletedState(this.alert);
//   // final Alert alert;
//   // @override
//   // List<Object> get props => [alert];
//   @override
//   List<Object> get props => [];
// }

// class ErrorState extends ViewShoutState {
//   @override
//   List<Object> get props => [];
// }

class AlertResult {
  AlertResult({this.sent = 0, this.unsent = 0});

  final int sent;
  final int unsent;
}
