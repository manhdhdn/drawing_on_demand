import 'package:flutter_guid/flutter_guid.dart';
import 'package:intl/intl.dart';

class Payments {
  int? count;
  List<Payment> value;

  Payments({this.count, required this.value});

  factory Payments.fromJson(Map<String, dynamic> json) {
    return Payments(
      count: json['@odata.count'],
      value: List<Payment>.from(
        json['value'].map(
          (x) => Payment.fromJson(x),
        ),
      ),
    );
  }
}

class Payment {
  Guid? id;
  DateTime? transactionId;
  String? signature;
  String? tranferContent;
  String? status;
  Guid? orderId;

  Payment({
    this.id,
    this.transactionId,
    this.signature,
    this.tranferContent,
    this.status,
    this.orderId,
  });

  Payment.fromJson(Map<String, dynamic> json) {
    id = Guid(json['Id']);
    transactionId = DateTime.parse(json['TransactionId']);
    signature = json['Signature'];
    tranferContent = json['TranferContent'];
    status = json['Status'];
    orderId = Guid(json['OrderId']);
  }

  Map<String, dynamic> toJson() {
    return {
      'Id': id.toString(),
      'TransactionId': DateFormat("yyyy-MM-ddTHH:mm:ss.SSS'Z'").format(transactionId!),
      'Signature': signature,
      'TranferContent': tranferContent,
      'Status': status,
      'OrderId': orderId.toString(),
    };
  }
}
