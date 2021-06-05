class CreateGroupForm {
  CreateGroupForm({
    this.groupName,
    this.description,
    this.rules,
  });

  String groupName;
  String description;
  String rules;

  factory CreateGroupForm.fromJson(Map<String, dynamic> json) =>
      CreateGroupForm(
        groupName: json["groupName"],
        description: json["description"],
        rules: json["rules"],
      );

  Map<String, dynamic> toJson() => {
    "groupName": groupName,
    "description": description,
    "rules": rules,
  };
}
