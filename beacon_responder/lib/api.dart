import 'dart:async';

import 'package:beacon_responder/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class BaseAPI {
  BaseAPI() {
    base = "http://$serverAddress";
    api = base + "/api/responder";
    signUpPath = api + "/signup";
    loginPath = api + "/login";
    logoutPath = api + "/logout";
    getResPath = api + "/getResponder";
    emergencyPingPath = api + "/emergencyPing";
  }

  String base = "";
  String api = "";
  String signUpPath = "";
  String loginPath = "";
  String logoutPath = "";
  String getResPath = "";
  String emergencyPingPath = "";
  Map<String, String> headers = {
    "Content-Type": "application/json; charset=UTF-8"
  };
}
