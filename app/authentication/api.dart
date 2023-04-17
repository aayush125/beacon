import 'dart:async';

import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class BaseAPI{
    static String base = "http://localhost:3000"; 
    static var api = base + "/api/v1";
    var usersPath = api + "/users";
    var authPath = api + "/auth"; 
    var logoutPath = api + "/logout";
   // more routes
   Map<String,String> headers = {                           
       "Content-Type": "application/json; charset=UTF-8" };                                      
              
}
