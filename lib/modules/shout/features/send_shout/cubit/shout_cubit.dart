// ignore_for_file: lines_longer_than_80_chars

import 'dart:async';
import 'dart:convert';

import 'package:app_auth/app_auth.dart';
import 'package:app_core/app_core.dart';
// import 'package:background_sms/background_sms.dart' as bsms;
import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
// import 'package:flutter_sms/flutter_sms.dart';
import 'package:get_storage/get_storage.dart';
import 'package:oneshout/common/common.dart';
import 'package:oneshout/core.dart';
import 'package:oneshout/modules/contacts/contacts.dart' as cm;
import 'package:oneshout/modules/locator/locator_api.dart';
import 'package:oneshout/modules/shout/shout.dart';
import 'package:permission_handler/permission_handler.dart' as ph;
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:telephony/telephony.dart';

class ShoutCubit extends Cubit<ShoutState> with NetworkLogger {
  ShoutCubit({
    required NetworkConnectionBloc networkConnectionBloc,
    required ShoutRepository shoutRepository,
    required AuthBloc authBloc,
  })  : _shoutRepository = shoutRepository,
        _networkConnectionBloc = networkConnectionBloc,
        _authBloc = authBloc,
        super(const ShoutState()) {
    init();
  }

  final AuthBloc _authBloc;
  final NetworkConnectionBloc _networkConnectionBloc;
  final ShoutRepository _shoutRepository;
  late Shout shout;
  IO.Socket? socket;
  double? latitude;
  double? longitude;
  String? channel;
  Map<String, dynamic> channelQuery = {};
  Timer? trackerTime;
  int watchers = 0;
  Timer? timer;
  int maxDelaySec = 10;
  int idleScreenCounter = 0;

  void init() {
    shout = state.shout;
  }

  @override
  Future<void> close() async {
    trackerTime?.cancel();
    timer?.cancel();
    if (socket != null) socket?.dispose();
    notify.closeLoading();
    await super.close();
  }

  void initScreenTimeoutTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      idleScreenCounter++;

