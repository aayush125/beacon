import 'dart:async';
import 'dart:convert';

import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:http/http.dart' as http;

var serverAddress = 'ws://10.0.2.2:5173/api/ws';
// var serverAddress = 'ws://192.168.1.71:5173/api/ws';

var wsMarker = Marker(
  markerId: MarkerId('ws_marker'),
  visible: false
);

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Namer App',
        routes: {
          MapsPage.routeName: (context) => const MapsPage(),
        },
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Position position;
  String _currentAddress = "Loading location...";
  final dialogFieldController = TextEditingController();

  void openServerDialog() {
    dialogFieldController.text = serverAddress;
    showDialog(
      context: context, 
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
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
                onPressed: () => serverAddress = dialogFieldController.text,
                child: Text("Confirm")
              )
            ],
          )
        );
      }
    );
  }

  @override
  void dispose() {
    dialogFieldController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  _getCurrentLocation() async {
    position = await _determinePosition();
    var temp = await _getAddressFromLatLng();
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


  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    return Scaffold(
      /*body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('A very random idea:'),
            Text(appState.current.asLowerCase),
      
            ElevatedButton( 
              onPressed: toggleSound,
              child: Text('Music'), 
            ),
          ],
        ),
      ),*/
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
                        // _getCurrentLocation();

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
              children: [
                Text('A very random idea:'),
                Text(appState.current.asLowerCase),
                ElevatedButton(
                  onPressed: toggleSound,
                  child: Text('Music'),
                ),
                ElevatedButton(
                  onPressed: () => openServerDialog(),
                  child: Text('Change Server Address')
                ),
              ],
            ),
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
  late WebSocketChannel channel;
  late Position pos;


  //final LatLng _center = const LatLng(27.688415, 85.335490);

  void _onMapCreated(GoogleMapController controller) async {
    mapController = controller;

    try {
      channel = WebSocketChannel.connect(Uri.parse(serverAddress));
      await channel.ready;
    } catch (e) {
      print("ERROR!");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Websocket connection error!')));
    }
    
    channel.stream.listen((msg) {
      print("RESPONSE:");
      print(msg);

      final serverPos = jsonDecode(msg);

      setState(() {
        wsMarker = Marker(
          markerId: MarkerId('ws_marker'),
          draggable: false,
          infoWindow: InfoWindow(
            title: 'Websocket',
            snippet: 'Moving marker to illustrate power of websockets!'
          ),
          visible: true,
          position: LatLng(serverPos['lat'], serverPos['lon']),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue)
        );
      });
    }, onError: (e) {
      print("ERROR!");
    });

    final msg = jsonEncode({
      'lat': pos.latitude,
      'lon': pos.longitude
    });
    print(msg);
    channel.sink.add(msg);
  }

  @override
  Widget build(BuildContext context) {
    pos = ModalRoute.of(context)!.settings.arguments as Position;

    return Scaffold(
            body: SafeArea(
          child: GoogleMap(
            onMapCreated: _onMapCreated,
            markers: {
              Marker(
                markerId: MarkerId('marker_1'),
                position:
                    LatLng(pos.latitude.toDouble(), pos.longitude.toDouble()),
                draggable: false,
                onDragEnd: (value) {},
                infoWindow: InfoWindow(
                  title: 'Marker 1',
                  snippet: 'This is a snippet',
                ),
              ),
              wsMarker
          },
            myLocationEnabled: true,
            initialCameraPosition: CameraPosition(
              target:
                  LatLng(pos.latitude.toDouble(), pos.longitude.toDouble()),
              zoom: 16.0,
            ),
          ),
        ));
  }

  @override
  void dispose() {
    channel.sink.close();
    mapController.dispose();
    super.dispose();
  }
}

final player = AudioPlayer();

// Function to play sound
void toggleSound() async {
  if (player.state == PlayerState.playing) {
    print('music paused!');
    await player.pause();
  } else if (player.state == PlayerState.paused) {
    print('music playing!');
    await player.resume();
  } else {
    print('music starting!');
    await player.setSourceAsset("sounds/geet.mp3");
    await player.resume();
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
