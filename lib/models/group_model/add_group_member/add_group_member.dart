class AddGroupMemberForm {
  AddGroupMemberForm({
    this.email,
    this.groupId,
  });

  String email;
  int groupId;

  factory AddGroupMemberForm.fromJson(Map<String, dynamic> json) => AddGroupMemberForm(
    email: json["email"],
    groupId: json["groupId"],
  );

  Map<String, dynamic> toJson() => {
    "email": email,
    "groupId": groupId,
  };
}