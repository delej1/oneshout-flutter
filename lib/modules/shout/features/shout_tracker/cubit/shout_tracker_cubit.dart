// ignore_for_file: lines_longer_than_80_chars

import 'dart:async';
import 'dart:convert';
import 'dart:ui' as ui;

import 'package:app_core/app_core.dart';
import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:oneshout/common/common.dart';
import 'package:oneshout/modules/shout/features/shout_tracker/cubit/shout_tracker_states.dart';
import 'package:oneshout/modules/shout/shout.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ShoutTrackerCubit extends Cubit<ShoutTrackerState> with NetworkLogger {
  ShoutTrackerCubit() : super(const ShoutTrackerState());

  final Completer<GoogleMapController> controller = Completer();
  LatLng sourceLocation = const LatLng(37.33500926, -122.03272188);
  LatLng destination = const LatLng(37.33429383, -122.06600055);
  List<LatLng> polylineCoordinates = [];
  // LocationData? currentLocation;
  late IO.Socket socket;
  late String channel;
  late List<BitmapDescriptor> markerIcons;

  Future<void> init(Shout shout) async {
    logger.d('Initializing ShoutTrackerCubit');

    markerIcons = await loadMarkerIcons();

    await buildRoutesMarkersPolylines(locations: shout.locations);

    emit(
      state.copyWith(
        status: ShoutTrackerStatus.loading,
        shout: shout,
        channel: shout.trackerChannel,
      ),
    );

    await initSocket();

    // unawaited(getPolyPoints());
    // unawaited(getCurrentLocation());
  }

  Future<void> buildRoutesMarkersPolylines({
    required List<MyLocation> locations,
  }) async {
    final polylines = <Polyline>[];
    final markers = <Marker>[];

    final broutes = locations.map((e) {
      final index = locations.indexOf(e);
      final count = locations.length;
      final date =
          DateFormat('MMM d yyyy, h:mm a').format(locations[index].timestamp);
      final position = locations[index].coordinate;
      //add polylines
      if (index > 0) {
        final current = e.coordinate;
        final previousIndex = index - 1 < 0 ? 0 : index - 1;
        final previous = locations[previousIndex].coordinate;
        final polyline = Polyline(
          color: const Color(0xFF7B61FF),
          points: [previous, current],
          polylineId: const PolylineId('distance'),
          width: 5,
        );
        polylines.add(polyline);
      }

      //add markers
      if (index == 0) {
        markers.add(
          Marker(
            markerId: MarkerId('marker_id'),
            position: position,
            infoWindow: InfoWindow(
              title: 'HELP!',
              snippet: date,
            ),
            icon: markerIcons[0],
          ),
        );
      } else if (index == count - 1) {
        markers.add(
          Marker(
            markerId: MarkerId('marker_id'),
            position: position,
            infoWindow: InfoWindow(
              title: 'My last location!',
              snippet: date,
            ),
            icon: markerIcons[2],
          ),
        );
      } else {
        markers.add(
          Marker(
            markerId: MarkerId('marker_id'),
            position: position,
            infoWindow: InfoWindow(
              title: 'I was here!',
              snippet: date,
            ),
            icon: markerIcons[1],
          ),
        );
      }

      return e.coordinate;
    }).toList();

    emit(
      state.copyWith(
        // status: ShoutTrackerStatus.loading,
        route: broutes,
        markers: markers,
        polylines: polylines,
        currentLocation: LatLng(
          locations.last.coordinate.latitude,
          locations.last.coordinate.longitude,
        ),
      ),
    );
  }

  Future<List<BitmapDescriptor>> loadMarkerIcons() async {
    final startIcon =
        await getBitmapDescriptorFromAssetBytes('assets/images/icon.png', 100);
    final lastIcon = await getBitmapDescriptorFromAssetBytes(
      'assets/images/here.png',
      80,
    );
    final otherIcon = await getBitmapDescriptorFromAssetBytes(
      'assets/images/pin.png',
      50,
    );

    return [startIcon, otherIcon, lastIcon];
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    final data = await rootBundle.load(path);
    final codec = await ui.instantiateImageCodec(
      data.buffer.asUint8List(),
      targetWidth: width,
    );
    final fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  Future<BitmapDescriptor> getBitmapDescriptorFromAssetBytes(
      String path, int width) async {
    final imageData = await getBytesFromAsset(path, width);
    return BitmapDescriptor.fromBytes(imageData);
  }

  @override
  Future<void> close() async {
    socket
      ..disconnect()
      ..close();
    await super.close();
  }

  Future<void> initSocket() async {
    try {
      socket = IO.io(Urls.baseUrl, <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': true,
        'query': {
          'shoutId': state.shout.id,
          'channel': state.channel,
        }
      });
      socket
        // ..connect()
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
        ..onError((err) => logger.e(err))
        ..on(state.channel, (data) {
          final dt = data as String;
          if (dt.isNotEmpty) {
            final d = jsonDecode(dt) as Map<String, dynamic>;
            locationReceived(d);
            logger.d(d);
          }
        })
        ..emitWithAck(
          'join',
          {'channel': state.channel},
          ack: (d) {
            print('watchers: $d');
            locationsReceived(d);
          },
        )
        ..on('joined', (data) {
          final dt = data as List<dynamic>;
          logger.d(data);
        });
    } catch (e, s) {
      logger.d(s);
      logger.e(e.toString());
    }
  }

  void locationsReceived(dynamic d) {
    print(d);
  }

  Future<void> locationReceived(Map<String, dynamic> d) async {
    final location = LatLng(
      double.parse(d['lat'].toString()),
      double.parse(d['lng'].toString()),
    );

    final loc = state.shout.locations
      ..add(MyLocation(coordinate: location, timestamp: DateTime.now()));

    emit(state.copyWith(shout: state.shout.copyWith(locations: loc)));

    await buildRoutesMarkersPolylines(locations: state.shout.locations);

    // emit(state.copyWith(shout:state.shout.locations.add(value)))

    // final polyline = Polyline(
    //   color: const Color(0xFF7B61FF),
    //   points: [state.route.last, location],
    //   polylineId: const PolylineId('distance'),
    //   width: 5,
    // );

    // final lastMarker = state.markers[state.markers.length - 1];

    // final updatedLastMarker = Marker(
    //   markerId: MarkerId('source_${state.markers.length}'),
    //   position: lastMarker.position,
    //   icon: markerIcons[1],
    // );

    // final marker = Marker(
    //   markerId: MarkerId('source_${state.markers.length}'),
    //   position: location,
    //   icon: markerIcons[2],
    // );

    // state.markers.remove(lastMarker);

    // state.polylines.map(
    //   (e) => print(e.points),
    // );

    // final routes = [...state.route, location];

    // final polylines = [...state.polylines, polyline];
    // final markers = [...state.markers, marker];

    // logger
    //   ..d(markers.length)
    //   ..d(polylines)
    //   ..d(routes.length);

    // polylines.map(
    //   (e) => print(e.points),
    // );

    // emit(
    //   state.copyWith(
    //     currentLocation: location,
    //     route: routes,
    //     // polylines: polylines,
    //     markers: markers,
    //   ),
    // );

    final googleMapController = await controller.future;

    await googleMapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          zoom: 14,
          target: state.route.last,
        ),
      ),
    );
  }
}
