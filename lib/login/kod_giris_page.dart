import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
List<String> codeandphone = ['', ''];

class KodGirisPage extends StatelessWidget {
  const KodGirisPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.of(context).size;
    _height = _size.height;
    _width = _size.width;
    //String as = ModalRoute.of(context)!.settings.arguments as String;
    return const Scaffold(
      body: KodGiris(),
    );
  }
}

class KodGiris extends StatefulWidget {
  const KodGiris({Key? key}) : super(key: key);

  @override
  State<KodGiris> createState() => _KodGirisState();
}

class _KodGirisState extends State<KodGiris> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0XFF0017FF),
      child: ListView(
        children: [
          Column(
            children: [
              const TelefonNumarasi(),
              Row(
                children: const [
                  Flexible(child: PhoneInput()),
                  CodeSendButton()
                ],
              ),
              const Code(),
              const CodeInput(),
              const SignUpButton(),
            ],
          ),
        ],
      ),
    );
  }
}

sendCodeGiris(BuildContext context) async {
  WebSocketChannel channel = IOWebSocketChannel.connect(url);
  if (_phonecontroller.text.isNotEmpty) {
    Phone pho = Phone();
    Cafe mus = Cafe();
    pho.no = _phonecontroller.text;
    mus.phone = pho;
    mus.istekTip = 'new_pass';
    var json = jsonEncode(mus.toMap());

    sendDataCode(json, channel, context);
  }
}

sendCodePass(BuildContext context) async {
  WebSocketChannel channel = IOWebSocketChannel.connect(url);
  if (_phonecontroller.text.isNotEmpty || _codecontroller.text.isNotEmpty) {
    Phone pho = Phone();
    Cafe mus = Cafe();
    pho.no = _phonecontroller.text;
    pho.code = _codecontroller.text;
    mus.phone = pho;
    mus.istekTip = 'ref_code';
    codeandphone[0] = pho.no!;
    codeandphone[1] = pho.code!;

    var json = jsonEncode(mus.toMap());
    sendDataRefCode(context, json, channel, codeandphone);
  }
}

class TelefonNumarasi extends StatelessWidget {
  const TelefonNumarasi({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: (_height / 7),
      ),
      child: Text(
        'TELEFON NUMARASI',
        style: GoogleFonts.farro(
            fontSize: _width / 18,
            fontWeight: FontWeight.bold,
            color: Colors.white),
      ),
    );
  }
}

class PhoneInput extends StatelessWidget {
  const PhoneInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          top: (_height / 30), left: (_width / 15), right: (_width / 15)),
      child: Padding(
        padding: const EdgeInsets.only(),
        child: TextField(
          decoration: const InputDecoration(
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(30))),
            filled: true,
            fillColor: Color(0XFFA6D7E7),
          ),
          controller: _phonecontroller,
          cursorColor: Colors.blue,
          keyboardType: const TextInputType.numberWithOptions(
              signed: true, decimal: true),
          textInputAction: TextInputAction.go,
        ),
      ),
    );
  }
}

class Code extends StatelessWidget {
  const Code({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: (_height / 20)),
      child: Text(
        'KOD',
        style: GoogleFonts.farro(
            fontSize: _width / 18,
            fontWeight: FontWeight.bold,
            color: Colors.white),
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
          top: (_height / 30), right: (_width / 15), left: (_width / 15)),
      child: Padding(
        padding: const EdgeInsets.only(),
        child: TextField(
          decoration: const InputDecoration(
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(30))),
            filled: true,
            fillColor: Color(0XFFA6D7E7),
          ),
          controller: _codecontroller,
          cursorColor: Colors.blue,
          keyboardType: const TextInputType.numberWithOptions(
              signed: true, decimal: true),
          textInputAction: TextInputAction.go,
        ),
      ),
    );
  }
}

class CodeSendButton extends StatefulWidget {
  const CodeSendButton({Key? key}) : super(key: key);

  @override
  State<CodeSendButton> createState() => _CodeSendButtonState();
}

class _CodeSendButtonState extends State<CodeSendButton> {
  WebSocketChannel channel = IOWebSocketChannel.connect(url);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: (_height / 30), right: (_width / 25)),
      alignment: Alignment.center,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
          elevation: 10,
          fixedSize: Size((_width / 4), (_height / 15)),
        ),
        child: const Text(
          'KOD\n GÖNDER',
          textAlign: TextAlign.center,
        ),
        onPressed: () {
          setState(() {
            sendCodeGiris(context);
          });
        },
      ),
    );
  }
}

class SignUpButton extends StatefulWidget {
  const SignUpButton({Key? key}) : super(key: key);

  @override
  State<SignUpButton> createState() => _SignUpButtonState();
}

class _SignUpButtonState extends State<SignUpButton> {
  WebSocketChannel channel = IOWebSocketChannel.connect(url);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: (_height / 4), left: (_width / 25)),
      alignment: Alignment.center,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            elevation: 10,
            fixedSize: Size((_width / 1.2), (_height / 12.5)),
            textStyle: const TextStyle(fontSize: 20),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50))),
        child: const Text(
          'ONAYLA',
          textAlign: TextAlign.center,
        ),
        onPressed: () {
          setState(() {
            sendCodePass(context);
          });
        },
      ),
    );
  }
}
