import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ssshht_reklam/helpers/send.dart';
import 'package:ssshht_reklam/main.dart';
import 'package:ssshht_reklam/model/cafe.dart';

import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class RefTokenPage extends StatefulWidget {
  const RefTokenPage({Key? key}) : super(key: key);

  @override
  State<RefTokenPage> createState() => _RefTokenPageState();
}

class _RefTokenPageState extends State<RefTokenPage> {
  @override
  Widget build(BuildContext context) {
    Cafe mus = ModalRoute.of(context)!.settings.arguments as Cafe;

    return Container(
      child: _sendreftoken(context, mus),
    );
  }
}

_sendreftoken(BuildContext context, Cafe mus) {
  sendRefToken(context, mus);
}

sendRefToken(BuildContext context, Cafe mus) async {
  WebSocketChannel chnnl = IOWebSocketChannel.connect(url);
  mus.istekTip = 'ref_token';
  if (mus.tokens != null && mus.tokens?.tokenDetails != null) {
    mus.tokens!.auth = mus.tokens!.tokenDetails!.refreshToken;
  }

  var json = jsonEncode(mus.toMap());

  sendDataRefToken(context, json, chnnl);
}
