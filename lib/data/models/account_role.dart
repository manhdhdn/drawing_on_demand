import 'package:flutter_guid/flutter_guid.dart';
import 'package:intl/intl.dart';

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

  AccountRole({
    this.id,
    this.addedDate,
    this.lastModifiedDate,
    this.status,
    this.accountId,
    this.roleId,
  });

  AccountRole.fromJson(Map<String, dynamic> json) {
    id = Guid(json['Id']);
    addedDate = DateTime.parse(json['AddedDate']);
    lastModifiedDate = json['lastModifiedDate'] != null
        ? DateTime.parse(json['lastModifiedDate'])
        : null;
    status = json['Status'];
    accountId = Guid(json['AccountId']);
    roleId = Guid(json['RoleId']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id.toString(),
      'addedDate': DateFormat('yyyy-MM-ddTHH:mm:ss+07:00').format(addedDate!),
      'lastModifiedDate': lastModifiedDate != null
          ? DateFormat('yyyy-MM-ddTHH:mm:ss+07:00').format(lastModifiedDate!)
          : null,
      'status': status,
      'accountId': accountId.toString(),
      'roleId': roleId.toString(),
    };
  }
}
