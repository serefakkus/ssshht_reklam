import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ssshht_reklam/helpers/database.dart';
import 'package:ssshht_reklam/helpers/send.dart';
import 'package:ssshht_reklam/login/welcome_page.dart';
import 'package:ssshht_reklam/main.dart';
import 'package:ssshht_reklam/model/cafe.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'package:flutter/services.dart' show rootBundle;

Size _size = const Size(0, 0);
double _height = 0;
double _width = 0;
Cafe _pers = Cafe();

String hakkimizdaText = '';
String gizlilikText = '';
String iletisimText = '';
String teslimatIadeText = '';

TextEditingController _phonecontroller = TextEditingController();
TextEditingController _passcontroller = TextEditingController();

bool _isPressPass = false;

class GirisPage extends StatefulWidget {
  const GirisPage({Key? key}) : super(key: key);

  @override
  State<GirisPage> createState() => _GirisPageState();
}

class _GirisPageState extends State<GirisPage> {
  @override
  void initState() {
    getTextS(_setS);
    // ignore: todo
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.of(context).size;
    _height = _size.height;
    _width = _size.width;
    //String as = ModalRoute.of(context)!.settings.arguments as String;
    return const Scaffold(
      body: Giris(),
    );
  }

  _setS() {
    setState(() {});
  }
}

class Giris extends StatefulWidget {
  const Giris({Key? key}) : super(key: key);

  @override
  State<Giris> createState() => _GirisState();
}

class _GirisState extends State<Giris> {
  @override
  void initState() {
    super.initState();
    _getpass();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: const [
          TelefonNumarasi(),
          PhoneInput(),
          Sifre(),
          SifreInput(),
          GirisButon(),
          KayitButon(),
          GirissizButon(),
          _BottomBarHakkimizda(),
        ],
      ),
    );
  }

  _getpass() async {
    var s = await passGet();

    if (s.pass != null && s.pass != '' && s.name != null && s.name != '') {
      _phonecontroller.text = s.name!;
      _passcontroller.text = s.pass!;

      setState(() {});
    }
  }
}

sendLogin(BuildContext context) async {
  WebSocketChannel channel = IOWebSocketChannel.connect(url);

  if (_phonecontroller.text.isNotEmpty || _passcontroller.text.isNotEmpty) {
    //data.sign?.phone = _phonecontroller.text;
    //data.sign?.pass = _passcontroller.text;
    Phone phone = Phone();
    _pers.pass = _passcontroller.text;
    phone.no = _phonecontroller.text;
    _pers.phone = phone;

    _pers.istekTip = 'login';

    var json = jsonEncode(_pers.toMap());
    sendDataSignIn(context, json, channel);
  }
}

class TelefonNumarasi extends StatelessWidget {
  const TelefonNumarasi({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: (_height / 50)),
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
    return Container(
      margin: EdgeInsets.only(
          top: (_height / 90), left: (_width / 10), right: (_width / 10)),
      child: TextField(
        decoration: InputDecoration(
            border: const OutlineInputBorder(),
            filled: true,
            fillColor: Colors.blue.shade50),
        controller: _phonecontroller,
        cursorColor: Colors.blue,
        keyboardType:
            const TextInputType.numberWithOptions(signed: true, decimal: true),
        textInputAction: TextInputAction.go,
      ),
    );
  }
}

class Sifre extends StatelessWidget {
  const Sifre({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: (_height / 12)),
      child: const Text(
        'SIFRE',
        style: TextStyle(fontSize: 20),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class SifreInput extends StatefulWidget {
  const SifreInput({Key? key}) : super(key: key);

  @override
  State<SifreInput> createState() => _SifreInputState();
}

class _SifreInputState extends State<SifreInput> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          top: (_height / 120), left: (_width / 10), right: (_width / 10)),
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
          border: const OutlineInputBorder(),
          filled: true,
          fillColor: Colors.blue.shade50,
        ),
        controller: _passcontroller,
        textInputAction: TextInputAction.next,
        keyboardType: TextInputType.visiblePassword,
        obscureText: !_isPressPass,
        obscuringCharacter: '*',
      ),
    );
  }
}

Color _iconColor(bool isPressed) {
  if (isPressed) {
    return Colors.green;
  }
  return Colors.blue;
}

class GirisButon extends StatelessWidget {
  const GirisButon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          top: (_height / 5), left: (_width / 10), right: (_width / 10)),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            elevation: 10,
            fixedSize: Size((_width * 0.8), (_height / 15)),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50))),
        child: const Text('GİRİŞ YAP'),
        onPressed: () {
          sendLogin(context);
        },
      ),
    );
  }
}

class KayitButon extends StatelessWidget {
  const KayitButon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: (_height / 80), top: (_height / 20)),
      child: TextButton(
        onPressed: () => {
          Navigator.pushNamed(context, '/KayitPage'),
        },
        child: const Text("KAYIT OL"),
      ),
    );
  }
}

class _BottomBarHakkimizda extends StatelessWidget {
  const _BottomBarHakkimizda({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: _height / 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: const [
          _Hakkimizda(),
          _Ayrac(),
          _GizlilikPolitikasi(),
          _Ayrac(),
          _Iletisim(),
        ],
      ),
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
        style: TextStyle(color: Colors.green),
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
        style: TextStyle(color: Colors.green),
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
        style: TextStyle(color: Colors.green),
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

class _Ayrac extends StatelessWidget {
  const _Ayrac({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text('|');
  }
}

Future<String> getFileData(String path) async {
  return await rootBundle.loadString(path);
}

getTextS(Function setS) async {
  hakkimizdaText = await getFileData('assets/texts/hakkimizda.txt');
  gizlilikText = await getFileData('assets/texts/gizlilik-politikasi.txt');
  iletisimText = await getFileData('assets/texts/iletisim.txt');
  teslimatIadeText =
      await getFileData('assets/texts/teslimat_ve_iade_sartlari.txt');
  setS();
}
