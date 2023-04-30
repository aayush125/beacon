import 'dart:async';
// import 'dart:developer';

// import 'package:beacon/prefs.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'registration.dart';
import 'usercubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'user.dart';
import 'package:google_fonts/google_fonts.dart';
import 'auth.dart';

// void main() {
//   runApp(MyApp());
// }

var token = '';

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

var serverAddress = '10.0.2.2:5173';

class MyApp extends StatelessWidget {
  final bool status;

  const MyApp({
    this.status = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    User test = User(
      name: "name",
      email: "name@email.com",
      phone: "phone",
      token: "token",
      dateOfBirth: "dateOfBirth",
      blood: "B-",
      docID: "docID",
      address: "address",
      docType: "Passport",
    );

    test.printAll();

    return MultiBlocProvider(
      providers: [
        BlocProvider<UserCubit>(
          create: (BuildContext context) => UserCubit(test),
        ),
      ],
      child: MaterialApp(
        title: 'Namer App',
        routes: {
          MapsPage.routeName: (context) => const MapsPage(),
          RegisterPage.routeName: (context) => const RegisterPage(),
        },
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
          textTheme: GoogleFonts.nunitoSansTextTheme(),
        ),
        home: kDebugMode
            ? AddDialog(status: status)
            : (status ? MyHomePage() : Auth()),
      ),
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
    print("status from add dialog");
    print(widget.status);
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
                onPressed: () {
                  serverAddress = dialogFieldController.text;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            (widget.status ? MyHomePage() : Auth())),
                  );
                },
                child: Text("Confirm")),
          ],
        ));
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Position position;
  String _currentAddress = "Waiting for location...";
  AuthAPI authAPI = AuthAPI();

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    startTimer();
  }

  _getCurrentLocation() async {
    position = await _determinePosition();
    String temp = await _getAddressFromLatLng();
    print("getcurrent something");
    print(token);
    var user = await authAPI.getUserw(token);
    print("user here");
    print(user.body);
    setState(() {
      _currentAddress = temp;
    });
  }

  Future<String> _getAddressFromLatLng() async {
    double lat = position.latitude;
    double lng = position.longitude;

    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=AIzaSyBKEI1M_LZSWWEa6AMJCorqfSsVXgD79ns');

    final response = await http.get(url);
    print(response.body);
    print(json.decode(response.body)['results'][0]['formatted_address']);

    return await json.decode(response.body)['results'][0]['formatted_address'];
  }

  bool isTimerActive = false;
  int _totcounter = 15;
  int _remcounter = 15;
  double progressFraction = 0.0;
  Timer? timer;
  void startTimer() {
    _remcounter = 15;
    isTimerActive = true;
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_remcounter > 0) {
          _remcounter--;
          progressFraction = (_totcounter - _remcounter) / _totcounter;
        } else {
          timer.cancel();
        }
      });
    });
  }

  void _resetCounter() {
    setState(() {
      _remcounter = 0;
      progressFraction = 100;
    });
  }

  int get counter => _remcounter;
  @override
  Widget build(BuildContext context) {
    AuthAPI authAPI = AuthAPI();
    //var appState = context.watch<MyAppState>();

    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(12),
              child: Row(
                children: [
                  Icon(
                    Icons.location_on,
                    color: Color(0xFFE33D55),
                  ),
                  Flexible(
                    child: TextButton(
                      onPressed: () async {
                        //_getCurrentLocation();

                        // for debugging purposes
                        print("position incoming...");
                        print(position.latitude);
                        print(position.longitude);

                        if (context.mounted) {
                          Navigator.pushNamed(
                            context,
                            MapsPage.routeName,
                            arguments: position,
                          );
                        }
                      },
                      child: Text(
                        _currentAddress,
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  (_remcounter > 0)
                      ? Text("")
                      : Text("EMERGENCY SENT",
                          style: TextStyle(
                              color: Color(0xFFE33D55),
                              fontStyle: FontStyle.italic)),
                  Padding(padding: EdgeInsets.all(10)),
                  Stack(
                    alignment: Alignment(0, 0),
                    children: [
                      Center(
                        child: SizedBox(
                          width: 200,
                          height: 200,
                          child: CircularProgressIndicator(
                            value: progressFraction,
                          ),
                        ),
                      ),
                      Center(
                        child: Text(
                          '$_remcounter' 's',
                          style: TextStyle(
                              fontSize: 60, fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                                    Padding(padding: EdgeInsets.all(20)),

                  ElevatedButton(
                      onPressed: () {
                        _resetCounter();
                      },
                      child: Text('Skip'))
                  //Text(appState.current.asLowerCase),
                ]),
            Row(
              children: <Widget>[
                ElevatedButton(onPressed: () {}, child: Text("Fire")),
                Icon(Icons.fire_hydrant_alt_outlined),
                ElevatedButton(onPressed: () {}, child: Text("Hospital")),
                Icon(Icons.local_hospital_outlined),
                ElevatedButton(onPressed: () {}, child: Text("Police")),
                Icon(Icons.local_police_outlined),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class MapsPage extends StatefulWidget {
  const MapsPage({super.key});

  static const routeName = '/maps';

  @override
  State<MapsPage> createState() => _MapsPageState();
}

class _MapsPageState extends State<MapsPage> {
  late GoogleMapController mapController;

  //final LatLng _center = const LatLng(27.688415, 85.335490);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Position;

    return MaterialApp(
        theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: Colors.green[700],
        ),
        home: Scaffold(
            body: SafeArea(
          child: GoogleMap(
            onMapCreated: _onMapCreated,
            markers: {
              Marker(
                markerId: MarkerId('marker_1'),
                position:
                    LatLng(args.latitude.toDouble(), args.longitude.toDouble()),
                draggable: true,
                onDragEnd: (value) {},
                infoWindow: InfoWindow(
                  title: 'Marker 1',
                  snippet: 'This is a snippet',
                ),
              ),
            },
            myLocationEnabled: true,
            initialCameraPosition: CameraPosition(
              target:
                  LatLng(args.latitude.toDouble(), args.longitude.toDouble()),
              zoom: 16.0,
            ),
          ),
        )));
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
