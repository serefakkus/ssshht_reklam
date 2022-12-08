import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ssshht_reklam/helpers/send.dart';
import 'package:ssshht_reklam/model/cafe.dart';

import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../main.dart';

TextEditingController _passcontroller = TextEditingController();
TextEditingController _newpasscontroller = TextEditingController();
Size _size = const Size(0, 0);
double _height = 0;
double _width = 0;

class NewPassLoginPage extends StatefulWidget {
  const NewPassLoginPage({Key? key}) : super(key: key);

  @override
  State<NewPassLoginPage> createState() => _NewPassLoginPageState();
}

class _NewPassLoginPageState extends State<NewPassLoginPage> {
  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.of(context).size;
    _height = _size.height;
    _width = _size.width;

    List<String> code =
        ModalRoute.of(context)!.settings.arguments as List<String>;

    return Container(
      color: backGroundColor,
      child: ListView(
        children: [
          const Center(child: Pass()),
          const PassInput(),
          const Center(child: NewPass()),
          const NewPassInput(),
          SendPassButton(code),
        ],
      ),
    );
  }
}

sendNewPass(BuildContext context, List<String> code) {
  WebSocketChannel channel = IOWebSocketChannel.connect(url);
  if (_passcontroller.text == _newpasscontroller.text ||
      _passcontroller.text.isNotEmpty) {
    Cafe mus = Cafe();
    var sign = Phone();
    sign.no = code[0];
    sign.code = code[1];
    mus.phone = sign;

    mus.istekTip = 'ref_pass';
    mus.pass = _passcontroller.text;

    var json = jsonEncode(mus.toMap());

    sendDataNewPassSignup(context, json, channel);
  } else {
    EasyLoading.showToast('GİRDİĞİNİZ ŞİFRELER\n UYUŞMUYOR');
  }
}

class Pass extends StatelessWidget {
  const Pass({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: (_height / 7)),
      child: Text(
        'YENİ ŞİFRE',
        style: GoogleFonts.farro(
            fontSize: _width / 18,
            fontWeight: FontWeight.bold,
            color: Colors.white),
      ),
    );
  }
}

class PassInput extends StatefulWidget {
  const PassInput({Key? key}) : super(key: key);

  @override
  State<PassInput> createState() => _PassInputState();
}

class _PassInputState extends State<PassInput> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          top: (_height / 30), left: (_width / 15), right: (_width / 15)),
      child: Padding(
        padding: const EdgeInsets.only(),
        child: TextField(
          decoration: InputDecoration(
            suffixIcon: IconButton(
              icon: Icon(
                Icons.remove_red_eye,
                color: _iconColor(_isPressPass),
              ),
              onPressed: () {
                _isPressPass = !_isPressPass;
                setState(() {});
              },
            ),
            border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(30))),
            filled: true,
            fillColor: const Color(0XFFA6D7E7),
          ),
          controller: _passcontroller,
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.visiblePassword,
          obscureText: !_isPressPass,
          obscuringCharacter: '*',
        ),
      ),
    );
  }
}

bool _isPressPass = false;
bool _isPressPass2 = false;

Color _iconColor(bool isPressed) {
  if (isPressed) {
    return Colors.green;
  }
  return Colors.blue;
}

class NewPass extends StatelessWidget {
  const NewPass({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: (_height / 20)),
      child: Text(
        'TEKRAR YENİ ŞİFRE',
        style: GoogleFonts.farro(
            fontSize: _width / 18,
            fontWeight: FontWeight.bold,
            color: Colors.white),
      ),
    );
  }
}

class NewPassInput extends StatefulWidget {
  const NewPassInput({Key? key}) : super(key: key);

  @override
  State<NewPassInput> createState() => _NewPassInputState();
}

class _NewPassInputState extends State<NewPassInput> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          top: (_height / 25), right: (_width / 15), left: (_width / 15)),
      child: Padding(
        padding: const EdgeInsets.only(),
        child: TextField(
          decoration: InputDecoration(
            suffixIcon: IconButton(
              icon: Icon(
                Icons.remove_red_eye,
                color: _iconColor(_isPressPass2),
              ),
              onPressed: () {
                _isPressPass2 = !_isPressPass2;
                setState(() {});
              },
            ),
            border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(30))),
            filled: true,
            fillColor: const Color(0XFFA6D7E7),
          ),
          controller: _newpasscontroller,
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.visiblePassword,
          obscureText: !_isPressPass,
          obscuringCharacter: '*',
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class SendPassButton extends StatelessWidget {
  SendPassButton(this.code, {Key? key}) : super(key: key);
  List<String> code = [];
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          top: (_height / 5), right: (_width / 10), left: (_width / 10)),
      alignment: Alignment.center,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            elevation: 10,
            fixedSize: Size((_width / 1.2), (_height / 12.5)),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50))),
        child: const Text(
          'ŞİFRE OLUŞTUR',
          style: TextStyle(fontSize: 20),
          textAlign: TextAlign.center,
        ),
        onPressed: () {
          sendNewPass(context, code);
        },
      ),
    );
  }
}
