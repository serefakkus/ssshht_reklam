import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:ssshht_reklam/helpers/database.dart';
import 'package:ssshht_reklam/helpers/send.dart';
import 'package:ssshht_reklam/main.dart';
import 'package:ssshht_reklam/model/cafe.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

Size _size = const Size(0, 0);
double _height = 0;
double _width = 0;
TextEditingController _phonecontroller = TextEditingController();
TextEditingController _codecontroller = TextEditingController();

class NewMusteriPage extends StatefulWidget {
  const NewMusteriPage({Key? key}) : super(key: key);

  @override
  State<NewMusteriPage> createState() => _NewMusteriPageState();
}

class _NewMusteriPageState extends State<NewMusteriPage> {
  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.of(context).size;
    _height = _size.height;
    _width = _size.width;
    return Column(
      children: [
        Flexible(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                width: (_width / 1.6),
                child: Column(
                  children: const [TelefonNumarasi(), PhoneInput()],
                ),
              ),
              const CodeButon()
            ],
          ),
        ),
        const Code(),
        const CodeInput(),
        const GirisButon()
      ],
    );
  }
}

class TelefonNumarasi extends StatelessWidget {
  const TelefonNumarasi({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: (_height / 6)),
      //margin: const EdgeInsets.only(top: 180),
      child: const Text(
        'TELEFON\n NUMARASI',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 20),
      ),
    );
  }
}

class PhoneInput extends StatelessWidget {
  const PhoneInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
          border: const OutlineInputBorder(),
          filled: true,
          fillColor: Colors.blue.shade50),
      controller: _phonecontroller,
      cursorColor: Colors.blue,
      keyboardType:
          const TextInputType.numberWithOptions(signed: true, decimal: true),
      textInputAction: TextInputAction.go,
    );
  }
}

class GirisButon extends StatelessWidget {
  const GirisButon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: (_height / 20)),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            elevation: 10,
            fixedSize: Size((_width * 0.7), (_height / 15)),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50))),
        child: const Text('ONAY'),
        onPressed: () {
          _sendSignUp(context);
        },
      ),
    );
  }
}

class Code extends StatelessWidget {
  const Code({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 5),
      child: const Text(
        'KOD',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 20),
      ),
    );
  }
}

class CodeInput extends StatelessWidget {
  const CodeInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          top: (_height / 90),
          left: (_width / 10),
          right: (_width / 10),
          bottom: (_height / 4)),
      child: TextField(
        decoration: InputDecoration(
            border: const OutlineInputBorder(),
            filled: true,
            fillColor: Colors.blue.shade50),
        controller: _codecontroller,
        cursorColor: Colors.blue,
        keyboardType:
            const TextInputType.numberWithOptions(signed: true, decimal: true),
        textInputAction: TextInputAction.go,
      ),
    );
  }
}

class CodeButon extends StatelessWidget {
  const CodeButon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          elevation: 10,
          fixedSize: Size((_width * 0.3), (_height / 15)),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
      child: const Text(
        'KOD\n GÖNDER',
        textAlign: TextAlign.center,
      ),
      onPressed: () {
        _sendCode(context);
      },
    );
  }
}

_sendCode(BuildContext context) async {
  WebSocketChannel _channel = IOWebSocketChannel.connect(url);

  if (_phonecontroller.text.isNotEmpty && _phonecontroller.text.length == 10) {
    var _tok = await getToken(context);
    //data.sign?.phone = _phonecontroller.text;
    //data.sign?.pass = _passcontroller.text;
    Tokens _token = Tokens();
    _token.tokenDetails = _tok;
    var _pho = Phone();
    _pho.no = _phonecontroller.text;
    Cafe _cafe = Cafe();
    _cafe.phone = _pho;
    _cafe.tokens = _token;
    _cafe.istekTip = 'new_user';

    var json = jsonEncode(_cafe.toMap());
    sendDataCode(json, _channel, context);
  } else {
    EasyLoading.showToast('numara 10 hane olmali');
  }
}

_sendSignUp(BuildContext context) async {
  WebSocketChannel _channel = IOWebSocketChannel.connect(url);

  if (_phonecontroller.text.isNotEmpty && _phonecontroller.text.length == 10) {
    if (_codecontroller.text.length == 5) {
      var _tok = await getToken(context);
      //data.sign?.phone = _phonecontroller.text;
      //data.sign?.pass = _passcontroller.text;
      var _pho = Phone();
      Tokens _token = Tokens();
      _token.tokenDetails = _tok;
      _pho.no = _phonecontroller.text;
      _pho.code = _codecontroller.text;
      Cafe _cafe = Cafe();
      _cafe.phone = _pho;
      _cafe.tokens = _token;

      _cafe.istekTip = 'ref_user';

      var json = jsonEncode(_cafe.toMap());
      sendDataNewMusteri(json, _channel, context);
    } else {
      EasyLoading.showToast('kod 5 hane olmali');
    }
  } else {
    EasyLoading.showToast('numara 10 hane olmali');
  }
}
