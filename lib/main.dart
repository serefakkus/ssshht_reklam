import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'login/first_page.dart';

String url = 'wss://reklam.ssshht.store/ws';
String mediaUrl = 'https://reklam.ssshht.store/';
String imageUrl = 'https://reklamimage.ssshht.store/';
Color backGroundColor = const Color(0XFF5ED2F5);

bool isTest = false;

main() {
  runApp(const FirstPage());
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
}
