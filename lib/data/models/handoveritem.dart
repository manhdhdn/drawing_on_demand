import 'package:flutter_guid/flutter_guid.dart';

class HandOverItems {
  int? count;
  List<HandOverItem> value;

  HandOverItems({this.count, required this.value});

  factory HandOverItems.fromJson(Map<String, dynamic> json) {
    return HandOverItems(
      count: json['@odata.count'],
      value: List<HandOverItem>.from(
        json['value'].map(
          (x) => HandOverItem.fromJson(x),
        ),
      ),
    );
  }
}

class HandOverItem {
  Guid? id;
  String? handOverId;
  Guid? orderDetailId;

  HandOverItem({
    this.id,
    this.handOverId,
    this.orderDetailId,
  });

  HandOverItem.fromJson(Map<String, dynamic> json) {
    id = Guid(json['Id']);
    handOverId = json['HandOverId'];
    orderDetailId = Guid(json['OrderDetailId']);
  }

  Map<String, dynamic> toJson() {
    return {
      'Id': id.toString(),
      'HandOverId': handOverId,
      'OrderDetailId': orderDetailId.toString(),
    };
  }
}
