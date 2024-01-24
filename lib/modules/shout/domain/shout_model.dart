import 'package:enum_to_string/enum_to_string.dart';
import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

enum AlertStatus { initial, sent, failed }

enum ShoutType { help, panic, notify }

class Shout {
  const Shout({
    this.id,
    this.date,
    this.recipients = const [],
    this.message,
    // this.location,
    this.status = AlertStatus.initial,
    this.senderId,
    this.senderPhone,
    this.senderName,
    this.latitude,
    this.longitude,
    this.type = ShoutType.help,
    this.notified,
    this.trackerChannel,
    this.locations = const [],
  });

  factory Shout.fromJson(Map<String, dynamic> json) => Shout(
        id: json['id']?.toString(),
        date: json['date'] != null
            ? DateTime.parse(json['date'] as String)
            : null,
        message: json['message'].toString(),
        recipients: (json['recipients'] as String).split(',').toList(),
        senderId: json['senderId'].toString(),
        senderPhone: json['senderPhone'].toString(),
        senderName: json['senderName'].toString(),
        latitude: double.tryParse(json['latitude'].toString()),
        longitude: double.tryParse(json['longitude'].toString()),
        type: EnumToString.fromString(
          ShoutType.values,
          json['type'].toString(),
        ), //Enum
        notified: json['notified']?.toString(),
        trackerChannel: json['trackerChannel']?.toString(),
        locations: json['locations'] == null
            ? []
            : MyLocation.listFromJson(json['locations'] as List<dynamic>),
      );

  static const empty = Shout();

  final String? id;
  final DateTime? date;
  final List<String>? recipients;
  final String? message;
  final String? senderId;
  final String? senderName;
  final String? senderPhone;
  final double? latitude;
  final double? longitude;
  final AlertStatus? status;
  final ShoutType? type;
  final String? notified;
  final String? trackerChannel;
  final List<MyLocation> locations;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'date': date != null ? date!.toIso8601String() : null,
        'message': message,
        'senderId': senderId,
        'senderName': senderName,
        'senderPhone': senderPhone,
        'recipients': recipients!.isNotEmpty ? recipients?.join(',') : List,
        'locations': locations,
        // 'status': status,
        'longitude': longitude,
        'latitude': latitude,
        'type': EnumToString.convertToString(type),
        'tracker_channel': trackerChannel,
      };

  Shout copyWith({
    String? id,
    DateTime? date,
    List<String>? recipients,
    String? message,
    String? senderId,
    String? senderName,
    String? senderPhone,
    // LocationData? location,
    AlertStatus? status,
    double? longitude,
    double? latitude,
    String? trackerChannel,
    List<MyLocation>? locations,
  }) =>
      Shout(
        id: id ?? this.id,
        date: date ?? this.date,
        recipients: recipients ?? this.recipients,
        message: message ?? this.message,
        senderPhone: senderPhone ?? this.senderPhone,
        senderName: senderName ?? this.senderName,
        senderId: senderId ?? this.senderId,
        // location: location ?? this.location,
        status: status ?? this.status,
        latitude: latitude ?? this.latitude,
        longitude: longitude ?? this.longitude,
        trackerChannel: trackerChannel ?? this.trackerChannel,
        locations: locations ?? this.locations,
      );

  static List<Shout> listFromJson(List<dynamic> list) => List<Shout>.from(
        list.map<Shout>(
          (dynamic x) => Shout.fromJson(x as Map<String, dynamic>),
        ),
      );
}

class MyLocation extends Equatable {
  const MyLocation({required this.coordinate, required this.timestamp});

  factory MyLocation.fromJson(Map<String, dynamic> json) => MyLocation(
        coordinate: LatLng(
          double.parse(json['lat'].toString()),
          double.parse(json['lng'].toString()),
        ),
        timestamp: DateTime.parse(json['timestamp'].toString()),
      );

  final LatLng coordinate;
  final DateTime timestamp;

  static List<MyLocation> listFromJson(List<dynamic> list) =>
      List<MyLocation>.from(
        list.map<MyLocation>(
          (dynamic x) => MyLocation.fromJson(x as Map<String, dynamic>),
        ),
      );
  @override
  List<Object?> get props => [coordinate, timestamp];
}
