import 'dart:async';

import 'package:beacon/main.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class BaseAPI {
  BaseAPI() {
    base = "http://$serverAddress";
    api = base + "/api/app";
    signUpPath = api + "/signup";
    loginPath = api + "/login";
    logoutPath = api + "/logout";
    getUserPath = api + "/getUser";
  }

  String base = "";
  String api = "";
  String signUpPath = "";
  String loginPath = "";
  String logoutPath = "";
  String getUserPath = "";
  Map<String, String> headers = {
    "Content-Type": "application/json; charset=UTF-8"
  };
}
