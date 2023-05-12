import 'dart:async';

import 'package:beacon/prefs.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:audioplayers/audioplayers.dart';
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
import 'main.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class Emergency extends StatefulWidget {
  const Emergency({Key? key}) : super(key: key);

  @override
  EmergencyState createState() => EmergencyState();
}

class EmergencyState extends State<Emergency> {
  final nameController = TextEditingController();
  final allergyController = TextEditingController();
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
          Text("Emergency status: Verifying..."),
          Padding(padding: EdgeInsets.all(10.0)),
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
          )),
        ],
      ),
    );
  }
}
