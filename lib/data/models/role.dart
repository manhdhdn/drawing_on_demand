import 'package:flutter_guid/flutter_guid.dart';

class Roles {
  int? count;
  List<Role> value;

  Roles({this.count, required this.value});

  factory Roles.fromJson(Map<String, dynamic> json) {
    return Roles(
      count: json['@odata.count'],
      value: List<Role>.from(
        json['value'].map(
          (x) => Role.fromJson(x),
        ),
      ),
    );
  }
}

class Role {
  Guid? id;
  String? name;

  Role({
    this.id,
    this.name,
  });

  Role.fromJson(Map<String, dynamic> json) {
    id = Guid(json['Id']);
    name = json['Name'];
  }

  Map<String, dynamic> toJson() {
    return {
      'Id': id.toString(),
      'Name': name,
    };
  }
}
