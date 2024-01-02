import 'package:drawing_on_demand/data/models/order_detail.dart';
import 'package:flutter_guid/flutter_guid.dart';
import 'package:intl/intl.dart';

import 'discount.dart';

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
  String? status;
  double? total;
  Guid? orderBy;
  Guid? discountId;
  Discount? discount;
  List<OrderDetail>? orderDetails;

  Order({
    this.id,
    this.orderType,
    this.orderDate,
    this.depositDate,
    this.completedDate,
    this.status,
    this.total,
    this.orderBy,
    this.discountId,
    this.discount,
    this.orderDetails,
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
    status = json['Status'];
    total = double.tryParse(json['Total'].toString());
    orderBy = Guid(json['OrderBy']);
    discountId = json['DiscountId'] != null ? Guid(json['DiscountId']) : null;
    discount =
        json['Discount'] != null ? Discount.fromJson(json['Discount']) : null;
    orderDetails = json['OrderDetails'] != null
        ? List<OrderDetail>.from(
            json['OrderDetails'].map(
              (x) => OrderDetail.fromJson(x),
            ),
          )
        : null;
  }

  Map<String, dynamic> toJson() {
    return {
      'Id': id.toString(),
      'OrderType': orderType,
      'OrderDate': DateFormat("yyyy-MM-ddTHH:mm:ss.SSS'Z'").format(orderDate!),
      'DepositDate': depositDate != null
          ? DateFormat("yyyy-MM-ddTHH:mm:ss.SSS'Z'").format(depositDate!)
          : null,
      'CompletedDate': completedDate != null
          ? DateFormat("yyyy-MM-ddTHH:mm:ss.SSS'Z'").format(completedDate!)
          : null,
      'Status': status,
      'Total': total,
      'OrderedBy': orderBy.toString(),
      'DiscountId': discountId?.toString(),
    };
  }
}
