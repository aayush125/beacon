import 'dart:convert';

class User {
  String? name;
  String? email;
  String? phone;
  String? token;
  String? dateOfBirth;
  String? blood;
  String? docID;
  String? address;
  String? docType;


  User({this.name, this.email, this.phone, this.token, this.address, this.blood, this.dateOfBirth, this.docID, this.docType});

  factory User.fromReqBody(String body) {
    Map<String, dynamic> json = jsonDecode(body);

    return User(
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      token: json['token'],
      dateOfBirth: json['dateOfBirth'],
      blood: json['blood'],
      docID: json['docID'],
      address: json['address'],
      docType: json['docType'],
    );
  }

  void printAll() {
    print("name : $name\n");
    print("email : $email\n");
    print("phone : $phone\n");
    print("token : $token\n");
    print("dateOfBirth : $dateOfBirth\n");
    print("blood : $blood\n");
    print("docID : $docID\n");
    print("address : $address\n");
    print("docType : $docType\n");
  }

  bool isLoggedOut() {
    return token == null;
  }
}