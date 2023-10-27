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
  String? avartar;
  String? address;
  String? bio;
  DateTime? createdDate;
  DateTime? lastModifiedDate;
  String? status;
  Guid? rankId;

  Account({
    this.id,
    this.email,
    this.phone,
    this.name,
    this.gender,
    this.avartar,
    this.address,
    this.bio,
    this.createdDate,
    this.lastModifiedDate,
    this.status,
    this.rankId,
  });

  Account.fromJson(Map<String, dynamic> json) {
    id = Guid(json['Id']);
    email = json['Email'];
    phone = json['Phone'];
    name = json['Name'];
    gender = json['Gender'];
    avartar = json['Avartar'];
    address = json['Address'];
    bio = json['Bio'];
    createdDate = DateTime.parse(json['CreatedDate']);
    lastModifiedDate = json['lastModifiedDate'] != null
        ? DateTime.parse(json['lastModifiedDate'])
        : null;
    status = json['Status'];
    rankId = Guid(json['RankId']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id.toString(),
      'email': email,
      'phone': phone,
      'name': name,
      'gender': gender,
      'avartar': avartar,
      'address': address,
      'bio': bio,
      'createdDate':
          DateFormat('yyyy-MM-ddTHH:mm:ss+07:00').format(createdDate!),
      // ignore: prefer_null_aware_operators
      'lastModifiedDate': lastModifiedDate != null
          ? DateFormat('yyyy-MM-ddTHH:mm:ss+07:00').format(lastModifiedDate!)
          : null,
      'status': status,
      'rankId': rankId.toString(),
    };
  }
}
