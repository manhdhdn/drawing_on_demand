import 'package:flutter_guid/flutter_guid.dart';
import 'package:intl/intl.dart';

import 'account.dart';
import 'art.dart';
import 'artwork_review.dart';
import 'category.dart';
import 'material.dart';
import 'surface.dart';

class Artworks {
  int? count;
  Set<Artwork> value;

  Artworks({this.count, required this.value});

  factory Artworks.fromJson(Map<String, dynamic> json) {
    return Artworks(
      count: json['@odata.count'],
      value: Set<Artwork>.from(
        json['value'].map(
          (x) => Artwork.fromJson(x),
        ),
      ),
    );
  }
}

class Artwork {
  Guid? id;
  String? title;
  String? description;
  double? price;
  int? pieces;
  int? inStock;
  DateTime? createdDate;
  DateTime? lastModifiedDate;
  String? status;
  Guid? categoryId;
  Guid? surfaceId;
  Guid? materialId;
  Guid? createdBy;
  Set<ArtworkReview>? artworkReviews;
  Set<Art>? arts;
  Account? createdByNavigation;
  Category? category;
  Surface? surface;
  Material? material;

  Artwork({
    this.id,
    this.title,
    this.description,
    this.price,
    this.pieces,
    this.inStock,
    this.createdDate,
    this.lastModifiedDate,
    this.status,
    this.categoryId,
    this.surfaceId,
    this.materialId,
    this.createdBy,
    this.artworkReviews,
    this.arts,
    this.createdByNavigation,
    this.category,
    this.surface,
    this.material,
  });

  Artwork.fromJson(Map<String, dynamic> json) {
    id = Guid(json['Id']);
    title = json['Title'];
    description = json['Description'];
    price = double.tryParse(json['Price'].toString());
    pieces = json['Pieces'];
    inStock = json['InStock'];
    createdDate = DateTime.parse(json['CreatedDate']);
    lastModifiedDate = json['LastModifiedDate'] != null
        ? DateTime.parse(json['LastModifiedDate'])
        : null;
    status = json['Status'];
    categoryId = Guid(json['CategoryId']);
    surfaceId = Guid(json['SurfaceId']);
    materialId = Guid(json['MaterialId']);
    createdBy = Guid(json['CreatedBy']);
    artworkReviews = json['ArtworkReviews'] != null
        ? Set<ArtworkReview>.from(json['ArtworkReviews'].map(
            (x) => ArtworkReview.fromJson(x),
          ))
        : null;
    arts = json['Arts'] != null
        ? Set<Art>.from(json['Arts'].map(
            (x) => Art.fromJson(x),
          ))
        : null;
    createdByNavigation = json['CreatedByNavigation'] != null
        ? Account.fromJson(json['CreatedByNavigation'])
        : null;
    category =
        json['Category'] != null ? Category.fromJson(json['Category']) : null;
    surface =
        json['Surface'] != null ? Surface.fromJson(json['Surface']) : null;
    material =
        json['Material'] != null ? Material.fromJson(json['Material']) : null;
  }

  Map<String, dynamic> toJson() {
    return {
      'Id': id,
      'Title': title,
      'Description': description,
      'Price': price,
      'Pieces': pieces,
      'InStock': inStock,
      'CreatedDate':
          DateFormat('yyyy-MM-ddTHH:mm:ss+07:00').format(createdDate!),
      'LastModifiedDate': lastModifiedDate != null
          ? DateFormat('yyyy-MM-ddTHH:mm:ss+07:00').format(lastModifiedDate!)
          : null,
      'Status': status,
      'CategoryId': categoryId,
      'SurfaceId': surfaceId,
      'MaterialId': materialId,
      'CreatedBy': createdBy,
    };
  }
}
