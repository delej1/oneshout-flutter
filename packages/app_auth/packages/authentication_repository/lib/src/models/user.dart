import 'package:authentication_repository/src/models/user_subscription.dart';
import 'package:equatable/equatable.dart';

/// {@template user}
/// User model
///
/// [User.empty] represents an unauthenticated user.
/// {@endtemplate}
class User extends Equatable {
  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id'].toString(),
        uid: json['uid'] == null ? null : json['uid'] as String,
        email: json['email'] == null ? null : json['email'] as String,
        firstname:
            json['firstname'] == null ? null : json['firstname'] as String,
        lastname: json['lastname'] == null ? null : json['lastname'] as String,
        phone: json['phone'] == null ? null : json['phone'] as String,
        country: json['country'] == null ? null : json['country'] as String,
        username: json['username'] == null ? null : json['username'] as String,
        photo: json['photo'] == null ? '' : json['photo'] as String,
        jwt: json['jwt'] == null ? null : json['jwt'] as String,
        confirmed: json['confirmed'] != null && json['confirmed'] as bool,
        type: json['type'] == null ? null : json['type'] as String,
        hasValidSubscription: json['hasValidSubscription'] == null
            ? null
            : json['hasValidSubscription'] as bool,
        userSubscription: json['subscription'] == null
            ? UserSubscription.empty
            : UserSubscription.fromJson(
                json['subscription'] as Map<String, dynamic>,
              ),
      );

  /// {@macro user}
  const User({
    required this.id,
    this.uid,
    this.email,
    this.name,
    this.firstname,
    this.lastname,
    this.phone,
    this.username,
    this.photo,
    this.country,
    this.jwt,
    this.confirmed = false,
    this.blocked = false,
    this.type,
    this.hasValidSubscription,
    this.userSubscription,
  });

  /// User is confirmed.
  final bool confirmed;

  ///User is blocked.
  final bool blocked;

  /// The jwt token
  final String? jwt;

  /// The current user's email address.
  final String? email;

  /// The current user's id.
  final String id;

  ///UID
  final String? uid;

  /// The current user's name (display name).
  final String? name;

  /// The current user's name (display name).
  final String? firstname;

  /// The current user's name (display name).
  final String? lastname;

  ///
  final String? username;
  final String? phone;
  final String? country;
  final String? type;
  final bool? hasValidSubscription;
  final UserSubscription? userSubscription;

  /// Url for the current user's photo.
  final String? photo;

  /// Empty user which represents an unauthenticated user.
  static const empty = User(id: '');

  /// Convenience getter to determine whether the current user is empty.
  bool get isEmpty => this == User.empty;

  /// Convenience getter to determine whether the current user is not empty.
  bool get isNotEmpty => this != User.empty;

  ///
  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'firstname': firstname,
        'lastname': lastname,
        'confirmed': confirmed,
        'email': email,
        'phone': phone,
        'jwt': jwt,
        'photo': photo,
        'country': country,
        'type': type,
        'hasValidSubscription': hasValidSubscription,
        'userSubscription': userSubscription,
      };

  /// Copy
  User copyWith({
    String? id,
    String? email,
    String? uid,
    bool? blocked,
    bool? confirmed,
    String? name,
    String? firstname,
    String? lastname,
    String? phone,
    String? username,
    String? photo,
    String? jwt,
    String? country,
    String? type,
    bool? hasValidSubscription,
    UserSubscription? userSubscription,
  }) =>
      User(
        jwt: jwt ?? this.jwt,
        id: id ?? this.id,
        email: email ?? this.email,
        uid: uid ?? this.uid,
        blocked: blocked ?? this.blocked,
        confirmed: confirmed ?? this.confirmed,
        name: name ?? this.name,
        firstname: firstname ?? this.firstname,
        lastname: lastname ?? this.lastname,
        phone: phone ?? this.phone,
        username: username ?? this.username,
        photo: photo ?? this.photo,
        country: country ?? this.country,
        type: type ?? this.type,
        hasValidSubscription: hasValidSubscription ?? this.hasValidSubscription,
        userSubscription: userSubscription ?? this.userSubscription,
      );

  @override
  List<Object?> get props => [
        email,
        id,
        confirmed,
        firstname,
        lastname,
        phone,
        photo,
        jwt,
        uid,
        country,
        type,
        hasValidSubscription,
        userSubscription,
      ];
}
