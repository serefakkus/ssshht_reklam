import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ssshht_reklam/helpers/send.dart';
import 'package:ssshht_reklam/login/giris_page.dart';
import 'package:ssshht_reklam/main.dart';
import 'package:ssshht_reklam/model/cafe.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

TextEditingController _passcontroller = TextEditingController();
TextEditingController _newpasscontroller = TextEditingController();
TextEditingController _namecontroller = TextEditingController();
Size _size = const Size(0, 0);
double _height = 0;
double _width = 0;

bool _isOnay = false;

class NewLoginPage extends StatefulWidget {
  const NewLoginPage({Key? key}) : super(key: key);

  @override
  State<NewLoginPage> createState() => _NewLoginPageState();
}

class _NewLoginPageState extends State<NewLoginPage> {
  @override
  void initState() {
    _isOnay = false;
    super.initState();
    getTextS(_setS);
  }

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
          const Name(),
          const NameInput(),
          const Pass(),
          const PassInput(),
          const NewPass(),
          const NewPassInput(),
          const _SozlesmeOnay(),
          SendPassButton(code),
          const _BottomBarHakkimizda(),
        ],
      ),
    );
  }

  _setS() {
    setState(() {});
  }
}

class Pass extends StatelessWidget {
  const Pass({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: (_height / 10)),
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

class Name extends StatelessWidget {
  const Name({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: _height / 10),
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

class _SozlesmeOnay extends StatefulWidget {
  const _SozlesmeOnay({Key? key}) : super(key: key);

  @override
  State<_SozlesmeOnay> createState() => _SozlesmeOnayState();
}

class _SozlesmeOnayState extends State<_SozlesmeOnay> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: _height / 7),
      child: Row(
        children: [
          Checkbox(
            value: _isOnay,
            onChanged: (value) {
              _isOnay = !_isOnay;
              setState(() {});
            },
          ),
          TextButton(
            onPressed: () {
              _isOnay = !_isOnay;
              setState(() {});
              return;
            },
            child: Text(
              'Gizlilik Sözleşmesini okudum onaylıyorum.',
              style: TextStyle(color: Colors.black, fontSize: _width / 25),
            ),
          ),
        ],
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
          top: (_height / 50),
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
  if (!_isOnay) {
    EasyLoading.showToast('LÜTFEN SÖZLEŞMEYİ ONAYLAYINIZ !');
    return;
  }

  if (_namecontroller.text.length < 2) {
    EasyLoading.showToast('İSİM ALANI EN AZ 2 HANE HANE OLAMLI');
    return;
  }

  if (_passcontroller.text.length < 6) {
    EasyLoading.showToast("ŞİFRE EN AZ 6 HANELİ OLMALIDIR!");
    return;
  }

  if (_passcontroller.text == _newpasscontroller.text) {
    WebSocketChannel channel = IOWebSocketChannel.connect(url);

    Cafe pers = Cafe();
    var sign = Phone();
    sign.no = code[0];
    sign.code = code[1];
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

class _BottomBarHakkimizda extends StatelessWidget {
  const _BottomBarHakkimizda({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: const [
        _Hakkimizda(),
        _Ayrac(),
        _GizlilikPolitikasi(),
        _Ayrac(),
        _IptalVeIade(),
        _Ayrac(),
        _Iletisim(),
      ],
    );
  }
}

class _Hakkimizda extends StatelessWidget {
  const _Hakkimizda({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: const Text(
        'HAKKIMIZDA',
        style: TextStyle(color: Colors.white),
      ),
      onPressed: () {
        showModalBottomSheet(
          context: context,
          builder: (context) {
            return ListView(
              children: [
                Container(
                    margin: EdgeInsets.only(
                      top: _height / 20,
                      left: _width / 20,
                      right: _width / 20,
                    ),
                    child: Text(hakkimizdaText)),
              ],
            );
          },
        );
      },
    );
  }
}

class _Iletisim extends StatelessWidget {
  const _Iletisim({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: const Text(
        'İLETİŞİM',
        style: TextStyle(color: Colors.white),
      ),
      onPressed: () {
        showModalBottomSheet(
          context: context,
          builder: (context) {
            return ListView(
              children: [
                Container(
                    margin: EdgeInsets.only(
                      top: _height / 20,
                      left: _width / 20,
                      right: _width / 20,
                    ),
                    child: Text(iletisimText)),
              ],
            );
          },
        );
      },
    );
  }
}

class _GizlilikPolitikasi extends StatelessWidget {
  const _GizlilikPolitikasi({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: const Text(
        'GİZLİLİK\nPOLİTİKASI',
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white),
      ),
      onPressed: () {
        showModalBottomSheet(
          context: context,
          builder: (context) {
            return ListView(
              children: [
                Container(
                    margin: EdgeInsets.only(
                      top: _height / 20,
                      left: _width / 20,
                      right: _width / 20,
                    ),
                    child: Text(gizlilikText)),
              ],
            );
          },
        );
      },
    );
  }
}

class _IptalVeIade extends StatelessWidget {
  const _IptalVeIade({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: const Text(
        'TESLİMAT VE İADE',
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white),
      ),
      onPressed: () {
        showModalBottomSheet(
          context: context,
          builder: (context) {
            return ListView(
              children: [
                Container(
                    margin: EdgeInsets.only(
                      top: _height / 20,
                      left: _width / 20,
                      right: _width / 20,
                    ),
                    child: Text(teslimatIadeText)),
              ],
            );
          },
        );
      },
    );
  }
}

class _Ayrac extends StatelessWidget {
  const _Ayrac({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text(
      '|',
      style: TextStyle(color: Colors.black),
    );
  }
}

class _IyzicoLogo extends StatelessWidget {
  const _IyzicoLogo();

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      margin: EdgeInsets.only(top: _height / 100),
      width: _width,
      height: _height / 10,
      decoration: const BoxDecoration(
          //color: Colors.blueAccent,
          image: DecorationImage(
        image: AssetImage("assets/images/iyzico-logo.png"),
        fit: BoxFit.contain,
      )),
    );
  }
}

getTextS(Function setS) async {
  hakkimizdaText = await getFileData('assets/texts/hakkimizda.txt');
  gizlilikText = await getFileData('assets/texts/gizlilik-politikasi.txt');
  iletisimText = await getFileData('assets/texts/iletisim.txt');
  teslimatIadeText =
      await getFileData('assets/texts/teslimat_ve_iade_sartlari.txt');
  setS();
}
