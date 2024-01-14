import 'package:flutter_guid/flutter_guid.dart';
import 'package:intl/intl.dart';

class Ranks {
  int? count;
  List<Rank> value;

  Ranks({this.count, required this.value});

  factory Ranks.fromJson(Map<String, dynamic> json) {
    return Ranks(
      count: json['@odata.count'],
      value: List<Rank>.from(
        json['value'].map(
          (x) => Rank.fromJson(x),
        ),
      ),
    );
  }
}

class Rank {
  Guid? id;
  String? name;
  double? income;
  double? spend;
  double? fee;
  int? connect;
  DateTime? createdDate;
  DateTime? lastModifiedDate;

  Rank({
    this.id,
    this.name,
    this.income,
    this.spend,
    this.fee,
    this.connect,
    this.createdDate,
    this.lastModifiedDate,
  });

  Rank.fromJson(Map<String, dynamic> json) {
    id = Guid(json['Id']);
    name = json['Name'];
    income = double.tryParse(json['Income'].toString());
    spend = double.tryParse(json['Spend'].toString());
    fee = double.tryParse(json['Fee'].toString());
    connect = json['Connect'];
    createdDate = DateTime.parse(json['CreatedDate']);
    lastModifiedDate = json['LastModifiedDate'] != null
        ? DateTime.parse(json['LastModifiedDate'])
        : null;
  }

  Map<String, dynamic> toJson() {
    return {
      'Id': id.toString(),
      'Name': name,
      'Income': income,
      'Spend': spend,
      'Fee': fee,
      'Connect': connect,
      'CreatedDate':
          DateFormat("yyyy-MM-ddTHH:mm:ss.SSS'Z'").format(createdDate!),
      'LastModifiedDate': lastModifiedDate != null
          ? DateFormat("yyyy-MM-ddTHH:mm:ss.SSS'Z'").format(lastModifiedDate!)
          : null,
    };
  }
}
