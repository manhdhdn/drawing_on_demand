import 'package:drawing_on_demand/data/models/order_detail.dart';
import 'package:flutter_guid/flutter_guid.dart';
import 'package:intl/intl.dart';

import 'account.dart';
import 'discount.dart';
import 'payment.dart';

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
  Guid? orderedBy;
  Guid? discountId;
  Discount? discount;
  List<OrderDetail>? orderDetails;
  Account? orderedByNavigation;
  List<Payment>? payments;

  Order({
    this.id,
    this.orderType,
    this.orderDate,
    this.depositDate,
    this.completedDate,
    this.status,
    this.total,
    this.orderedBy,
    this.discountId,
    this.orderDetails,
  });

  Order.fromJson(Map<String, dynamic> json) {
    id = Guid(json['Id']);
    orderType = json['OrderType'];
    orderDate = DateTime.parse(json['OrderDate']);
    depositDate = json['DepositDate'] != null ? DateTime.parse(json['DepositDate']) : null;
    completedDate = json['CompletedDate'] != null ? DateTime.parse(json['CompletedDate']) : null;
    status = json['Status'];
    total = double.tryParse(json['Total'].toString());
    orderedBy = Guid(json['OrderedBy']);
    discountId = json['DiscountId'] != null ? Guid(json['DiscountId']) : null;
    discount = json['Discount'] != null ? Discount.fromJson(json['Discount']) : null;
    orderDetails = json['OrderDetails'] != null
        ? List<OrderDetail>.from(
            json['OrderDetails'].map(
              (x) => OrderDetail.fromJson(x),
            ),
          )
        : null;
    orderedByNavigation = json['OrderedByNavigation'] != null ? Account.fromJson(json['OrderedByNavigation']) : null;
    payments = json['Payments'] != null
        ? List<Payment>.from(
            json['Payments'].map(
              (x) => Payment.fromJson(x),
            ),
          )
        : null;
  }

  Map<String, dynamic> toJson() {
    return {
      'Id': id.toString(),
      'OrderType': orderType,
      'OrderDate': DateFormat("yyyy-MM-ddTHH:mm:ss.SSS'Z'").format(orderDate!),
      'DepositDate': depositDate != null ? DateFormat("yyyy-MM-ddTHH:mm:ss.SSS'Z'").format(depositDate!) : null,
      'CompletedDate': completedDate != null ? DateFormat("yyyy-MM-ddTHH:mm:ss.SSS'Z'").format(completedDate!) : null,
      'Status': status,
      'Total': total,
      'OrderedBy': orderedBy.toString(),
      'DiscountId': discountId?.toString(),
    };
  }
}
