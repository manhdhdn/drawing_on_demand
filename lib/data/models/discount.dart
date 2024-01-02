import 'package:flutter_guid/flutter_guid.dart';
import 'package:intl/intl.dart';

class Discounts {
  int? count;
  List<Discount> value;

  Discounts({this.count, required this.value});

  factory Discounts.fromJson(Map<String, dynamic> json) {
    return Discounts(
      count: json['@odata.count'],
      value: List<Discount>.from(
        json['value'].map(
          (x) => Discount.fromJson(x),
        ),
      ),
    );
  }
}

class Discount {
  Guid? id;
  int? number;
  double? discountPercent;
  DateTime? startDate;
  DateTime? endDate;
  String? status;

  Discount({
    this.id,
    this.number,
    this.discountPercent,
    this.startDate,
    this.endDate,
    this.status,
  });

  Discount.fromJson(Map<String, dynamic> json) {
    id = Guid(json['Id']);
    number = json['Number'];
    discountPercent = double.tryParse(json['DiscountPercent'].toString());
    startDate = DateTime.parse(json['StartDate']);
    endDate = DateTime.parse(json['EndDate']);
    status = json['Status'];
  }

  Map<String, dynamic> toJson() {
    return {
      'Id': id.toString(),
      'Number': number,
      'DiscountPercent': discountPercent,
      'StartDate': DateFormat("yyyy-MM-ddTHH:mm:ss.SSS'Z'").format(startDate!),
      'EndDate': DateFormat("yyyy-MM-ddTHH:mm:ss.SSS'Z'").format(endDate!),
      'Status': status,
    };
  }
}
