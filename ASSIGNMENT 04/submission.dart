class Submission {
  final int? id;
  final String name;
  final String email;
  final String phone;
  final String address;
  final String gender;

  Submission({this.id, required this.name, required this.email, required this.phone, required this.address, required this.gender});

  factory Submission.fromJson(Map<String, dynamic> json) {
    return Submission(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      address: json['address'],
      gender: json['gender'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
      'gender': gender,
    };
  }
}
