import 'package:flutter/material.dart';
import 'main.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  static const routeName = '/register';
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final regController = TextEditingController();
  final List<String> _bloodGroup = <String>[
    'A+ (A positive)',
    'A- (A negative)',
    'B+ (B positive)',
    'B- (B negative)',
    'AB+ (AB positive)',
    'AB− (AB negative)',
    'O+ (O positive)',
    'O− (O negative)'
  ];
  String? dropdownValue1;
  final List<String> _documentType = <String>[
    'Citizenship',
    'Passport',
    'National Id'
  ];
  String? dropdownValue2;

  @override
  void dispose() {
    regController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
          child: ListView(
        padding:
            EdgeInsets.only(right: 10.0, bottom: 20.0, left: 10.0, top: 20),

        // crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            controller: regController,
            decoration: InputDecoration(
                fillColor: Color.fromARGB(217, 217, 217, 217),
                //                    border: OutlineInputBorder(),
                filled: true,
                labelText: 'Name',
                labelStyle: TextStyle(fontSize: 21),
                hintText: 'Full Name',
                hintStyle: TextStyle(fontSize: 10)),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 20.0),
          ),
          TextFormField(
            controller: regController,
            decoration: InputDecoration(
                fillColor: Color.fromARGB(217, 217, 217, 217),
                // border: OutlineInputBorder(),
                filled: true,
                labelText: 'Address',
                labelStyle: TextStyle(fontSize: 21),
                hintText: 'Address'),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 20.0),
          ),
          TextFormField(
            controller: regController,
            decoration: InputDecoration(
                fillColor: Color.fromARGB(217, 217, 217, 217),
                //border: OutlineInputBorder(),
                filled: true,
                labelText: 'Phone Number',
                labelStyle: TextStyle(fontSize: 21),
                hintText: 'Phone Number'),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 20.0),
          ),
          TextFormField(
            controller: regController,
            decoration: InputDecoration(
                fillColor: Color.fromARGB(217, 217, 217, 217),
                //border: OutlineInputBorder(),
                filled: true,
                labelText: 'Email ',
                labelStyle: TextStyle(fontSize: 21),
                hintText: 'email@example.com'),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 20.0),
          ),
          TextFormField(
            controller: regController,
            decoration: InputDecoration(
                fillColor: Color.fromARGB(217, 217, 217, 217),
                //border: OutlineInputBorder(),
                filled: true,
                labelText: 'Password ',
                labelStyle: TextStyle(fontSize: 21),
                hintText: 'password'),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 20.0),
          ),
          TextFormField(
            controller: regController,
            decoration: InputDecoration(
                fillColor: Color.fromARGB(217, 217, 217, 217),
                //border: OutlineInputBorder(),
                filled: true,
                labelText: 'Date Of Birth',
                labelStyle: TextStyle(fontSize: 21),
                hintText: 'DOB'),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 20.0),
          ),
          Container(
              padding: EdgeInsets.only(bottom: 20.0),
              decoration: BoxDecoration(
                color: Color.fromARGB(217, 217, 217, 217),
              ),
              child: DropdownButton<String>(
                hint: Text('Blood Group'),
                style: TextStyle(fontSize: 21),
                value: dropdownValue1,
                isExpanded: true,
                dropdownColor: Color.fromARGB(217, 217, 217, 217),
                items: _bloodGroup.map((bloodGroup) {
                  return DropdownMenuItem(
                    value: bloodGroup,
                    child: Text(bloodGroup),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    dropdownValue1 = newValue!;
                  });
                },
              )),
          Padding(
            padding: EdgeInsets.only(bottom: 20),
          ),
          Container(
            padding: const EdgeInsets.only(bottom: 20),
            child: Text("Additional Documents", style: TextStyle(fontSize: 35)),
          ),
          Container(
              padding: EdgeInsets.only(bottom: 20.0),
              decoration: BoxDecoration(
                color: Color.fromARGB(217, 217, 217, 217),
              ),
              child: DropdownButton<String>(
                hint: Text('Document Type'),
                style: TextStyle(
                  fontSize: 21,
                ),
                value: dropdownValue2,
                isExpanded: true,
                dropdownColor: Color.fromARGB(217, 217, 217, 217),
                items: _documentType.map((documentType) {
                  return DropdownMenuItem(
                    value: documentType,
                    child: Text(documentType),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    dropdownValue2 = newValue!;
                  });
                },
              )),
          Padding(
            padding: EdgeInsets.only(bottom: 20.0),
          ),
          TextFormField(
            controller: regController,
            decoration: InputDecoration(
                fillColor: Color.fromARGB(217, 217, 217, 217),
                //border: OutlineInputBorder(),
                filled: true,
                labelText: 'Document ID ',
                labelStyle: TextStyle(fontSize: 21),
                hintText: 'ID'),
          ),
          ElevatedButton(
            onPressed: () {},
            child: Text(
              'Submit',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
        ],
      )),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  static const routeName = '/login';

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
          child: ListView(
        padding:
            EdgeInsets.only(right: 10.0, bottom: 20.0, left: 10.0, top: 20),

        // crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            decoration: InputDecoration(
                fillColor: Color.fromARGB(217, 217, 217, 217),
                //                    border: OutlineInputBorder(),
                filled: true,
                labelText: 'Email address',
                hintText: 'Email',
                hintStyle: TextStyle(fontSize: 16)),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 20.0),
          ),
          TextFormField(
            decoration: InputDecoration(
                fillColor: Color.fromARGB(217, 217, 217, 217),
                //border: OutlineInputBorder(),
                filled: true,
                labelText: 'Password ',
                hintText: 'password'),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 20.0),
          ),
        ],
      )),
    );
  }
}

class Auth extends StatefulWidget {
  @override
  _AuthState createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  bool showSignUp = true;
  String reg = "Register ";
  String log = "Login";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(showSignUp ? reg : log),
          elevation: 16.0,
          actions: [
            IconButton(
                icon: Icon(Icons.swap_horiz),
                onPressed: () {
                  setState(() {
                    showSignUp = !showSignUp;
                  });
                })
          ],
        ),
        // ternary operator
        body: Container(
            child: Column(
          children: [
            Expanded(
                child: showSignUp
                    ? RegisterPage()
                    : LoginPage()), // ternary operator
            TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const MyHomePage()),
                  );
                },
                child: Text("Go home"))
          ],
        )));
  }
}
