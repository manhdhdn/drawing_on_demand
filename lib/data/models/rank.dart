import 'package:decimal/decimal.dart';
import 'package:flutter_guid/flutter_guid.dart';
import 'package:intl/intl.dart';

class Ranks {
  int? count;
  Set<Rank> value;

  Ranks({this.count, required this.value});

  factory Ranks.fromJson(Map<String, dynamic> json) {
    return Ranks(
      count: json['@odata.count'],
      value: Set<Rank>.from(
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
  Decimal? income;
  Decimal? spend;
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
    income = Decimal.fromInt(json['Income']);
    spend = Decimal.fromInt(json['Spend']);
    fee = json['Fee'];
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
      'Income': double.parse(income.toString()),
      'Spend': double.parse(spend.toString()),
      'Fee': fee,
      'Connect': connect,
      'CreatedDate':
          DateFormat('yyyy-MM-ddTHH:mm:ss+07:00').format(createdDate!),
      'LastModifiedDate': lastModifiedDate != null
          ? DateFormat('yyyy-MM-ddTHH:mm:ss+07:00').format(lastModifiedDate!)
          : null,
    };
  }
}
