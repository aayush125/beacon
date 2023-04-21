import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main.dart';
import 'prefs.dart';
import 'usercubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth.dart';
import 'user.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  static const routeName = '/register';
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final nameController = TextEditingController();
  final addController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final passController = TextEditingController();
  final dobController = TextEditingController();
  final docidController = TextEditingController();

  AuthAPI _authAPI = AuthAPI();

  final List<String> _bloodGroup = <String>[
    'A+ (A positive)',
    'A− (A negative)',
    'B+ (B positive)',
    'B− (B negative)',
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
  bool? _passVisible;

  @override
  void initState() {
    _passVisible = false;
  }

  @override
  void dispose() {
    nameController.dispose();
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
            controller: nameController,
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
            controller: addController,
            keyboardType: TextInputType.streetAddress,
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
            controller: phoneController,
            keyboardType: TextInputType.phone,
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
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
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
            controller: passController,
            obscureText: !_passVisible!,
            keyboardType: TextInputType.visiblePassword,
            enableSuggestions: false,
            autocorrect: false,
            decoration: InputDecoration(
                fillColor: Color.fromARGB(217, 217, 217, 217),
                //border: OutlineInputBorder(),
                filled: true,
                labelText: 'Password ',
                labelStyle: TextStyle(fontSize: 21),
                hintText: 'password',
                suffixIcon: IconButton(
                  icon: Icon(
                    _passVisible! ? Icons.visibility : Icons.visibility_off,
                    color: Theme.of(context).primaryColorDark,
                  ),
                  onPressed: () {
                    setState(() {
                      _passVisible = !_passVisible!;
                    });
                  },
                )),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 20.0),
          ),
          TextFormField(
            controller: dobController,
            keyboardType: TextInputType.datetime,
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
          DropdownButtonFormField(
            decoration: InputDecoration(
                fillColor: Color.fromARGB(217, 217, 217, 217),
                filled: true,
                labelText: 'Blood Group',
                labelStyle: TextStyle(fontSize: 21),
                hintText: 'Select your blood group'),
            value: dropdownValue1,
            onChanged: (String? newValue) {
              setState(() {
                dropdownValue1 = newValue!;
              });
            },
            items: _bloodGroup.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 40),
          ),
          Container(
            padding: const EdgeInsets.only(bottom: 20),
            child: Text("Additional Documents", style: TextStyle(fontSize: 35)),
          ),
          DropdownButtonFormField(
            decoration: InputDecoration(
                fillColor: Color.fromARGB(217, 217, 217, 217),
                filled: true,
                labelText: 'Document Type',
                labelStyle: TextStyle(fontSize: 21),
                hintText: 'Select a document type'),
            value: dropdownValue2,
            onChanged: (String? newValue) {
              setState(() {
                dropdownValue2 = newValue!;
              });
            },
            items: _documentType.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 20.0),
          ),
          TextFormField(
            controller: docidController,
            decoration: InputDecoration(
                fillColor: Color.fromARGB(217, 217, 217, 217),
                //border: OutlineInputBorder(),
                filled: true,
                labelText: 'Document ID ',
                labelStyle: TextStyle(fontSize: 21),
                hintText: 'ID'),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 20.0),
          ),
          ElevatedButton(
            onPressed: () async {
              var req = await _authAPI.signUp(
                  nameController.text,
                  emailController.text,
                  phoneController.text,
                  passController.text,
                  addController.text,
                  dobController.text,
                  dropdownValue2,
                  docidController.text,
                  dropdownValue1);
              print(req);
              if (context.mounted) {
                if (req.statusCode == 200) {
                  var user = User.fromReqBody(req.body);
                  print("after registration");
                  print(user.token!);
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  prefs.setBool("isLoggedIn", true);
                  prefs.setString('token', user.token!);
                  token = user.token!;
                  if (context.mounted) {
                    Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => MyHomePage()));
                  }
                  
                }
              } else {
                print("context not mounted!!");
              }
            },
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
  bool? _passVisible = false;
  final phoneController = TextEditingController();
  final passController = TextEditingController();
  AuthAPI _authAPI = AuthAPI();

  @override
  void initState() {
    super.initState();
    _passVisible = false;
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
            controller: phoneController,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
                fillColor: Color.fromARGB(217, 217, 217, 217),
                //                    border: OutlineInputBorder(),
                filled: true,
                labelText: 'Phone number',
                hintStyle: TextStyle(fontSize: 16)),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 20.0),
          ),
          TextFormField(
            obscureText: !_passVisible!,
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: TextInputType.visiblePassword,
            controller: passController,
            decoration: InputDecoration(
                fillColor: Color.fromARGB(217, 217, 217, 217),
                //border: OutlineInputBorder(),
                filled: true,
                labelText: 'Password ',
                hintText: 'password',
                suffixIcon: IconButton(
                  icon: Icon(
                    _passVisible! ? Icons.visibility : Icons.visibility_off,
                    color: Theme.of(context).primaryColorDark,
                  ),
                  onPressed: () {
                    setState(() {
                      _passVisible = !_passVisible!;
                    });
                  },
                )),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 20.0),
          ),
          ElevatedButton(
            onPressed: () async {
              var req = await _authAPI.login(
                  phoneController.text, passController.text);
              print(req);
              if (context.mounted) {
                if (req.statusCode == 200) {
                  var user = User.fromReqBody(req.body);
                  print("after login");
                  print(user.token!);
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  prefs.setBool("isLoggedIn", true);
                  prefs.setString('token', user.token!);
                  token = user.token!;
                  if (context.mounted) {
                    Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => MyHomePage()));
                  }
                  
                }
              } else {
                print("context not mounted!!");
              }
            },
            child: Text(
              'Login',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
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
