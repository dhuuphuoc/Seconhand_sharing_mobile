class Contact {
  Contact({
    this.email,
    this.phoneNumber,
  });

  String email;
  String phoneNumber;

  factory Contact.fromJson(Map<String, dynamic> json) => Contact(
        email: json["email"],
        phoneNumber: json["phoneNumber"],
      );

  Map<String, dynamic> toJson() => {
        "email": email,
        "phoneNumber": phoneNumber,
      };
}
