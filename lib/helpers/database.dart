import 'dart:convert';
import 'package:flutter/cupertino.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:ssshht_reklam/helpers/send.dart';
import 'package:ssshht_reklam/main.dart';
import 'package:ssshht_reklam/model/cafe.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

void tokensIntert(TokenDetails tokenDetails) async {
  if (tokenDetails.accessToken != null && tokenDetails.refreshToken != null) {
    final preferences = await SharedPreferences.getInstance();
    preferences.setString('accesstoken', tokenDetails.accessToken!);
    preferences.setString('refreshtoken', tokenDetails.refreshToken!);
    preferences.setInt('atexp', tokenDetails.atExpires!);
    preferences.setInt('rtexp', tokenDetails.rtExpires!);
  }
}

void tokensDel() async {
  final preferences = await SharedPreferences.getInstance();

  preferences.remove('accesstoken');
  preferences.remove('refreshtoken');
  preferences.remove('atexp');
  preferences.remove('rtexp');
  preferences.remove('type');
}

Future<List<String>?> videoIdSGet() async {
  final preferences = await SharedPreferences.getInstance();
  var idS = preferences.getStringList('video_ids');
  return idS;
}

Future videoIdSInsert(List<String>? idS) async {
  if (idS != null) {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setStringList('video_ids', idS);
  }
}

Future videoIdSDel() async {
  final preferences = await SharedPreferences.getInstance();
  await preferences.remove('video_ids');
}

Future<TokenDetails> tokenGet() async {
  final preferences = await SharedPreferences.getInstance();
  TokenDetails token = TokenDetails();
  token.accessToken = preferences.getString('accesstoken');
  token.refreshToken = preferences.getString('refreshtoken');
  token.atExpires = preferences.getInt('atexp');
  token.rtExpires = preferences.getInt('rtexp');
  return token;
}

void phoneAndPassIntert(Cafe sign) async {
  final preferences = await SharedPreferences.getInstance();

  preferences.setString('phone', sign.name!);
  preferences.setString('pass', sign.pass!);
}

void passIntert(Cafe sign) async {
  final preferences = await SharedPreferences.getInstance();

  preferences.setString('pass', sign.pass!);
}

void phoneIntert(Cafe sign) async {
  final preferences = await SharedPreferences.getInstance();

  preferences.setString('phone', sign.name!);
}

Future<Cafe> passGet() async {
  final preferences = await SharedPreferences.getInstance();
  Cafe sign = Cafe();

  sign.name = preferences.getString('phone');
  sign.pass = preferences.getString('pass');

  return sign;
}

Future<TokenDetails> getToken(BuildContext context) async {
  TokenDetails token = await tokenGet();

  WebSocketChannel chnnl = IOWebSocketChannel.connect(url);
  WebSocketChannel chnnl2 = IOWebSocketChannel.connect(url);
  var date = DateTime.fromMillisecondsSinceEpoch(token.rtExpires! * 1000);
  if (date.isBefore(DateTime.now())) {
    Cafe mus = Cafe();
    Tokens tok = Tokens();
    tok.tokenDetails = token;
    mus.tokens = tok;
    mus.istekTip = 'ref_token';
    var json = jsonEncode(mus.toMap());
    // ignore: unused_local_variable
    var m = await sendDataToken(json, chnnl);
    mus.istekTip = 'is_ok';

    var json2 = jsonEncode(mus.toMap());
    // ignore: use_build_context_synchronously
    sendDataIsToken(json2, chnnl2, context);
  }

  return token;
}

Future<Cafe> phoneGet() async {
  final preferences = await SharedPreferences.getInstance();
  Cafe sign = Cafe();
  sign.name = preferences.getString('phone');
  return sign;
}
