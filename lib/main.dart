import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'login/first_page.dart';

String url = 'ws://reklam.ssshht.com/ws';
String mediaUrl = 'http://reklam.ssshht.com/';

main() {
  runApp(const FirstPage());
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
}
