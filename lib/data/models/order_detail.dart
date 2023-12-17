import 'package:flutter_guid/flutter_guid.dart';

import 'artwork.dart';

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
  double? fee;
  Guid? artworkId;
  Guid? orderId;
  Artwork? artwork;

  OrderDetail({
    this.id,
    this.price,
    this.quantity,
    this.fee,
    this.artworkId,
    this.orderId,
    this.artwork,
  });

  OrderDetail.fromJson(Map<String, dynamic> json) {
    id = Guid(json['Id']);
    price = double.tryParse(json['Price'].toString());
    quantity = json['Quantity'];
    fee = double.tryParse(json['Fee'].toString());
    artworkId = Guid(json['ArtworkId']);
    orderId = Guid(json['OrderId']);
    artwork =
        json['Artwork'] != null ? Artwork.fromJson(json['Artwork']) : null;
  }

  Map<String, dynamic> toJson() {
    return {
      'Id': id.toString(),
      'Price': price,
      'Quantity': quantity,
      'Fee': fee,
      'ArtworkId': artworkId.toString(),
      'OrderId': orderId.toString(),
    };
  }
}
