import 'package:flutter_guid/flutter_guid.dart';

class Sizes {
  int? count;
  List<Size> value;

  Sizes({this.count, required this.value});

  factory Sizes.fromJson(Map<String, dynamic> json) {
    return Sizes(
      count: json['@odata.count'],
      value: List<Size>.from(
        json['value'].map(
          (x) => Size.fromJson(x),
        ),
      ),
    );
  }
}

class Size {
  Guid? id;
  double? width;
  double? length;
  Guid? requirementId;
  Guid? artworkId;

  Size({
    this.id,
    this.width,
    this.length,
    this.requirementId,
    this.artworkId,
  });

  Size.fromJson(Map<String, dynamic> json) {
    id = Guid(json['Id']);
    width = double.tryParse(json['Width'].toString());
    length = double.tryParse(json['Length'].toString());
    requirementId = Guid(json['RequirementId']);
    artworkId = Guid(json['ArtworkId']);
  }

  Map<String, dynamic> toJson() {
    return {
      'Id': id.toString(),
      'Width': width,
      'Length': length,
      'RequirementId': requirementId?.toString(),
      'ArtworkId': artworkId?.toString(),
    };
  }
}
