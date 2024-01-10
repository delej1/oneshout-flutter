import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:oneshout/modules/shout/shout.dart';

enum ShoutTrackerStatus { initial, loading, loaded, failed, network }

class ShoutTrackerState extends Equatable {
  const ShoutTrackerState({
    this.status = ShoutTrackerStatus.initial,
    this.shout = Shout.empty,
    this.error = '',
    this.watchers = '0',
    this.channel = '',
    this.currentLocation = const LatLng(0, 0),
    this.route = const [],
    this.markers = const [],
    this.polylines = const [],
  });

  final ShoutTrackerStatus status;
  final Shout shout;
  final String error;
  final String watchers;
  final String channel;
  final LatLng currentLocation;
  final List<LatLng> route;
  final List<Marker> markers;
  final List<Polyline> polylines;

  @override
  List<Object?> get props => [
        shout,
        status,
        error,
        watchers,
        channel,
        currentLocation,
        route,
        markers,
        polylines,
      ];

  ShoutTrackerState copyWith({
    ShoutTrackerStatus? status,
    Shout? shout,
    String? error,
    String? watchers,
    String? channel,
    LatLng? currentLocation,
    List<LatLng>? route,
    List<Marker>? markers,
    List<Polyline>? polylines,
  }) {
    return ShoutTrackerState(
      status: status ?? this.status,
      shout: shout ?? this.shout,
      error: error ?? this.error,
      watchers: watchers ?? this.watchers,
      channel: channel ?? this.channel,
      currentLocation: currentLocation ?? this.currentLocation,
      route: route ?? this.route,
      markers: markers ?? this.markers,
      polylines: polylines ?? this.polylines,
    );
  }
}
