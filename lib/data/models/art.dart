import 'package:flutter_guid/flutter_guid.dart';
import 'package:intl/intl.dart';

class Arts {
  int? count;
  List<Art> value;

  Arts({this.count, required this.value});

  factory Arts.fromJson(Map<String, dynamic> json) {
    return Arts(
      count: json['@odata.count'],
      value: List<Art>.from(
        json['value'].map(
          (x) => Art.fromJson(x),
        ),
      ),
    );
  }
}

class Art {
  Guid? id;
  String? image;
  DateTime? createdDate;
  Guid? artworkId;

  Art({
    this.id,
    this.image,
    this.createdDate,
    this.artworkId,
  });

  Art.fromJson(Map<String, dynamic> json) {
    id = Guid(json['Id']);
    image = json['Image'];
    createdDate = DateTime.parse(json['CreatedDate']);
    artworkId = Guid(json['ArtworkId']);
  }

  Map<String, dynamic> toJson() {
    return {
      'Id': id.toString(),
      'Image': image,
      'CreatedDate':
          DateFormat("yyyy-MM-ddTHH:mm:ss.SSS'Z'").format(createdDate!),
      'ArtworkId': artworkId.toString(),
    };
  }
}
