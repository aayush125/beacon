import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

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

class MyHomePage extends StatelessWidget {
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
                  TextButton(
                    onPressed: () async {
                      final Position position = await _determinePosition();

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
                      'Location fetched from somewhere',
                      style: TextStyle(fontSize: 15),
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
            target: LatLng(args.latitude.toDouble(), args.longitude.toDouble()),
            zoom: 16.0,
          ),
        ),
      )),
    );
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
