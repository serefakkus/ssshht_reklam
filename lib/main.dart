import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'login/first_page.dart';

String url = 'wss://reklam.ssshht.com/ws';
String mediaUrl = 'https://reklam.ssshht.com/';
Color backGroundColor = const Color(0XFF19B5E3);

main() {
  runApp(const FirstPage());
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
}
