import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

class TimestampConverter extends JsonConverter<DateTime?, dynamic> {
  const TimestampConverter();

  @override
  DateTime? fromJson(dynamic json) {
    if (json == null || json == FieldValue.serverTimestamp()) {
      return null;
    }
    if (json is Timestamp) {
      return json.toDate();
    }
    throw ArgumentError('Unknown value ($json) of DateTime.');
  }

  @override
  dynamic toJson(DateTime? object) {
    if (object == null) {
      return FieldValue.serverTimestamp();
    }
    return Timestamp.fromDate(object);
  }
}
