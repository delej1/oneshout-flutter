// class SocketIO {
//   Future<void> initSocket() async {
//     final user = _authBloc.state.user;
//     channel = 'channel_${user.id}_${state.shout.id}';
//     try {
//       socket = IO.io(Urls.baseUrl, <String, dynamic>{
//         'transports': ['websocket'],
//         'autoConnect': false,
//         'query': {
//           'userName': user.email,
//           'userId': user.id,
//           'channel': channel,
//           'shoutId': state.shout.id
//         }
//       });

//       socket
//         ..connect()
//         ..onConnect(
//           (data) {
//             logger.d('Connect: ${socket.id}');
//           },
//         )
//         ..onDisconnect((_) => logger.d('Connection Disconnection'))
//         ..onConnectError(
//           (data) =>
//               logger.e('Connect: ${socket.id} failed! ${data.toString()}'),
//         )
//         ..onError((err) => logger.e(err));
//     } catch (e) {
//       logger.e(e.toString());
//     }
//   }
// }