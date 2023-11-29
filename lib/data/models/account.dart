import 'package:flutter_guid/flutter_guid.dart';
import 'package:intl/intl.dart';

import 'account_role.dart';
import 'rank.dart';

class Accounts {
  int? count;
  Set<Account> value;

  Accounts({this.count, required this.value});

  factory Accounts.fromJson(Map<String, dynamic> json) {
    return Accounts(
      count: json['@odata.count'],
      value: Set<Account>.from(
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
  DateTime? createdDate;
  DateTime? lastModifiedDate;
  String? status;
  Guid? rankId;
  Set<AccountRole>? accountRoles;
  Rank? rank;

  Account({
    this.id,
    this.email,
    this.phone,
    this.name,
    this.gender,
    this.avatar,
    this.address,
    this.bio,
    this.createdDate,
    this.lastModifiedDate,
    this.status,
    this.rankId,
    this.accountRoles,
    this.rank,
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
    createdDate = DateTime.parse(json['CreatedDate']);
    lastModifiedDate = json['LastModifiedDate'] != null
        ? DateTime.parse(json['LastModifiedDate'])
        : null;
    status = json['Status'];
    rankId = Guid(json['RankId']);
    accountRoles = json['AccountRoles'] != null
        ? Set<AccountRole>.from(
            json['AccountRoles'].map(
              (x) => AccountRole.fromJson(x),
            ),
          )
        : null;
    rank = json['Rank'] != null ? Rank.fromJson(json['Rank']) : null;
  }

  Map<String, dynamic> toJson() {
    return {
      'Id': id.toString(),
      'Email': email,
      'Phone': phone,
      'Name': name,
      'Gender': gender,
      'Avartar': avatar,
      'Address': address,
      'Bio': bio,
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
