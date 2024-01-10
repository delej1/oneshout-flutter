class Locator {
  const Locator({
    this.id,
    this.lastSeen,
    this.viewers = const [],
    this.phone,
    this.latitude,
    this.longitude,
    this.locateMe,
  });

  factory Locator.fromJson(Map<String, dynamic> json) => Locator(
        id: json['id']?.toString(),
        lastSeen: json['lastSeen'] != null
            ? DateTime.parse(json['lastSeen'] as String)
            : null,
        viewers: (json['viewers']?.toString())?.split(',').toList() ?? [],
        phone: json['phone']?.toString(),
        latitude: double.tryParse(json['lat'].toString()),
        longitude: double.tryParse(json['lng'].toString()),
        locateMe: json['locateMe'] as bool,
      );

  static const empty = Locator();

  final String? id;
  final DateTime? lastSeen;
  final List<String>? viewers;
  final String? phone;
  final double? latitude;
  final double? longitude;
  final bool? locateMe;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'lastSeen': lastSeen != null ? lastSeen!.toIso8601String() : null,
        'phone': phone,
        'viewers': viewers!.isNotEmpty ? viewers?.join(',') : List,
        'longitude': longitude,
        'latitude': latitude,
        'locateMe': locateMe,
      };

  Locator copyWith({
    String? id,
    DateTime? lastSeen,
    List<String>? viewers,
    String? phone,
    double? latitude,
    double? longitude,
    bool? locateMe,
  }) =>
      Locator(
        id: id ?? this.id,
        lastSeen: lastSeen ?? this.lastSeen,
        viewers: viewers ?? this.viewers,
        phone: phone ?? this.phone,
        latitude: latitude ?? this.latitude,
        longitude: longitude ?? this.longitude,
        locateMe: locateMe ?? this.locateMe,
      );

  static List<Locator> listFromJson(List<dynamic> list) => List<Locator>.from(
        list.map<Locator>(
          (dynamic x) => Locator.fromJson(x as Map<String, dynamic>),
        ),
      );
}
