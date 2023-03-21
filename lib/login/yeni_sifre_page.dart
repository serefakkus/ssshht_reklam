import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ssshht_reklam/helpers/send.dart';
import 'package:ssshht_reklam/main.dart';
import 'package:ssshht_reklam/model/cafe.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

TextEditingController _passcontroller = TextEditingController();
TextEditingController _newpasscontroller = TextEditingController();
TextEditingController _kimlikcontroller = TextEditingController();
TextEditingController _namecontroller = TextEditingController();
Size _size = const Size(0, 0);
double _height = 0;
double _width = 0;

class NewLoginPage extends StatefulWidget {
  const NewLoginPage({Key? key}) : super(key: key);

  @override
  State<NewLoginPage> createState() => _NewLoginPageState();
}

class _NewLoginPageState extends State<NewLoginPage> {
  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.of(context).size;
    _height = _size.height;
    _width = _size.width;

    List<String> code =
        ModalRoute.of(context)!.settings.arguments as List<String>;
    return Container(
      color: backGroundColor,
      child: Flexible(
        child: ListView(
          children: [
            const KimlikNumarasi(),
            const KimlikInput(),
            const Name(),
            const NameInput(),
            const Pass(),
            const PassInput(),
            const NewPass(),
            const NewPassInput(),
            SendPassButton(code),
            SizedBox(
              height: _height / 2,
            ),
          ],
        ),
      ),
    );
  }
}

class Pass extends StatelessWidget {
  const Pass({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: (_height / 50)),
      child: Center(
        child: Text(
          'YENİ ŞİFRE',
          style: GoogleFonts.farro(
              fontSize: _width / 18,
              fontWeight: FontWeight.bold,
              color: Colors.white),
        ),
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
          top: (_height / 100), left: (_width / 15), right: (_width / 15)),
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
            fillColor: Colors.blue.shade50,
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
      margin: EdgeInsets.only(top: (_height / 50)),
      child: Center(
        child: Text(
          'TEKRAR YENİ ŞİFRE',
          style: GoogleFonts.farro(
              fontSize: _width / 18,
              fontWeight: FontWeight.bold,
              color: Colors.white),
        ),
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
          top: (_height / 100), right: (_width / 15), left: (_width / 15)),
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
            fillColor: Colors.blue.shade50,
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

class KimlikNumarasi extends StatelessWidget {
  const KimlikNumarasi({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: _height / 20),
      //margin: const EdgeInsets.only(top: 180),
      child: Center(
        child: Text(
          'KİMLİK NUMARASI\nVEYA\nVERGİ NUMARASI',
          style: GoogleFonts.farro(
              fontSize: _width / 18,
              fontWeight: FontWeight.bold,
              color: Colors.white),
        ),
      ),
    );
  }
}

class KimlikInput extends StatelessWidget {
  const KimlikInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: (_height / 80),
        left: (_width / 10),
        right: (_width / 10),
      ),
      child: TextField(
        decoration: InputDecoration(
            border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(30))),
            filled: true,
            fillColor: Colors.blue.shade50),
        controller: _kimlikcontroller,
        cursorColor: Colors.blue,
        keyboardType:
            const TextInputType.numberWithOptions(signed: true, decimal: true),
        textInputAction: TextInputAction.go,
      ),
    );
  }
}

class Name extends StatelessWidget {
  const Name({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: _height / 5),
      child: Center(
        child: Text(
          'İSİM VE SOYAD',
          style: GoogleFonts.farro(
              fontSize: _width / 18,
              fontWeight: FontWeight.bold,
              color: Colors.white),
        ),
      ),
    );
  }
}

