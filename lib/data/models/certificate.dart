import 'package:flutter_guid/flutter_guid.dart';
import 'package:intl/intl.dart';

class Certificates {
  int? count;
  List<Certificate> value;

  Certificates({this.count, required this.value});

  factory Certificates.fromJson(Map<String, dynamic> json) {
    return Certificates(
      count: json['@odata.count'],
      value: List<Certificate>.from(
        json['value'].map(
          (x) => Certificate.fromJson(x),
        ),
      ),
    );
  }
}

class Certificate {
  Guid? id;
  String? name;
  String? image;
  DateTime? achievedDate;
  String? description;
  Guid? accountId;

  Certificate({
    this.id,
    this.name,
    this.image,
    this.achievedDate,
    this.description,
    this.accountId,
  });

  Certificate.fromJson(Map<String, dynamic> json) {
    id = Guid(json['Id']);
    name = json['Name'];
    image = json['Image'];
    achievedDate = json['AchievedDate'] != null ? DateTime.parse(json['AchievedDate']) : null;
    description = json['Description'];
    accountId = Guid(json['AccountId']);
  }

  Map<String, dynamic> toJson() {
    return {
      'Id': id.toString(),
      'Name': name,
      'Image': image,
      'AchievedDate': DateFormat("yyyy-MM-ddTHH:mm:ss.SSS'Z'").format(achievedDate!),
      'Description': description,
      'AccountId': accountId.toString(),
    };
  }
}
