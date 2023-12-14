import 'package:flutter_guid/flutter_guid.dart';

class OrderDetails {
  int? count;
  List<OrderDetail> value;

  OrderDetails({this.count, required this.value});

  factory OrderDetails.fromJson(Map<String, dynamic> json) {
    return OrderDetails(
      count: json['@odata.count'],
      value: List<OrderDetail>.from(
        json['value'].map(
          (x) => OrderDetail.fromJson(x),
        ),
      ),
    );
  }
}

class OrderDetail {
  Guid? id;
  double? price;
  int? quantity;
  Guid? artworkId;
  Guid? orderId;

  OrderDetail({
    this.id,
    this.price,
    this.quantity,
    this.artworkId,
    this.orderId,
  });

  OrderDetail.fromJson(Map<String, dynamic> json) {
    id = Guid(json['Id']);
    price = double.tryParse(json['Price'].toString());
    quantity = json['Quantity'];
    artworkId = Guid(json['ArtworkId']);
    orderId = Guid(json['OrderId']);
  }

  Map<String, dynamic> toJson() {
    return {
      'Id': id.toString(),
      'Price': price,
      'Quantity': quantity,
      'ArtworkId': artworkId.toString(),
      'OrderId': orderId.toString(),
    };
  }
}
