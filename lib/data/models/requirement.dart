import 'package:decimal/decimal.dart';
import 'package:flutter_guid/flutter_guid.dart';
import 'package:intl/intl.dart';

import 'category.dart';
import 'material.dart';
import 'surface.dart';

class Requirements {
  int? count;
  Set<Requirement> value;

  Requirements({this.count, required this.value});

  factory Requirements.fromJson(Map<String, dynamic> json) {
    return Requirements(
      count: json['@odata.count'],
      value: Set<Requirement>.from(
        json['value'].map(
          (x) => Requirement.fromJson(x),
        ),
      ),
    );
  }
}

class Requirement {
  Guid? id;
  String? title;
  String? description;
  String? image;
  int? pieces;
  Decimal? budget;
  DateTime? createdDate;
  DateTime? lastModifiedDate;
  String? status;
  Guid? categoryId;
  Guid? surfaceId;
  Guid? materialId;
  Guid? createdBy;
  Category? category;
  Surface? surface;
  Material? material;

  Requirement({
    this.id,
    this.title,
    this.description,
    this.image,
    this.pieces,
    this.budget,
    this.createdDate,
    this.lastModifiedDate,
    this.status,
    this.categoryId,
    this.surfaceId,
    this.materialId,
    this.createdBy,
    this.category,
    this.surface,
    this.material,
  });

  Requirement.fromJson(Map<String, dynamic> json) {
    id = Guid(json['Id']);
    title = json['Title'];
    description = json['Description'];
    image = json['Image'];
    pieces = json['Pieces'];
    budget = Decimal.fromInt(json['Budget']);
    createdDate = DateTime.parse(json['CreatedDate']);
    lastModifiedDate = json['LastModifiedDate'] != null
        ? DateTime.parse(json['LastModifiedDate'])
        : null;
    status = json['Status'];
    categoryId = Guid(json['CategoryId']);
    surfaceId = Guid(json['SurfaceId']);
    materialId = Guid(json['MaterialId']);
    createdBy = Guid(json['CreatedBy']);
    category =
        json['Category'] != null ? Category.fromJson(json['Category']) : null;
    surface =
        json['Surface'] != null ? Surface.fromJson(json['Surface']) : null;
    material =
        json['Material'] != null ? Material.fromJson(json['Material']) : null;
  }

  Map<String, dynamic> toJson() {
    return {
      'Id': id.toString(),
      'Title': title,
      'Description': description,
      'Image': image,
      'Pieces': pieces,
      'Budget': int.parse(budget.toString()),
      'CreatedDate':
          DateFormat('yyyy-MM-ddTHH:mm:ss+07:00').format(createdDate!),
      'LastModifiedDate': lastModifiedDate != null
          ? DateFormat('yyyy-MM-ddTHH:mm:ss+07:00').format(lastModifiedDate!)
          : null,
      'Status': status,
      'CategoryId': categoryId.toString(),
      'SurfaceId': surfaceId.toString(),
      'MaterialId': materialId.toString(),
      'CreatedBy': createdBy.toString(),
    };
  }
}
