import 'package:flutter_guid/flutter_guid.dart';

class Accounts {
  Set<Account> value;

  Accounts({required this.value});

  factory Accounts.fromJson(Map<String, dynamic> json) {
    return Accounts(
      value: Set<Account>.from(json['value'].map((x) => Account.fromJson(x))),
    );
  }
}

class Account {
  Guid id;
  String email;
  String phone;
  String name;
  String gender;
  String? avartar;
  String? address;
  String? bio;
  DateTime createdDate;
  DateTime? lastModifiedDate;
  String status;
  Guid rankId;

  Account({
    required this.id,
    required this.email,
    required this.phone,
    required this.name,
    required this.gender,
    this.avartar,
    this.address,
    this.bio,
    required this.createdDate,
    this.lastModifiedDate,
    required this.status,
    required this.rankId,
  });

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      id: Guid(json['Id']),
      email: json['Email'],
      phone: json['Phone'],
      name: json['Name'],
      gender: json['Gender'],
      avartar: json['Avartar'],
      address: json['Address'],
      bio: json['Bio'],
      createdDate: DateTime.parse(json['CreatedDate']),
      lastModifiedDate: json['lastModifiedDate'] != null
          ? DateTime.parse(json['lastModifiedDate'])
          : null,
      status: json['Status'],
      rankId: Guid(json['RankId']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Id': id,
      'Email': email,
      'Phone': phone,
      'Name': name,
      'Gender': gender,
      'Avartar': avartar,
      'Address': address,
      'Bio': bio,
      'CreatedDate': createdDate,
      'LastModifiedDate': lastModifiedDate,
      'Status': status,
      'RankId': rankId,
    };
  }
}
