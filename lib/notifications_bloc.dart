import 'package:app_core/app_core.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  NotificationBloc() : super(const NotificationState()) {
    on<NotificationInitial>(_onNotificationInitial);

    on<RequestLocationNotification>(_onRequestLocationNotification);
    on<ShoutHelpNotification>(_onShoutHelpNotification);
  }
  void _onNotificationInitial(
    NotificationInitial event,
    Emitter<NotificationState> emit,
  ) {
    emit(state.copyWith(type: NotificationTypeReceived.initialize));
  }

  void _onRequestLocationNotification(
    RequestLocationNotification event,
    Emitter<NotificationState> emit,
  ) {
    emit(
      state.copyWith(
        type: NotificationTypeReceived.locationRequest,
        data: event.data,
      ),
    );
  }

  void _onShoutHelpNotification(
    ShoutHelpNotification event,
    Emitter<NotificationState> emit,
  ) {
    emit(
      state.copyWith(
        type: NotificationTypeReceived.shout,
        data: event.data,
      ),
    );
  }
}

enum NotificationTypeReceived { initialize, general, shout, locationRequest }

class NotificationState extends Equatable {
  const NotificationState({
    this.type = NotificationTypeReceived.initialize,
    this.data,
  });

  final NotificationTypeReceived type;
  final NotificationData? data;

  NotificationState copyWith({
    NotificationTypeReceived? type,
    NotificationData? data,
  }) {
    return NotificationState(
      type: type ?? this.type,
      data: data ?? this.data,
    );
  }

  @override
  List<Object> get props => [type];
}

abstract class NotificationEvent {}

class NotificationInitial extends NotificationEvent {
  NotificationInitial();
}

class RequestLocationNotification extends NotificationEvent {
  RequestLocationNotification({required this.data});
  final NotificationData data;
}

class ShoutHelpNotification extends NotificationEvent {
  ShoutHelpNotification({required this.data});
  final NotificationData data;
}
