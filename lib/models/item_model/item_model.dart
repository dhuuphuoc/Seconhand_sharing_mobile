import 'package:secondhand_sharing/models/item_model/item.dart';

class ItemModel {
  ItemModel({
    this.pageNumber,
    this.pageSize,
    this.succeeded,
    this.message,
    this.errors,
    this.items,
  });

  int pageNumber;
  int pageSize;
  bool succeeded;
  String message;
  String errors;
  List<Item> items;

  factory ItemModel.fromJson(Map<String, dynamic> json) => ItemModel(
        pageNumber: json["pageNumber"],
        pageSize: json["pageSize"],
        succeeded: json["succeeded"],
        message: json["message"],
        errors: json["errors"],
        items: List<Item>.from(json["data"].map((x) => Item.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "pageNumber": pageNumber,
        "pageSize": pageSize,
        "succeeded": succeeded,
        "message": message,
        "errors": errors,
        "data": List<dynamic>.from(items.map((x) => x.toJson())),
      };
}
