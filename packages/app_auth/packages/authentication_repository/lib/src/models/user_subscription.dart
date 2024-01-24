import 'package:equatable/equatable.dart';

/// {@template user}
/// UserSubscription model
///
/// [UserSubscription.empty] represents an unauthenticated user.
/// {@endtemplate}
class UserSubscription extends Equatable {
  factory UserSubscription.fromJson(Map<String, dynamic> json) =>
      UserSubscription(
        id: json['id'].toString(),
        category: json['category'] == null ? null : json['category'] as String,
        status: json['status'] == null ? null : json['status'] as String,
        offering: json['offering'] == null ? null : json['offering'] as String,
        group: json['group'] == null ? null : json['group'] as String,
        // start: json['start'] != null
        //     ? DateTime.parse(json['start'] as String)
        //     : null,
        // stop: json['stop'] != null
        //     ? DateTime.tryParse(json['stop'] as String)
        //     : null,
      );

  /// {@macro user}
  const UserSubscription({
    required this.id,
    this.category,
    this.status,
    this.start,
    this.stop,
    this.offering,
    this.group,
  });

  ///
  final String? id;
  final String? category;
  final String? status;
  final DateTime? start;
  final DateTime? stop;
  final String? offering;
  final String? group;

  /// Empty user which represents an unauthenticated user.
  static const empty = UserSubscription(id: '');

  /// Convenience getter to determine whether the current user is empty.
  bool get isEmpty => this == UserSubscription.empty;

  /// Convenience getter to determine whether the current user is not empty.
  bool get isNotEmpty => this != UserSubscription.empty;

  ///
  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'category': category,
        'status': status,
        'start': start,
        'stop': stop,
        'offering': offering,
        'group': group,
      };

  /// Copy
  UserSubscription copyWith({
    String? id,
    String? category,
    String? status,
    DateTime? start,
    DateTime? stop,
    String? offering,
    String? group,
  }) =>
      UserSubscription(
        id: id ?? this.id,
        category: category ?? this.category,
        status: status ?? this.status,
        start: start ?? this.start,
        stop: stop ?? this.stop,
        offering: offering ?? this.offering,
        group: group ?? this.group,
      );

  @override
  List<Object?> get props =>
      [id, category, status, start, stop, offering, group];
}
