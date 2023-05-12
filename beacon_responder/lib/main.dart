import 'dart:isolate';

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
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

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
late LatLng position;
bool gotPosition = false;
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
var posForSink;

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  // handle action
  print("this run");
}

void _initForegroundTask() {
  FlutterForegroundTask.init(
    androidNotificationOptions: AndroidNotificationOptions(
      channelId: 'notification_channel_id',
      channelName: 'Foreground Notification',
      channelDescription:
          'This notification appears when the foreground service is running.',
      channelImportance: NotificationChannelImportance.MIN,
      priority: NotificationPriority.LOW,
      isSticky: false,
      iconData: null,
    ),
    iosNotificationOptions: const IOSNotificationOptions(
      showNotification: true,
      playSound: false,
    ),
    foregroundTaskOptions: const ForegroundTaskOptions(
      interval: 10000,
      isOnceEvent: false,
      autoRunOnBoot: false,
      allowWakeLock: true,
      allowWifiLock: true,
    ),
  );
}

// The callback function should always be a top-level function.
@pragma('vm:entry-point')
void startCallback() {
  // The setTaskHandler function must be called to handle the task in the background.
  FlutterForegroundTask.setTaskHandler(BackgroundTaskHandler());
}

class BackgroundTaskHandler extends TaskHandler {
  late WebSocketChannel _channel;

  @override
  Future<void> onStart(DateTime timestamp, SendPort? sendPort) async {
    // You can use the getData function to get the stored data.

    final url =
        await FlutterForegroundTask.getData<String>(key: 'websocket_endpoint');

    print('WebSocket URL: $url');

    _channel = WebSocketChannel.connect(Uri.parse(url!));

    _channel.stream.listen((msg) async {
      // sendPort?.send();
      // await FlutterForegroundTask.saveData(key: 'emergency', value: msg.toString());

      final data = jsonDecode(msg);

      await flutterLocalNotificationsPlugin.show(
          0,
          'Assigned to Emergency',
          '${data['user']['name']} needs rescuing!',
          const NotificationDetails(
              android: AndroidNotificationDetails(
                  'job_notification', 'Job Notification')),
          payload: msg.toString());
    });
  }

  @override
  Future<void> onEvent(DateTime timestamp, SendPort? sendPort) async {
    final posx = await _determinePosition();

    print("event this is");

    final msg = jsonEncode(
        {'type': "pos_update", 'lat': posx.latitude, 'lng': posx.longitude});

    _channel.sink.add(msg);
  }

  @override
  Future<void> onDestroy(DateTime timestamp, SendPort? sendPort) async {
    // You can use the clearAllData function to clear all the stored data.
    await FlutterForegroundTask.clearAllData();
    await _channel.sink.close();
  }
}

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
                  final p = await _determinePosition();
                  position = LatLng(p.latitude, p.longitude);
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
  dynamic _currentEmergency;

  static const _initMarker =
      Marker(markerId: MarkerId('emergency'), visible: false);
  final _initCamPos = CameraPosition(
    target: position,
    zoom: 16.0,
  );

  Marker _marker = _initMarker;

  //final LatLng _center = const LatLng(27.688415, 85.335490);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Future<bool> _startForegroundTask() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse:
            (NotificationResponse notificationResponse) async {
      final str = notificationResponse.payload;

      final data = jsonDecode(str!);

      setState(() {
        _currentEmergency = data;
        final pos = LatLng(data["lat"], data["lng"]);

        _marker = Marker(markerId: const MarkerId('emergency'), position: pos);

        mapController.animateCamera(CameraUpdate.newLatLng(pos));
      });
    });

    if (!await FlutterForegroundTask.isIgnoringBatteryOptimizations) {
      await FlutterForegroundTask.requestIgnoreBatteryOptimization();
    }

    print("gets here for sureeeeeee");

    // You can save data using the saveData function.
    await FlutterForegroundTask.saveData(
        key: 'websocket_endpoint',
        value: 'ws://$serverAddress/api/responder/ws?token=$token');

    if (await FlutterForegroundTask.isRunningService) {
      return FlutterForegroundTask.restartService();
    } else {
      print('starting');
      return FlutterForegroundTask.startService(
        notificationTitle: 'Foreground Service is running',
        notificationText: 'Responder Status: Active',
        callback: startCallback,
      );
    }
  }

  Future<bool> _stopForegroundTask() {
    return FlutterForegroundTask.stopService();
  }

  void _startTask() async {
    await _startForegroundTask();

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestPermission();
  }

  @override
  void initState() {
    super.initState();

    _initForegroundTask();
    _startTask();
  }

  @override
  Widget build(BuildContext context) {
    return WithForegroundTask(
        child: Scaffold(
      appBar: AppBar(
        title: Text("Emergency"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (_currentEmergency != null)
            Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Column(children: [
                  Text(
                      'Name: ${_currentEmergency["user"]["name"]}\nPhone: ${_currentEmergency["user"]["phone"]}'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () async {
                          UrlLauncher.launchUrl(Uri.parse(
                              "tel://${_currentEmergency["user"]["phone"]}"));
                        },
                        child: const Text("Call User"),
                      ),
                      TextButton(
                        onPressed: () async {
                          final url = Uri.parse(
                              'http://$serverAddress/api/responder/resolve_emergency?token=$token&emergency_id=${_currentEmergency["id"]}');

                          setState(() {
                            _currentEmergency = null;
                            _marker = _initMarker;
                          });

                          await http.get(url);
                        },
                        child: const Text("Resolve Emergency"),
                      ),
                    ],
                  )
                ])),
          Expanded(
            child: SizedBox(
              height: 200.0,
              child: GoogleMap(
                onMapCreated: _onMapCreated,
                markers: {_marker},
                myLocationEnabled: true,
                initialCameraPosition: _initCamPos,
              ),
            ),
          ),
        ],
      ),
    ));
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
