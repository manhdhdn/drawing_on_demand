import 'package:flutter_guid/flutter_guid.dart';
import 'package:intl/intl.dart';

class AccountReviews {
  int? count;
  List<AccountReview> value;

  AccountReviews({this.count, required this.value});

  factory AccountReviews.fromJson(Map<String, dynamic> json) {
    return AccountReviews(
      count: json['@odata.count'],
      value: List<AccountReview>.from(
        json['value'].map(
          (x) => AccountReview.fromJson(x),
        ),
      ),
    );
  }
}

class AccountReview {
  Guid? id;
  int? star;
  String? comment;
  DateTime? createdDate;
  DateTime? lastModifiedDate;
  String? status;
  Guid? createdBy;
  Guid? accountId;

  AccountReview({
    this.id,
    this.star,
    this.comment,
    this.createdDate,
    this.lastModifiedDate,
    this.status,
    this.createdBy,
    this.accountId,
  });

  AccountReview.fromJson(Map<String, dynamic> json) {
    id = Guid(json['Id']);
    star = json['Star'];
    comment = json['Comment'];
    createdDate = DateTime.parse(json['CreatedDate']);
    lastModifiedDate = json['LastModifiedDate'] != null
        ? DateTime.parse(json['LastModifiedDate'])
        : null;
    status = json['Status'];
    createdBy = Guid(json['CreatedBy']);
    accountId = Guid(json['AccountId']);
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
      'AccountId': accountId.toString(),
    };
  }
}
