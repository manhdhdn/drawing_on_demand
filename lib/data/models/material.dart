import 'package:flutter_guid/flutter_guid.dart';

class Materials {
  int? count;
  List<Material> value;

  Materials({this.count, required this.value});

  factory Materials.fromJson(Map<String, dynamic> json) {
    return Materials(
      count: json['@odata.count'],
      value: List<Material>.from(
        json['value'].map(
          (x) => Material.fromJson(x),
        ),
      ),
    );
  }
}

class Material {
  Guid? id;
  String? name;
  String? description;

  Material({
    this.id,
    this.name,
    this.description,
  });

  Material.fromJson(Map<String, dynamic> json) {
    id = Guid(json['Id']);
    name = json['Name'];
    description = json['Description'];
  }

  Map<String, dynamic> toJson() {
    return {
      'Id': id.toString(),
      'Name': name,
      'Description': description,
    };
  }
}
