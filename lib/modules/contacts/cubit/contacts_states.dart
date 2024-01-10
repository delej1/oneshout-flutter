import 'package:equatable/equatable.dart';

abstract class ContactsState extends Equatable {}

class InitialState extends ContactsState {
  @override
  List<Object> get props => [];
}

class EmptyState extends ContactsState {
  @override
  List<Object> get props => [];
}

class LoadingState extends ContactsState {
  @override
  List<Object> get props => [];
}

class LoadedState extends ContactsState {
  LoadedState(this.contacts);
  final List<MyContact> contacts;
  @override
  List<Object> get props => [contacts];
}

class DetailState extends ContactsState {
  DetailState(this.contact);
  final MyContact contact;
  @override
  List<Object> get props => [contact];
}

class MyContact {
  MyContact({
    required this.name,
    required this.phone,
    required this.phoneFormatted,
    required this.initials,
    required this.enabled,
  });

  factory MyContact.fromJson(Map<String, dynamic> json) => MyContact(
        name: json['name'].toString(),
        phone: json['phone'].toString(),
        phoneFormatted: json['phoneFormatted'].toString(),
        initials: json['initials'].toString(),
        enabled: json['enabled'] as bool,
      );

  String name;
  String phone;
  String phoneFormatted;
  String initials;
  bool enabled;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'name': name,
        'phone': phone,
        'phoneFormatted': phoneFormatted,
        'initials': initials,
        'enabled': enabled,
      };

  MyContact copyWith({
    String? name,
    String? phone,
    String? phoneFormatted,
    String? initials,
    bool? enabled,
  }) =>
      MyContact(
        name: name ?? this.name,
        phone: phone ?? this.phone,
        phoneFormatted: phoneFormatted ?? this.phoneFormatted,
        initials: initials ?? this.initials,
        enabled: enabled ?? this.enabled,
      );

  static List<MyContact> listFromJson(List<dynamic> list) =>
      List<MyContact>.from(
        list.map<MyContact>(
          (dynamic x) => MyContact.fromJson(x as Map<String, dynamic>),
        ),
      );
}
