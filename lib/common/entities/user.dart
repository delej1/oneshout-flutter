// import 'package:equatable/equatable.dart';

// import 'package:meta/meta.dart';
// import 'dart:convert';

// class User extends Equatable {
//   const User({
//     required this.id,
//     required this.email,
//     required this.uid,
//     required this.blocked,
//     required this.confirmed,
//     required this.businessId,
//   });

//   factory User.fromJson(Map<String, dynamic> json) => User(
//         id: json['id'].toString(),
//         email: json['email'] as String,
//         uid: json['uid'] as String,
//         blocked: json['blocked'] == null ? false : json['blocked'] as bool,
//         confirmed:
//             json['confirmed'] == null ? false : json['confirmed'] as bool,
//         businessId: json['businessId'].toString(),
//       );

//   factory User.fromRawJson(String str) =>
//       User.fromJson(json.decode(str) as Map<String, dynamic>);

//   final String id;
//   final String email;
//   final String uid;
//   final bool blocked;
//   final bool confirmed;
//   final String businessId;

//   User copyWith({
//     String? id,
//     String? email,
//     String? uid,
//     bool? blocked,
//     bool? confirmed,
//     String? businessId,
//   }) =>
//       User(
//         id: id ?? this.id,
//         email: email ?? this.email,
//         uid: uid ?? this.uid,
//         blocked: blocked ?? this.blocked,
//         confirmed: confirmed ?? this.confirmed,
//         businessId: businessId ?? this.businessId,
//       );

//   String toRawJson() => json.encode(toJson());

//   Map<String, dynamic> toJson() => <String, dynamic>{
//         'id': id,
//         'email': email,
//         'uid': uid,
//         'blocked': blocked,
//         'confirmed': confirmed,
//         'businessId': businessId,
//       };
//   @override
//   List<Object?> get props => [
//         id,
//         email,
//         uid,
//         businessId,
//       ];
// }
