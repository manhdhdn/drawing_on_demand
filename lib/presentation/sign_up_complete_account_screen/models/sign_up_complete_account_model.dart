import 'package:flutter_guid/flutter_guid.dart';

/// This class defines the variables used in the [sign_up_complete_account_screen],
/// and is typically used to hold data that is passed between different parts of the application.
class SignUpCompleteAccountModel {
  String? email;
  String? phone;
  String? name;
  String? gender;
  DateTime? createdDate;
  String? status;
  Guid? rankId;

  SignUpCompleteAccountModel({
    this.email,
    this.phone,
    this.name,
    this.gender,
    this.createdDate,
    this.status,
    this.rankId,
  });

  Map<String, dynamic> toJson() {
    return {
      'Email': email,
      'Phone': phone,
      'Name': name,
      'Gender': gender,
      'CreatedDate': createdDate,
      'Status': status,
      'RankId': rankId,
    };
  }
}
