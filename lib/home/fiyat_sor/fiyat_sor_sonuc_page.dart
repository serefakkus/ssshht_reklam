import 'package:flutter/material.dart';
import 'package:flutter_launcher_icons/xml_templates.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../main.dart';
import '../home_page.dart';

Size _size = const Size(0, 0);
double _height = 0;
double _width = 0;
int? _videoDur;
List<dynamic> _gelen = [];
double? _fiyatSaniye;

class FiyatSorSonucPage extends StatefulWidget {
  const FiyatSorSonucPage({Key? key}) : super(key: key);

  @override
  State<FiyatSorSonucPage> createState() => _FiyatSorSonucPageState();
}

class _FiyatSorSonucPageState extends State<FiyatSorSonucPage> {
  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.of(context).size;
    _height = _size.height;
    _width = _size.width;
    _gelen = ModalRoute.of(context)!.settings.arguments as List<dynamic>;
    _videoDur = _gelen[1];
    _fiyatSaniye = _gelen[2];
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
            SaniyeFiyatInfo(),
            FiyatInfo(),
            VideoSureBilgi(),
            SaniyeFiyatInfoWithBrosur(),
            FiyatInfoWithBrosur(),
            GirisButon(),
          ],
        ),
      ),
    );
  }
}

class VideoSure extends StatelessWidget {
  const VideoSure({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: _height / 15),
      //margin: const EdgeInsets.only(top: 180),
      child: Center(
        child: Column(
          children: [
            Text(
              'VİDEO SÜRESİ (SANİYE) = $_videoDur saniye',
              style: GoogleFonts.roboto(
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

class SaniyeFiyatInfo extends StatelessWidget {
  const SaniyeFiyatInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: _height / 15),
      //margin: const EdgeInsets.only(top: 180),
      child: Center(
        child: Column(
          children: [
            Text(
              'FİYAT (1 saniye ücreti) = ${_fiyatString(_fiyatSaniye, 1)} ₺',
              style: GoogleFonts.roboto(
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

class FiyatInfo extends StatelessWidget {
  const FiyatInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: _height / 15),
      //margin: const EdgeInsets.only(top: 180),
      child: Center(
        child: Column(
          children: [
            Text(
              'TOPLAM FİYAT = ${_fiyatString(_fiyatSaniye, _videoDur)} ₺',
              style: GoogleFonts.roboto(
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

class VideoSureBilgi extends StatelessWidget {
  const VideoSureBilgi({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (_videoDur == null) {
      return Container();
    }

    if (_videoDur! < 30) {
      return Container(
        margin: EdgeInsets.only(
            top: _height / 15, left: _width / 10, right: _width / 10),
        //margin: const EdgeInsets.only(top: 180),
        child: Card(
          color: Colors.white10,
          elevation: 0,
          shape: const RoundedRectangleBorder(
            side: BorderSide(
              color: Colors.white,
            ),
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          child: Container(
            margin: EdgeInsets.only(top: _height / 50, bottom: _height / 50),
            child: Text(
              'Menu içi broşür gösterími\n30 saniye ve üzeri videolarda\nücretsizdir !',
              style: GoogleFonts.roboto(
                fontSize: _width / 18,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }
    return Container(
      margin: EdgeInsets.only(
          top: _height / 15, left: _width / 10, right: _width / 10),
      //margin: const EdgeInsets.only(top: 180),
      child: Card(
        color: Colors.white10,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          side: BorderSide(
            color: Colors.white,
          ),
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        child: Container(
          margin: EdgeInsets.only(top: _height / 50, bottom: _height / 50),
          child: Text(
            'Menu içi broşür gösterími ücretsizdir',
            style: GoogleFonts.roboto(
              fontSize: _width / 18,
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade900,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

class SaniyeFiyatInfoWithBrosur extends StatelessWidget {
  const SaniyeFiyatInfoWithBrosur({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (_videoDur! >= 30) {
      return Container();
    }
    return Container(
      margin: EdgeInsets.only(top: _height / 15),
      //margin: const EdgeInsets.only(top: 180),
      child: Column(
        children: [
          Text(
            'MENÜ İÇİ REKLAM İLE \nFİYAT (1 saniye ücreti) = ${_fiyatString(((_fiyatSaniye! * 30) / _videoDur!), 1)} ₺',
            style: GoogleFonts.roboto(
              fontSize: _width / 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class FiyatInfoWithBrosur extends StatelessWidget {
  const FiyatInfoWithBrosur({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (_videoDur! >= 30) {
      return Container();
    }

    if (_fiyatSaniye == null) {
      return Container();
    }

    return Container(
      margin: EdgeInsets.only(
        top: _height / 15,
      ),
      //margin: const EdgeInsets.only(top: 180),
      child: Text(
        'MENÜ İÇİ REKLAM İLE \nTOPLAM FİYAT =  ${_fiyatString(_fiyatSaniye, 30)} ₺',
        style: GoogleFonts.roboto(
          fontSize: _width / 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        textAlign: TextAlign.center,
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
        top: _height / 8,
        left: _width / 10,
        right: _width / 10,
        bottom: _height / 8,
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            elevation: 10,
            fixedSize: Size((_width * 0.8), (_height / 15)),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50))),
        child: Text('ANA SAYFA', style: TextStyle(fontSize: _width / 20)),
        onPressed: () {
          Navigator.pushNamedAndRemoveUntil(context, '/HomePage',
              (route) => route.settings.name == '/HomePage');
        },
      ),
    );
  }
}

String _fiyatString(double? fiyat, int? videoDur) {
  if (fiyat == null) {
    return '0';
  }
  if (videoDur == null) {
    return '0';
  }
  fiyat = fiyat * videoDur;

  int? index;
  var str = fiyat.toString();
  for (var i = 0; i < str.length; i++) {
    if (str[i] == '.') {
      index = i;
      if (i == str.length - 2) {
        str = '${str}0';
      }
    }
  }

  var newStr = '';
  if (index != null) {
    for (var i = 0; i < str.length; i++) {
      newStr = newStr + str[i];
      if (i == index + 2) {
        i = str.length;
      }
    }
    return newStr;
  }

  return str;
}