class NameInput extends StatelessWidget {
  const NameInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: (_height / 90),
        left: (_width / 10),
        right: (_width / 10),
      ),
      child: TextField(
        decoration: InputDecoration(
            border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(30))),
            filled: true,
            fillColor: Colors.blue.shade50),
        controller: _namecontroller,
        cursorColor: Colors.blue,
        textInputAction: TextInputAction.go,
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
          top: (_height / 15),
          right: (_width / 10),
          left: (_width / 10),
          bottom: _height / 20),
      alignment: Alignment.center,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            elevation: 10,
            fixedSize: Size((_width / 1.2), (_height / 12.5)),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50))),
        child: const Text(
          'ŞİFRE OLUŞTUR',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20),
        ),
        onPressed: () {
          sendPass(context, code);
        },
      ),
    );
  }
}

sendPass(BuildContext context, List<String> code) async {
  if (_namecontroller.text.length < 2) {
    EasyLoading.showToast('İSİM ALANI EN AZ 2 HANE HANE OLAMLI');
    return;
  }

  if (!(_kimlikcontroller.text.length == 10 ||
      _kimlikcontroller.text.length == 11)) {
    EasyLoading.showToast('KİMLİK ALANI 10 VEYA 11 HANE OLAMLI');
    return;
  }

  if (_passcontroller.text.length < 6) {
    EasyLoading.showToast("ŞİFRE EN AZ 6 HANELİ OLMALIDIR!");
    return;
  }

  var kimlik = int.tryParse(_kimlikcontroller.text);
  if (kimlik == null) {
    EasyLoading.showToast('KİMLİK ALANI SAYILARDAN OLUŞMALIDIR!');
    return;
  }

  if (_kimlikcontroller.text.length == 11) {
    if (_kimlikcontroller.text[0] == '0') {
      EasyLoading.showToast('KİMLİK NUMARSININ İLK HANESİ 0 OLAMAZ!');
      return;
    }
    var tek = int.parse(_kimlikcontroller.text[0]) +
        int.parse(_kimlikcontroller.text[2]) +
        int.parse(_kimlikcontroller.text[4]) +
        int.parse(_kimlikcontroller.text[6]) +
        int.parse(_kimlikcontroller.text[8]);
    var cift = int.parse(_kimlikcontroller.text[1]) +
        int.parse(_kimlikcontroller.text[3]) +
        int.parse(_kimlikcontroller.text[5]) +
        int.parse(_kimlikcontroller.text[7]);

    var t10 = ((tek * 7) - cift) % 10;

    var t11 = ((int.parse(_kimlikcontroller.text[0]) +
            int.parse(_kimlikcontroller.text[1]) +
            int.parse(_kimlikcontroller.text[2]) +
            int.parse(_kimlikcontroller.text[3]) +
            int.parse(_kimlikcontroller.text[4]) +
            int.parse(_kimlikcontroller.text[5]) +
            int.parse(_kimlikcontroller.text[6]) +
            int.parse(_kimlikcontroller.text[7]) +
            int.parse(_kimlikcontroller.text[8]) +
            int.parse(_kimlikcontroller.text[9])) %
        10);

    var n10 = int.parse(_kimlikcontroller.text[9]);
    var n11 = int.parse(_kimlikcontroller.text[10]);

    if ((t10 == n10) && (t11 == n11)) {
    } else {
      EasyLoading.showToast('KİMLİK NUMARSI GEÇERSİZ!');
      return;
    }
  }

  if (_passcontroller.text == _newpasscontroller.text) {
    WebSocketChannel channel = IOWebSocketChannel.connect(url);

    Cafe pers = Cafe();
    var sign = Phone();
    sign.no = code[0];
    sign.code = code[1];
    pers.kimlik = _kimlikcontroller.text;
    pers.name = _namecontroller.text;

    pers.istekTip = 'ref_signup';
    pers.pass = _passcontroller.text;
    pers.phone = sign;
    var json = jsonEncode(pers.toMap());

    sendDataSignup(context, json, channel, pers.pass!);
  } else {
    EasyLoading.showToast('GİRDİĞİNİZ ŞİFRELER\n UYUŞMUYOR');
  }
}
