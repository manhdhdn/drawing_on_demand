import 'package:flutter_guid/flutter_guid.dart';

class Surfaces {
  int? count;
  List<Surface> value;

  Surfaces({this.count, required this.value});

  factory Surfaces.fromJson(Map<String, dynamic> json) {
    return Surfaces(
      count: json['@odata.count'],
      value: List<Surface>.from(
        json['value'].map(
          (x) => Surface.fromJson(x),
        ),
      ),
    );
  }
}

class Surface {
  Guid? id;
  String? name;
  String? description;

  Surface({
    this.id,
    this.name,
    this.description,
  });

  Surface.fromJson(Map<String, dynamic> json) {
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