      if (idleScreenCounter > maxDelaySec) {
        emit(state.copyWith(screenStatus: ScreenStatus.idle));
      }
    });
  }

  void onScreenTap() {
    print('tapped on Screen');
    idleScreenCounter = 0;
    emit(
      state.copyWith(
        screenStatus: state.screenStatus == ScreenStatus.busy
            ? ScreenStatus.idle
            : ScreenStatus.busy,
      ),
    );
  }

  String buildMessage() {
    logger.d('building message...');

    //if no internet connection, add the location to message.
    final hasConnection =
        _networkConnectionBloc.state.networkConnectionStatus ==
            NetworkConnectionStatus.connected;
    final name = _authBloc.state.user.firstname;

    final location = hasConnection
        ? ''
        : 'They are at *${shout.latitude},${shout.longitude}*';

    return '$name needs help! $location ${getDate()}';
  }

  String getDate() {
    try {
      final now = shout.date ?? DateTime.now().toUtc();

      final dateTime = DateFormat('EEE, dd MMM yyyy HH:mm:ss').format(now);

      final dateTimeWithOffset = '$dateTime GMT';

      return dateTimeWithOffset;
    } catch (e) {
      logger.e(e.toString());
      return '';
    }
  }

  Future<List<cm.MyContact>> loadContacts() async {
    try {
      final box = GetStorage();
      final contactsjson = box.read<List<dynamic>>('contacts');

      if (contactsjson == null) {
        return <cm.MyContact>[];
      } else {
        final contacts = List<Map>.from(contactsjson)
            .map(
              (jsonMap) =>
                  cm.MyContact.fromJson(Map<String, dynamic>.from(jsonMap)),
            )
            .toList();

        return contacts.where((c) => c.enabled == true).toList();
      }
    } catch (e) {
      logger.e(e.toString());
      return [];
    }
  }

  // Future<AlertResult> sendMessage(Shout alert) async {
  //   logger
  //     ..d('sending message...')
  //     ..d(alert.message);
  //   var sent = 0;
  //   var unsent = 0;
  //   final sentNumbers = <String>[];

  //   if (defaultTargetPlatform == TargetPlatform.android) {
  //     //check permission to send sms.
  //     final status = await ph.Permission.sms.status;
  //     if (status.isDenied) {
  //       // We didn't ask for permission yet or the permission
  //       //has been denied before but not permanently.
  //       await [
  //         ph.Permission.sms,
  //       ].request();
  //     }
  //     if (status.isGranted) {
  //       //get contacts
  //       final list = await loadContacts();
  //       final cl = <String>[];
  //       for (final l in list) {
  //         final phone = l.phone.replaceAll('-', '');
  //         logger.d('sending to $phone');
  //         // await Telephony.instance.sendSms(
  //         //   to: phone,
  //         //   message: buildMessage(),
  //         //   isMultipart: true,
  //         //   statusListener: (status) {
  //         //     status == SendStatus.SENT ? sent += 1 : unsent += 1;
  //         //   },
  //         // );
  //         final result = await bsms.BackgroundSms.sendMessage(
  //           phoneNumber: phone,
  //           message: buildMessage(),
  //         );
  //         // logger.i('result = $result');
  //         // notify.toast(result.toString());
  //         if (result == bsms.SmsStatus.sent) {
  //           sent += 1;
  //           sentNumbers.add(phone);
  //         } else {
  //           unsent += 1;
  //         }
  //       }

  //       logger.i('sent = $sent');
  //     }
  //   } else {
  //     logger.i('OS = ${TargetPlatform.iOS}');

  //     final list = await loadContacts();
  //     final cl = <String>[];

  //     for (final l in list) {
  //       final phone = l.phone.replaceAll('-', '');
  //       cl.add(phone);
  //     }

  //     logger.i('OS = ${cl.join(',')}');

  //     // iOS
  //     // final uri = Uri.parse("sms:${cl.join(',')}&body=${buildMessage()}");
  //     // await launchUrl(uri);
  //     final result = await sendSMS(
  //       message: buildMessage(),
  //       recipients: cl,
  //       sendDirect: true,
  //     ).catchError(print);
  //     logger.i('result = $result');
  //     if (result == 'sent') {
  //       sent = cl.length;
  //     } else {
  //       unsent = cl.length;
  //     }
  //   }

  //   return AlertResult(sent: sent, unsent: unsent);
  // }

  // final SmsSendStatusListener listener = print;

  Future<void> cancelShout() async {
    notify.loading();
    try {
      final result = await _shoutRepository.cancelShout(
        shout: state.shout,
      );
      trackerTime?.cancel();
      emit(state.copyWith(status: ShoutStatus.endtracking));
    } catch (e) {
      logger.d(e.toString());
    }
    notify.closeLoading();
  }

  Future<void> help() async {
    try {
      emit(state.copyWith(status: ShoutStatus.sending));

      //1. Get date.
      final date = DateTime.now().toUtc();
      //2. Get Location Coordinates.
      // final location = await getLocation();
      final location = await MyLocatorApi().getLocation();
      //2b. Get contacts.
      final contacts = await loadContacts();

      shout = shout.copyWith(
        date: date,
        // location: location,
        latitude: location?.latitude,
        longitude: location?.longitude,
        recipients: contacts.map((e) => e.phone).toList(),
      );

      //3. Build the message.
      final message = buildMessage();
      shout = shout.copyWith(
        message: message,
      );

      //4. Send the message to server.
      final result = await _shoutRepository.sendShout(
        shout: shout,
      );

      result.fold((l) {
        emit(
          state.copyWith(
            status: ShoutStatus.failed,
            error:
                l.message ?? 'An error occured. Your shout could not be sent.',
          ),
        );
      }, (shout) {
        if (core.settings
            .getValue<bool>(core.keys.ck_settings_shout_tracking, true)) {
          emit(
            state.copyWith(
              status: ShoutStatus.tracking,
              shout: shout,
            ),
          );
          startTracking();
        } else {
          emit(
            state.copyWith(
              status: ShoutStatus.successful,
              shout: shout,
            ),
          );
        }
      });
    } catch (e) {
      logger.e(e.toString());
      emit(state.copyWith(status: ShoutStatus.failed));

      // emit(StopAlertState());
      // emit(ErrorState());
    }
  }

  void startTracking() {
    emit(state.copyWith(status: ShoutStatus.tracking));
    initSocket();
    initScreenTimeoutTimer();
  }

  void startTrackerTimer() {
    trackerTime =
        Timer.periodic(const Duration(seconds: 60), (_) => broadcastLocation());
  }

  Future<void> broadcastLocation() async {
    if (state.broadcastStatus == BroadcastStatus.busy) return;

    emit(state.copyWith(broadcastStatus: BroadcastStatus.busy));
    final location = await MyLocatorApi().getLocation();
    if (location != null) {
      logger.d(location.toString());
      socket?.emitWithAck(
        'position-change',
        jsonEncode({
          ...channelQuery,
          'lng': location.longitude,
          'lat': location.latitude,
        }),
        ack: (k) {
          logger.d('$k watchers');
          emit(state.copyWith(watchers: k.toString()));
        },
      );
    }
    emit(state.copyWith(broadcastStatus: BroadcastStatus.idle));
  }

  Future<void> initSocket() async {
    final user = _authBloc.state.user;
    channel = 'channel_${user.id}_${state.shout.id}';
    channelQuery = {
      'userName': user.email,
      'userId': user.id,
      'channel': channel,
      'shoutId': state.shout.id
    };

    try {
      socket = IO.io(Urls.baseUrl, <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': true,
        'query': channelQuery,
      });

      socket!
        // ..connect()
        ..onConnect(
          (data) {
            logger.d('Connect: ${socket?.id}');
            startTrackerTimer();
          },
        )
        ..onDisconnect((_) => logger.d('Connection Disconnection'))
        ..onConnectError(
          (data) =>
              logger.e('Connect: ${socket?.id} failed! ${data.toString()}'),
        )
        ..onError((err) => logger.e(err))
        ..on('location-sent', (data) {
          logger.d(data);
        });
    } catch (e) {
      logger.e(e.toString());
    }
  }
}
