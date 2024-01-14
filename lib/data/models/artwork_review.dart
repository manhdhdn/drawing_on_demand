import 'package:flutter_guid/flutter_guid.dart';
import 'package:intl/intl.dart';

import 'account.dart';

class ArtworkReviews {
  int? count;
  List<ArtworkReview> value;

  ArtworkReviews({this.count, required this.value});

  factory ArtworkReviews.fromJson(Map<String, dynamic> json) {
    return ArtworkReviews(
      count: json['@odata.count'],
      value: List<ArtworkReview>.from(
        json['value'].map(
          (x) => ArtworkReview.fromJson(x),
        ),
      ),
    );
  }
}

class ArtworkReview {
  Guid? id;
  int? star;
  String? comment;
  DateTime? createdDate;
  DateTime? lastModifiedDate;
  String? status;
  Guid? createdBy;
  Guid? artworkId;
  Account? createdByNavigation;

  ArtworkReview({
    this.id,
    this.star,
    this.comment,
    this.createdDate,
    this.lastModifiedDate,
    this.status,
    this.createdBy,
    this.artworkId,
    this.createdByNavigation,
  });

  ArtworkReview.fromJson(Map<String, dynamic> json) {
    id = Guid(json['Id']);
    star = json['Star'];
    comment = json['Comment'];
    createdDate = DateTime.parse(json['CreatedDate']);
    lastModifiedDate = json['LastModifiedDate'] != null
        ? DateTime.parse(json['LastModifiedDate'])
        : null;
    status = json['Status'];
    createdBy = Guid(json['CreatedBy']);
    artworkId = Guid(json['ArtworkId']);
    createdByNavigation = json['CreatedByNavigation'] != null
        ? Account.fromJson(json['CreatedByNavigation'])
        : null;
  }

  Map<String, dynamic> toJson() {
    return {
      'Id': id.toString(),
      'Star': star,
      'Comment': comment,
      'CreatedDate':
          DateFormat("yyyy-MM-ddTHH:mm:ss.SSS'Z'").format(createdDate!),
      'LastModifiedDate': lastModifiedDate != null
          ? DateFormat("yyyy-MM-ddTHH:mm:ss.SSS'Z'").format(lastModifiedDate!)
          : null,
      'Status': status,
      'CreatedBy': createdBy.toString(),
      'ArtworkId': artworkId.toString(),
    };
  }
}
