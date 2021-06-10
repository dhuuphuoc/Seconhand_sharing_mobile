class CreateGroupForm {
  String _groupName;
  String _description;
  String _rules;

  CreateGroupForm(this._groupName, this._description, this._rules);

  String get groupName => _groupName;

  String get description => _description;

  String get rules => _rules;


  Map<String, dynamic> toJson() => {
    "groupName": groupName,
    "description": description,
    "rules": rules,
  };
}
