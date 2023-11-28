import 'package:flutter_guid/flutter_guid.dart';
import 'package:intl/intl.dart';

import 'role.dart';

class AccountRoles {
  Set<AccountRole> value;

  AccountRoles({required this.value});

  factory AccountRoles.fromJson(Map<String, dynamic> json) {
    return AccountRoles(
      value: Set<AccountRole>.from(
        json['value'].map(
          (x) => AccountRole.fromJson(x),
        ),
      ),
    );
  }
}

class AccountRole {
  Guid? id;
  DateTime? addedDate;
  DateTime? lastModifiedDate;
  String? status;
  Guid? accountId;
  Guid? roleId;
  Role? role;

  AccountRole({
    this.id,
    this.addedDate,
    this.lastModifiedDate,
    this.status,
    this.accountId,
    this.roleId,
    this.role,
  });

  AccountRole.fromJson(Map<String, dynamic> json) {
    id = Guid(json['Id']);
    addedDate = DateTime.parse(json['AddedDate']);
    lastModifiedDate = json['LastModifiedDate'] != null
        ? DateTime.parse(json['LastModifiedDate'])
        : null;
    status = json['Status'];
    accountId = Guid(json['AccountId']);
    roleId = Guid(json['RoleId']);
    role = json['Role'] != null ? Role.fromJson(json['Role']) : null;
  }

  Map<String, dynamic> toJson() {
    return {
      'Id': id.toString(),
      'AddedDate': DateFormat('yyyy-MM-ddTHH:mm:ss+07:00').format(addedDate!),
      'LastModifiedDate': lastModifiedDate != null
          ? DateFormat('yyyy-MM-ddTHH:mm:ss+07:00').format(lastModifiedDate!)
          : null,
      'Status': status,
      'AccountId': accountId.toString(),
      'RoleId': roleId.toString(),
    };
  }
}
