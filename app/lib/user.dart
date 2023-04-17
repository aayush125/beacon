import 'dart:convert';

class User {
  int? id;
  String? name;
  String? email;
  String? phone;
  String? token;

  User({this.id, this.name, this.email, this.phone, this.token});

  factory User.fromReqBody(String body) {
    Map<String, dynamic> json = jsonDecode(body);

    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      token: json['token'],
    );
  }

  void printAll() {
    print("id : $id\n");
    print("name : $name\n");
    print("email : $email\n");
    print("phone : $phone\n");
    print("token : $token\n");
  }
}