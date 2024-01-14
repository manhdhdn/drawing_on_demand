import 'package:flutter_guid/flutter_guid.dart';
import 'package:intl/intl.dart';

class Steps {
  int? count;
  List<Step> value;

  Steps({this.count, required this.value});

  factory Steps.fromJson(Map<String, dynamic> json) {
    return Steps(
      count: json['@odata.count'],
      value: List<Step>.from(
        json['value'].map(
          (x) => Step.fromJson(x),
        ),
      ),
    );
  }
}

class Step {
  Guid? id;
  int? number;
  String? detail;
  DateTime? startDate;
  DateTime? estimatedEndDate;
  DateTime? createdDate;
  DateTime? completedDate;
  String? status;
  Guid? requirementId;

  Step({
    this.id,
    this.number,
    this.detail,
    this.startDate,
    this.estimatedEndDate,
    this.createdDate,
    this.completedDate,
    this.status,
    this.requirementId,
  });

  Step.fromJson(Map<String, dynamic> json) {
    id = Guid(json['Id']);
    number = json['Number'];
    detail = json['Detail'];
    startDate = DateTime.parse(json['StartDate']);
    estimatedEndDate = DateTime.parse(json['EstimatedEndDate']);
    createdDate = DateTime.parse(json['CreatedDate']);
    completedDate = json['CompletedDate'] != null ? DateTime.parse(json['CompletedDate']) : null;
    status = json['Status'];
    requirementId = Guid(json['RequirementId']);
  }

  Map<String, dynamic> toJson() {
    return {
      'Id': id.toString(),
      'Number': number,
      'Detail': detail,
      'StartDate': DateFormat("yyyy-MM-ddTHH:mm:ss.SSS'Z'").format(startDate!),
      'EstimatedEndDate': DateFormat("yyyy-MM-ddTHH:mm:ss.SSS'Z'").format(estimatedEndDate!),
      'CreatedDate': DateFormat("yyyy-MM-ddTHH:mm:ss.SSS'Z'").format(createdDate!),
      'CompletedDate': completedDate != null ? DateFormat("yyyy-MM-ddTHH:mm:ss.SSS'Z'").format(completedDate!) : null,
      'Status': status,
      'RequirementId': requirementId.toString(),
    };
  }
}
