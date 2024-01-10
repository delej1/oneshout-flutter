class Tax {
  Tax({this.name, this.rate, this.compound});

  Tax.fromJson(Map<String, dynamic> json)
      : name = json['name'] as String,
        rate = json['rate'] as num,
        compound = json['compound'] as bool;

  final String? name;
  final num? rate;
  final bool? compound;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'name': name,
        'rate': rate,
        'compound': compound,
      };

  static List<Tax> listFromJson(List<Map<String, dynamic>> json) =>
      List<Tax>.from(
        json.map<Tax>(Tax.fromJson),
      );
}
