import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main.dart';
import 'auth.dart';
import 'user.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  static const routeName = '/login';

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool? _passVisible = false;
  bool? _errormessage = false;
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
          Visibility(
            visible: _errormessage!,
            child: Text("An error occurred. Please make sure your credentials are correct.",
                style: TextStyle(fontSize: 15, color: Colors.deepOrange)),
          ),
          Visibility(
            visible: _errormessage!,
            child: Padding(
              padding: EdgeInsets.only(bottom: 20.0),
            ),
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
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs.setBool("isLoggedIn", true);
                  prefs.setString('token', user.token!);
                  token = user.token!;
                  if (context.mounted) {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => MyHomePage(title: "Beacon Responder",)));
                  }
                } else {
                  setState(() {
                    _errormessage = true;
                  });
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
  static const routeName = '/auth';

  @override
  _AuthState createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  String log = "Login";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(log),
          elevation: 16.0,
        ),
        // ternary operator
        body: Container(
            child: Column(
          children: [
            Expanded(
                child: LoginPage()), // ternary operator
            TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyHomePage(title: "Beacon Responder",)),
                  );
                },
                child: Text("Go home"))
          ],
        )));
  }
}
