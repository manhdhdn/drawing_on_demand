import 'package:flutter_guid/flutter_guid.dart';
import 'package:intl/intl.dart';

class Invites {
  int? count;
  List<Invite> value;

  Invites({this.count, required this.value});

  factory Invites.fromJson(Map<String, dynamic> json) {
    return Invites(
      count: json['@odata.count'],
      value: List<Invite>.from(
        json['value'].map(
          (x) => Invite.fromJson(x),
        ),
      ),
    );
  }
}

class Invite {
  Guid? id;
  DateTime? createdDate;
  String? status;
  Guid? receivedBy;
  Guid? requirementId;

  Invite({
    this.id,
    this.createdDate,
    this.status,
    this.receivedBy,
    this.requirementId,
  });

  Invite.fromJson(Map<String, dynamic> json) {
    id = Guid(json['Id']);
    createdDate = DateTime.parse(json['CreatedDate']);
    status = json['Status'];
    receivedBy = Guid(json['ReceivedBy']);
    requirementId = Guid(json['RequirementId']);
  }

  Map<String, dynamic> toJson() {
    return {
      'Id': id.toString(),
      'CreatedDate':
          DateFormat("yyyy-MM-ddTHH:mm:ss.SSS'Z'").format(createdDate!),
      'Status': status,
      'ReceivedBy': receivedBy.toString(),
      'RequirementId': requirementId.toString(),
    };
  }
}
