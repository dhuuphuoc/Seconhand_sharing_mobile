import 'package:secondhand_sharing/models/contact_model/contact.dart';

class ContactModel {
  ContactModel({
    this.succeeded,
    this.message,
    this.data,
  });

  bool succeeded;
  dynamic message;
  Contact data;

  factory ContactModel.fromJson(Map<String, dynamic> json) => ContactModel(
        succeeded: json["succeeded"],
        message: json["message"],
        data: Contact.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "succeeded": succeeded,
        "message": message,
        "data": data.toJson(),
      };
}
