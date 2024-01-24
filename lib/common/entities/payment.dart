import 'package:equatable/equatable.dart';

class Payment extends Equatable {
  const Payment({
    this.id,
    this.ref,
    this.saleId,
    this.amount,
    this.type,
    this.status,
    this.date,
  });

  Payment.fromJson(Map<String, dynamic> json)
      : id = json['id']?.toString(),
        ref = json['ref'] == null ? null : json['ref'] as String,
        saleId = json['saleId'] == null ? null : json['saleId'] as String,
        amount = json['amount'] == null ? null : json['amount'] as num,
        type = json['type'] == null ? null : json['type'] as String,
        status = json['status'] == null ? null : json['status'] as String,
        date = json['date'] == null
            ? null
            : DateTime.parse(json['date'] as String);

  final String? id;
  final String? ref;
  final String? saleId;
  final num? amount;
  final String? type;
  final String? status;
  final DateTime? date;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'ref': ref,
        'id': id,
        'saleId': saleId,
        'amount': amount,
        'type': type,
        'status': status,
        'date': date,
      };

  static List<Payment> listFromJson(List<Map<String, dynamic>> json) =>
      List<Payment>.from(
        json.map<Payment>(Payment.fromJson),
      );

  @override
  List<Object?> get props => [id, ref];
}
