import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ssshht_reklam/home/home_page.dart';
import 'package:ssshht_reklam/model/cafe.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../helpers/database.dart';
import '../../main.dart';

Size _size = const Size(0, 0);
double _height = 0;
double _width = 0;
Cafe _cafe = Cafe();
int? _videoDur;

List<dynamic> _gelen = [];

TextEditingController _sureController = TextEditingController();

class FiyatSorPage extends StatefulWidget {
  const FiyatSorPage({Key? key}) : super(key: key);

  @override
  State<FiyatSorPage> createState() => _FiyatSorPageState();
}

class _FiyatSorPageState extends State<FiyatSorPage> {
  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.of(context).size;
    _height = _size.height;
    _width = _size.width;
    _cafe = Cafe();
    _cafe = ModalRoute.of(context)!.settings.arguments as Cafe;
    return const Scaffold(
      body: VideoDur(),
    );
  }
}

class VideoDur extends StatefulWidget {
  const VideoDur({Key? key}) : super(key: key);

  @override
  State<VideoDur> createState() => _VideoDurState();
}

class _VideoDurState extends State<VideoDur> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: backGroundColor,
        child: ListView(
          children: const [
            Logo(),
            VideoSure(),
            VideoSureInput(),
            VideoSureBilgi(),
            GirisButon(),
          ],
        ),
      ),
    );
  }
}

_sehirSor(BuildContext context) async {
  if (_sureController.text.isEmpty) {
    EasyLoading.showToast('LÜTFEN SÜREYİ BOŞ BIRAKMAYIN !');
    return;
  }

  _videoDur = int.tryParse(_sureController.text);

  if (_videoDur == null) {
    EasyLoading.showToast('LÜTFEN TAM SAYI GİRİNİZ.\nSÜRE HATALI');
    return;
  }

  WebSocketChannel channel = IOWebSocketChannel.connect(url);
  var tok = await getToken(context);
  var token = Tokens();
  token.tokenDetails = tok;
  _cafe.tokens = token;
  _cafe.istekTip = 'sehir_sor';

  var json = jsonEncode(_cafe.toMap());
  channel.sink.add(json);

  channel.stream.listen(
    (data) {
      var jsonobject = jsonDecode(data);
      _cafe = Cafe.fromMap(jsonobject);
      if (_cafe.status == true) {
        _gelen = [_cafe, _videoDur];

        Navigator.pushNamed(context, '/SehirSorFiyatPage', arguments: _gelen);
      } else {
        EasyLoading.showToast('BİR HATA OLDU');
      }
      channel.sink.close();
    },
    onError: (error) => EasyLoading.showToast('BAĞLANTI HATASI'),
    onDone: () => {},
  );
}

class VideoSure extends StatelessWidget {
  const VideoSure({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: _height / 7),
      //margin: const EdgeInsets.only(top: 180),
      child: Center(
        child: Column(
          children: [
            Text(
              'İSTEDİĞİNİZ VİDEO SÜRESİ',
              style: GoogleFonts.farro(
                  fontSize: _width / 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            Text(
              '\n(SANİYE)',
              style: GoogleFonts.farro(
                  fontSize: _width / 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

class VideoSureInput extends StatelessWidget {
  const VideoSureInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          top: (_height / 30), left: (_width / 10), right: (_width / 10)),
      child: TextField(
        decoration: const InputDecoration(
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(30))),
          filled: true,
          fillColor: Color(0XFFA6D7E7),
        ),
        controller: _sureController,
        cursorColor: Colors.black,
        keyboardType: const TextInputType.numberWithOptions(
          signed: false,
          decimal: false,
        ),
        textInputAction: TextInputAction.go,
      ),
    );
  }
}

class VideoSureBilgi extends StatelessWidget {
  const VideoSureBilgi({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: _height / 7),
      //margin: const EdgeInsets.only(top: 180),
      child: Center(
        child: Text(
          'Menu içi broşür gösterími\n\n30 saniye ve üzeri videolarda\n\nücretsizdir !',
          style: GoogleFonts.farro(
            fontSize: _width / 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class GirisButon extends StatelessWidget {
  const GirisButon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          top: (_height / 15), left: (_width / 10), right: (_width / 10)),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.greenAccent.shade400,
            elevation: 10,
            fixedSize: Size((_width * 0.8), (_height / 15)),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50))),
        child: Text('FİYAT SOR', style: TextStyle(fontSize: _width / 20)),
        onPressed: () {
          _sehirSor(context);
        },
      ),
    );
  }
}
