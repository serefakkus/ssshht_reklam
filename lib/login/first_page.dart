// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:ssshht_reklam/helpers/database.dart';
import 'package:ssshht_reklam/helpers/send.dart';
import 'package:ssshht_reklam/main.dart';
import 'package:ssshht_reklam/model/cafe.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../route_generator.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({Key? key}) : super(key: key);

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      supportedLocales: const [
        Locale('tr', 'TR'),
      ],
      builder: EasyLoading.init(),
      onGenerateRoute: RouteGenerator.routeGenerator,
      home: const islogin(),
    );
  }
}

// ignore: camel_case_types
class islogin extends StatefulWidget {
  const islogin({Key? key}) : super(key: key);

  @override
  State<islogin> createState() => _isloginState();
}

// ignore: camel_case_types
class _isloginState extends State<islogin> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: isUserLogin(context),
    );
  }
}

_gettoken(BuildContext context) async {
  Cafe mus = Cafe();
  var token = await tokenGet();
  if (token.accessToken == null || token.accessToken == '') {
    Navigator.pushNamed(context, '/WelcomePage');
  } else {
    Tokens tokens = Tokens();
    tokens.tokenDetails = token;
    mus.tokens = tokens;
    Tokens sign = Tokens();
    mus.tokens = sign;
    var date = DateTime.fromMillisecondsSinceEpoch(token.atExpires! * 1000);
    var date2 = DateTime.fromMillisecondsSinceEpoch(token.rtExpires! * 1000);
    if (date.isAfter(DateTime.now())) {
      _sendIsTokenOk(context, token);
    } else if (date2.isAfter(DateTime.now())) {
      Navigator.pushNamed(context, '/RefTokenPage', arguments: mus);
    } else {
      Navigator.pushNamed(context, '/WelcomePage');
    }
  }
}

isUserLogin(BuildContext cnt) {
  _gettoken(cnt);
}

_sendIsTokenOk(BuildContext context, TokenDetails token) {
  var tok = Tokens();
  Cafe cafe = Cafe();

  tok.tokenDetails = token;
  cafe.tokens = tok;

  cafe.istekTip = 'is_ok';

  WebSocketChannel channel = IOWebSocketChannel.connect(url);
  var json = jsonEncode(cafe.toMap());

  sendDataIsOk(json, channel, context);
}
