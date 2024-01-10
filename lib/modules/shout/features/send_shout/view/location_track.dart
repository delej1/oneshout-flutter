import 'dart:convert';

import 'package:app_auth/app_auth.dart';
import 'package:app_core/app_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class TrackerHome extends StatefulWidget {
  TrackerHome({Key? key}) : super(key: key);

  @override
  State<TrackerHome> createState() => _TrackerHomeState();
}

class _TrackerHomeState extends State<TrackerHome> with UiLogger {
  late IO.Socket socket;
  double? latitude;
  double? longitude;
  String? channel;
  static final GlobalKey<FormState> globalKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    initSocket();
  }

  @override
  void dispose() {
    socket.disconnect();
    super.dispose();
  }

  Future<void> initSocket() async {
    final user = context.read<AuthBloc>().state.user;
    channel = 'channel_${user.id}';
    try {
      socket = IO.io('http://192.168.8.155:1400', <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': false,
        'query': {
          'userName': user.email,
          'userId': user.id,
          'channel': channel,
        }
      });
      socket
        ..connect()
        ..onConnect(
          (data) {
            logger.d('Connect: ${socket.id}');
          },
        )
        ..onDisconnect((_) => logger.d('Connection Disconnection'))
        ..onConnectError(
          (data) =>
              logger.e('Connect: ${socket.id} failed! ${data.toString()}'),
        )
        ..onError((err) => logger.e(err));
    } catch (e) {
      logger.e(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Spacer(),
            PrimaryBtn(
              onPressed: () {
                final coords = {
                  'channel': channel,
                  'lat': 23.5,
                  'lng': 54.2,
                };

                socket.emit('position-change', jsonEncode(coords));
              },
              label: 'Send Location',
            )
          ],
        ),
      ),
    );
  }
}
