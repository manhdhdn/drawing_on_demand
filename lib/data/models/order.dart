import 'package:flutter_guid/flutter_guid.dart';
import 'package:intl/intl.dart';

class Orders {
  int? count;
  List<Order> value;

  Orders({this.count, required this.value});

  factory Orders.fromJson(Map<String, dynamic> json) {
    return Orders(
      count: json['@odata.count'],
      value: List<Order>.from(
        json['value'].map(
          (x) => Order.fromJson(x),
        ),
      ),
    );
  }
}

class Order {
  Guid? id;
  String? orderType;
  DateTime? orderDate;
  DateTime? depositDate;
  DateTime? completedDate;
  double? fee;
  String? status;
  double? total;
  Guid? orderBy;
  Guid? discountId;

  Order({
    this.id,
    this.orderType,
    this.orderDate,
    this.depositDate,
    this.completedDate,
    this.fee,
    this.status,
    this.total,
    this.orderBy,
    this.discountId,
  });

  Order.fromJson(Map<String, dynamic> json) {
    id = Guid(json['Id']);
    orderType = json['OrderType'];
    orderDate = DateTime.parse(json['OrderDate']);
    depositDate = json['DepositDate'] != null
        ? DateTime.parse(json['DepositDate'])
        : null;
    completedDate = json['CompletedDate'] != null
        ? DateTime.parse(json['CompletedDate'])
        : null;
    fee = double.tryParse(json['Fee'].toString());
    status = json['Status'];
    total = double.tryParse(json['Total'].toString());
    orderBy = Guid(json['OrderBy']);
    discountId = json['DiscountId'] != null ? Guid(json['DiscountId']) : null;
  }

  Map<String, dynamic> toJson() {
    return {
      'Id': id.toString(),
      'OrderType': orderType,
      'OrderDate': DateFormat('yyyy-MM-ddTHH:mm:ss+07:00').format(orderDate!),
      'DepositDate': depositDate != null
          ? DateFormat('yyyy-MM-ddTHH:mm:ss+07:00').format(depositDate!)
          : null,
      'CompletedDate': completedDate != null
          ? DateFormat('yyyy-MM-ddTHH:mm:ss+07:00').format(completedDate!)
          : null,
      'Fee': fee,
      'Status': status,
      'Total': total,
      'OrderBy': orderBy.toString(),
      'DiscountId': discountId?.toString(),
    };
  }
}
