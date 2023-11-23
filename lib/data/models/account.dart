import 'package:drawing_on_demand/data/models/account_role.dart';
import 'package:flutter_guid/flutter_guid.dart';
import 'package:intl/intl.dart';

class Accounts {
  Set<Account> value;

  Accounts({required this.value});

  factory Accounts.fromJson(Map<String, dynamic> json) {
    return Accounts(
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
    createdDate = json['CreatedDate'] != null
        ? DateTime.parse(json['CreatedDate'])
        : null;
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
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id.toString(),
      'email': email,
      'phone': phone,
      'name': name,
      'gender': gender,
      'avartar': avatar,
      'address': address,
      'bio': bio,
      'createdDate':
          DateFormat('yyyy-MM-ddTHH:mm:ss+07:00').format(createdDate!),
      'lastModifiedDate': lastModifiedDate != null
          ? DateFormat('yyyy-MM-ddTHH:mm:ss+07:00').format(lastModifiedDate!)
          : null,
      'status': status,
      'rankId': rankId.toString(),
    };
  }
}
