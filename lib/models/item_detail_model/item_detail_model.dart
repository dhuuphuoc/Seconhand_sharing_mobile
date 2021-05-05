// To parse this JSON data, do
//
//     final itemDetailModel = itemDetailModelFromJson(jsonString);

import 'dart:convert';

import 'package:secondhand_sharing/models/address_model/address_model.dart';
import 'package:secondhand_sharing/models/item_detail_model/item_detail.dart';

ItemDetailModel itemDetailModelFromJson(String str) =>
    ItemDetailModel.fromJson(json.decode(str));

String itemDetailModelToJson(ItemDetailModel data) =>
    json.encode(data.toJson());

class ItemDetailModel {
  ItemDetailModel({
    this.succeeded,
    this.message,
    this.data,
  });

  bool succeeded;
  dynamic message;
  ItemDetail data;

  factory ItemDetailModel.fromJson(Map<String, dynamic> json) =>
      ItemDetailModel(
        succeeded: json["succeeded"],
        message: json["message"],
        data: ItemDetail.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "succeeded": succeeded,
        "message": message,
        "data": data.toJson(),
      };
}
