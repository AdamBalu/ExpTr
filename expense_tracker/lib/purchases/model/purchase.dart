import 'package:json_annotation/json_annotation.dart';

import '../../common/enums/saving_category.dart';

part 'purchase.g.dart';

@JsonSerializable()
class Purchase {
  final String name;
  final String description;
  final double cost;
  final String id;
  final String imageUrl;

  final DateTime date;

  final ItemCategory category;

  Purchase(
      this.name, this.description, this.cost, this.category, this.id, this.date, this.imageUrl);

  factory Purchase.fromJson(Map<String, dynamic> json) => _$PurchaseFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$PurchaseToJson(this);
}
