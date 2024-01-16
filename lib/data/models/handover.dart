import 'package:flutter_guid/flutter_guid.dart';
import 'package:intl/intl.dart';

class HandOvers {
  int? count;
  List<HandOver> value;

  HandOvers({this.count, required this.value});

  factory HandOvers.fromJson(Map<String, dynamic> json) {
    return HandOvers(
      count: json['@odata.count'],
      value: List<HandOver>.from(
        json['value'].map(
          (x) => HandOver.fromJson(x),
        ),
      ),
    );
  }
}

class HandOver {
  String? id;
  String? name;
  String? phone;
  String? pickupAddress;
  String? receiveAddress;
  double? shipmentPrice;
  DateTime? estimatedDeliveryDate;
  DateTime? handOverDate;
  String? status;
  Guid? orderId;

  HandOver({
    this.id,
    this.name,
    this.phone,
    this.pickupAddress,
    this.receiveAddress,
    this.shipmentPrice,
    this.estimatedDeliveryDate,
    this.handOverDate,
    this.status,
    this.orderId,
  });

  HandOver.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    name = json['Name'];
    phone = json['Phone'];
    pickupAddress = json['PickupAddress'];
    receiveAddress = json['ReceiveAddress'];
    shipmentPrice = double.tryParse(json['ShipmentPrice'].toString());
    estimatedDeliveryDate = json['EstimatedDeliveryDate'] != null ? DateTime.parse(json['EstimatedDeliveryDate']) : null;
    handOverDate = json['HandOverDate'] != null ? DateTime.parse(json['HandOverDate']) : null;
    status = json['Status'];
    orderId = Guid(json['OrderId']);
  }

  Map<String, dynamic> toJson() {
    return {
      'Id': id,
      'Name': name,
      'Phone': phone,
      'PickupAddress': pickupAddress,
      'ReceiveAddress': receiveAddress,
      'ShipmentPrice': shipmentPrice,
      'EstimatedDeliveryDate': DateFormat("yyyy-MM-ddTHH:mm:ss.SSS'Z'").format(estimatedDeliveryDate!),
      'HandOverDate': DateFormat("yyyy-MM-ddTHH:mm:ss.SSS'Z'").format(handOverDate!),
      'Status': status,
      'OrderId': orderId.toString(),
    };
  }
}
