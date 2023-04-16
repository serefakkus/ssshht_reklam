import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'login/first_page.dart';

String url = 'wss://reklam.ssshht.com/ws';
String mediaUrl = 'https://reklam.ssshht.com/';
String imageUrl = 'https://reklamimage.ssshht.com/';
Color backGroundColor = const Color(0XFF5ED2F5);

main() {
  runApp(const FirstPage());
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
}
