import 'package:flutter/material.dart';
import 'auth.dart';
import 'user.dart';
import 'authentication.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var status = prefs.getBool('isLoggedIn') ?? false;
  token = prefs.getString('token') ?? '';
  print("status incoming bro");
  print(status);
  print(token);
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp(
    status: status,
  ));
}

var serverAddress = '';
var token = '';
User theUser = User();
late Position position;
bool gotPosition = false;

class MyApp extends StatelessWidget {
  final bool status;

  const MyApp({
    this.status = false,
    Key? key,
  }) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: kDebugMode
          ? AddDialog(status: status)
          : (status
              ? MyHomePage(
                  title: "Beacon Responder",
                )
              : Auth()),
    );
  }
}

class AddDialog extends StatefulWidget {
  final bool status;
  const AddDialog({required this.status, Key? key}) : super(key: key);

  @override
  State<AddDialog> createState() => _AddDialogState();
}

class _AddDialogState extends State<AddDialog> {
  final dialogFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    dialogFieldController.text = serverAddress;
    return AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        title: Text("[DEBUG] Change Server"),
        content: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextField(
              controller: dialogFieldController,
            ),
            ElevatedButton(
                onPressed: () {
                  dialogFieldController.text = '10.0.2.2:5173';
                },
                child: Text("Server on emulator PC")),
            ElevatedButton(
                onPressed: () {
                  dialogFieldController.text =
                      'testsite.southeastasia.cloudapp.azure.com:4173';
                },
                child: Text("Online Server")),
            Padding(padding: EdgeInsets.only(bottom: 30)),
            ElevatedButton(
                onPressed: () async {
                  serverAddress = dialogFieldController.text;
                  position = await _determinePosition();
                  gotPosition = true;
                  if (token != '') {
                    AuthAPI authAPI = AuthAPI();
                    print('token here');
                    print(token);
                    var user = await authAPI.getRes(token);
                    print("user here");
                    print(user.body);
                    theUser = User.fromReqBody(user.body);
                    print(theUser);
                  }
                  if (context.mounted) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => (widget.status
                              ? MyHomePage(
                                  title: "Beacon Responder",
                                )
                              : Auth())),
                    );
                  }
                },
                child: Text("Confirm")),
          ],
        ));
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late GoogleMapController mapController;

  //final LatLng _center = const LatLng(27.688415, 85.335490);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Emergency"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
              child: SizedBox(
            height: 200.0,
            child: GoogleMap(
              onMapCreated: _onMapCreated,
              markers: {
                Marker(
                  markerId: MarkerId('marker_1'),
                  position: LatLng(position.latitude.toDouble(),
                      position.longitude.toDouble()),
                  draggable: true,
                  onDragEnd: (value) {},
                  infoWindow: InfoWindow(
                    title: 'Marker 1',
                    snippet: 'This is a snippet',
                    onTap: () {
                      UrlLauncher.launchUrl(Uri.parse("tel://911"));
                    },
                  ),
                ),
              },
              myLocationEnabled: true,
              initialCameraPosition: CameraPosition(
                target: LatLng(position.latitude.toDouble(),
                    position.longitude.toDouble()),
                zoom: 16.0,
              ),
            ),
          ))
        ],
      ),
    );
  }
}

Future<Position> _determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }

  print("Position fetched!!!");
  return await Geolocator.getCurrentPosition();
}
