import 'package:flutter_guid/flutter_guid.dart';
import 'package:intl/intl.dart';

import 'account_review.dart';
import 'account_role.dart';
import 'rank.dart';

class Accounts {
  int? count;
  List<Account> value;

  Accounts({this.count, required this.value});

  factory Accounts.fromJson(Map<String, dynamic> json) {
    return Accounts(
      count: json['@odata.count'],
      value: List<Account>.from(
        json['value'].map(
          (x) => Account.fromJson(x),
        ),
      ),
    );
  }
}

class Account {
  Guid? id;
  String? email;
  String? phone;
  String? name;
  String? gender;
  String? avatar;
  String? address;
  String? bio;
  int? availableConnect;
  DateTime? createdDate;
  DateTime? lastModifiedDate;
  String? status;
  Guid? rankId;
  List<AccountRole>? accountRoles;
  Rank? rank;
  List<AccountReview>? accountReviewAccounts;

  Account({
    this.id,
    this.email,
    this.phone,
    this.name,
    this.gender,
    this.avatar,
    this.address,
    this.bio,
    this.availableConnect,
    this.createdDate,
    this.lastModifiedDate,
    this.status,
    this.rankId,
    this.accountRoles,
    this.rank,
    this.accountReviewAccounts,
  });

  Account.fromJson(Map<String, dynamic> json) {
    id = Guid(json['Id']);
    email = json['Email'];
    phone = json['Phone'];
    name = json['Name'];
    gender = json['Gender'];
    avatar = json['Avatar'];
    address = json['Address'];
    bio = json['Bio'];
    availableConnect = json['AvailableConnect'];
    createdDate = DateTime.parse(json['CreatedDate']);
    lastModifiedDate = json['LastModifiedDate'] != null
        ? DateTime.parse(json['LastModifiedDate'])
        : null;
    status = json['Status'];
    rankId = Guid(json['RankId']);
    accountRoles = json['AccountRoles'] != null
        ? List<AccountRole>.from(
            json['AccountRoles'].map(
              (x) => AccountRole.fromJson(x),
            ),
          )
        : null;
    rank = json['Rank'] != null ? Rank.fromJson(json['Rank']) : null;
    accountReviewAccounts = json['AccountReviewAccounts'] != null
        ? List<AccountReview>.from(
            json['AccountReviewAccounts'].map(
              (x) => AccountReview.fromJson(x),
            ),
          )
        : null;
  }

  Map<String, dynamic> toJson() {
    return {
      'Id': id.toString(),
      'Email': email,
      'Phone': phone,
      'Name': name,
      'Gender': gender,
      'Avatar': avatar,
      'Address': address,
      'Bio': bio,
      'AvailableConnect': availableConnect,
      'CreatedDate':
          DateFormat('yyyy-MM-ddTHH:mm:ss+07:00').format(createdDate!),
      'LastModifiedDate': lastModifiedDate != null
          ? DateFormat('yyyy-MM-ddTHH:mm:ss+07:00').format(lastModifiedDate!)
          : null,
      'Status': status,
      'RankId': rankId.toString(),
    };
  }
}
