import 'package:flutter_guid/flutter_guid.dart';

class Categories {
  int? count;
  List<Category> value;

  Categories({this.count, required this.value});

  factory Categories.fromJson(Map<String, dynamic> json) {
    return Categories(
      count: json['@odata.count'],
      value: List<Category>.from(
        json['value'].map(
          (x) => Category.fromJson(x),
        ),
      ),
    );
  }
}

class Category {
  Guid? id;
  String? name;
  String? description;

  Category({
    this.id,
    this.name,
    this.description,
  });

  Category.fromJson(Map<String, dynamic> json) {
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
