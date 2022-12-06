// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ssshht_reklam/helpers/database.dart';
import 'package:ssshht_reklam/main.dart';
import 'package:ssshht_reklam/model/cafe.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

Size _size = const Size(0, 0);
double _height = 0;
double _width = 0;
Cafe _cafe = Cafe();
int _videoCount = 0;
String _tel = '';
String? _name;
bool _isFirstBakiyeSor = true;
Color _backGround = Color(0XFF0017FF);

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.of(context).size;
    _height = _size.height;
    _width = _size.width;
    // _cafe = ModalRoute.of(context)!.settings.arguments as Cafe;
    if (_isFirstBakiyeSor) {
      _bakiyesor();
      _isFirstBakiyeSor = false;
    }

    return Scaffold(
      backgroundColor: _backGround,
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            // ignore: prefer_const_literals_to_create_immutables
            children: [
              Stack(
                // ignore: prefer_const_literals_to_create_immutables
                children: [
                  Container(
                    color: _backGround,
                    child: const LogoHomePage(),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    heightFactor: 1.32,
                    child: MusteriInfo(),
                  ),
                ],
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            heightFactor: 5.7,
            child: HomePageButtons(),
          )
        ],
      ),
    );
  }

  _bakiyesor() async {
    WebSocketChannel channel = IOWebSocketChannel.connect(url);
    var tok = await getToken(context);
    var token = Tokens();
    token.tokenDetails = tok;
    _cafe.tokens = token;
    _cafe.istekTip = 'hesap_sor';

    var json = jsonEncode(_cafe.toMap());
    channel.sink.add(json);

    channel.stream.listen(
      (data) {
        var jsonobject = jsonDecode(data);
        _cafe = Cafe.fromMap(jsonobject);
        if (_cafe.status == true) {
          _videoCount = _cafe.videoCount!;
          _tel = _cafe.phone!.no!;
          _name = _cafe.name;

          setState(() {});
        } else {
          EasyLoading.showToast('BAKİYE SORGU HATASI');
        }
        channel.sink.close();
      },
      onError: (error) => EasyLoading.showToast('BAĞLANTI HATASI'),
      onDone: () => {},
    );
  }
}

class LogoGirisPage extends StatefulWidget {
  const LogoGirisPage({Key? key}) : super(key: key);

  @override
  State<LogoGirisPage> createState() => _LogoGirisPageState();
}

class _LogoGirisPageState extends State<LogoGirisPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: _height / 15,
      ),
      alignment: Alignment.topCenter,
      height: _height / 10,
      width: _width / 1,
      decoration: const BoxDecoration(
          image: DecorationImage(
        image: AssetImage("assets/images/logo.png"),
        fit: BoxFit.contain,
      )),
    );
  }
}

class LogoHomePage extends StatefulWidget {
  const LogoHomePage({Key? key}) : super(key: key);

  @override
  State<LogoHomePage> createState() => _LogoHomePageState();
}

class _LogoHomePageState extends State<LogoHomePage> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.only(
            top: _height / 15,
          ),
          alignment: Alignment.topCenter,
          height: _height / 10,
          width: _width / 1,
          decoration: const BoxDecoration(
              image: DecorationImage(
            image: AssetImage("assets/images/logo.png"),
            fit: BoxFit.contain,
          )),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: CikisButon(),
        ),
      ],
    );
  }
}

class CikisButon extends StatefulWidget {
  const CikisButon({Key? key}) : super(key: key);

  @override
  State<CikisButon> createState() => _CikisButonState();
}

class _CikisButonState extends State<CikisButon> {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(top: _height / 20, right: _width / 20),
        child: IconButton(
          icon: Icon(
            Icons.logout,
            size: _width / 10,
            color: Colors.red,
          ),
          onPressed: () async {
            return showDialog(
                context: context,
                builder: (_) => AlertDialog(
                      title: const Text(
                          'OTURUMU KAPATMAK İSTEDİĞİNİZE EMİN MİSİNİZ?'),
                      content: Row(
                        children: const [
                          CikisBackButon(),
                          CikisOnayButon(),
                        ],
                      ),
                    ));
          },
        ));
  }
}

class CikisBackButon extends StatelessWidget {
  const CikisBackButon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          elevation: 10,
          fixedSize: Size((_width * 0.3), (_height / 15)),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
      child: const Text('VAZGEÇ'),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }
}

class CikisOnayButon extends StatelessWidget {
  const CikisOnayButon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: _width / 20),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            elevation: 10,
            fixedSize: Size((_width * 0.3), (_height / 15)),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20))),
        child: const Text('ÇIKIŞ YAP'),
        onPressed: () {
          _cikisYap(context);
        },
      ),
    );
  }

  _cikisYap(BuildContext context) async {
    WebSocketChannel channel = IOWebSocketChannel.connect(url);
    var tok = await getToken(context);
    var token = Tokens();
    token.tokenDetails = tok;
    _cafe.tokens = token;
    _cafe.istekTip = 'log_out';

    var json = jsonEncode(_cafe.toMap());
    channel.sink.add(json);

    channel.stream.listen(
      (data) {
        var jsonobject = jsonDecode(data);
        _cafe = Cafe.fromMap(jsonobject);
        if (_cafe.status == true || _cafe.status == false) {
          tokensDel();
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/FirstPage',
            (route) => route.settings.name == '/FirstPage',
          );
        } else {
          EasyLoading.showToast('BİR HATA OLDU');
        }
        channel.sink.close();
      },
      onError: (error) => EasyLoading.showToast('BAĞLANTI HATASI'),
      onDone: () => {},
    );
  }
}

class Logo extends StatefulWidget {
  const Logo({Key? key}) : super(key: key);

  @override
  State<Logo> createState() => _LogoState();
}

class _LogoState extends State<Logo> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.only(
            top: _height / 15,
          ),
          alignment: Alignment.topCenter,
          height: _height / 10,
          width: _width / 1,
          decoration: const BoxDecoration(
              image: DecorationImage(
            image: AssetImage("assets/images/logo.png"),
            fit: BoxFit.contain,
          )),
        ),
        Align(
          alignment: Alignment.topLeft,
          child: GeriButon(),
        ),
      ],
    );
  }
}

class GeriButon extends StatelessWidget {
  const GeriButon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: _height / 15),
      child: IconButton(
        icon: Icon(Icons.arrow_back_ios_new, size: _width / 8),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}

class MusteriInfo extends StatelessWidget {
  const MusteriInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: _width / 20, right: _width / 20),
      decoration: BoxDecoration(
          color: Color(0XFFA6D7E7),
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(30),
            topLeft: Radius.circular(30),
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          )),
      height: (_height / 15) * 8,
      child: Center(
        // ignore: duplicate_ignore
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          // ignore: prefer_const_literals_to_create_immutables, duplicate_ignore,
          children: [
            // ignore:
            MusteriName(),
            const Divider(color: Colors.black45),
            MusteriPhone(),
            const Divider(color: Colors.black45),
            // ignore:
            MusteriBakiye(),
          ],
        ),
      ),
    );
  }
}

class MusteriName extends StatelessWidget {
  const MusteriName({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _name ??= '';
    return Column(
      children: [
        Text(
          'KULLANICI İSMİ',
          style: GoogleFonts.farro(
              fontSize: _width / 18,
              fontWeight: FontWeight.bold,
              color: Colors.white),
        ),
        Card(
          elevation: 30,
          shape: RoundedRectangleBorder(
            borderRadius: const BorderRadius.all(Radius.circular(30)),
          ),
          color: const Color(0XFFA6D7E7),
          child: Container(
            width: _width / 1.5,
            margin: EdgeInsets.only(top: _height / 50, bottom: _height / 50),
            child: Center(
              child: Text(
                _name.toString(),
                style: GoogleFonts.farro(
                    fontSize: _width / 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class MusteriPhone extends StatelessWidget {
  const MusteriPhone({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: _height / 100),
      child: Column(
        children: [
          Text(
            'KULLANICI TELEFON',
            style: GoogleFonts.farro(
                fontSize: _width / 18,
                fontWeight: FontWeight.bold,
                color: Colors.white),
          ),
          Card(
            elevation: 30,
            shape: RoundedRectangleBorder(
              borderRadius: const BorderRadius.all(Radius.circular(30)),
            ),
            color: const Color(0XFFA6D7E7),
            child: Container(
              width: _width / 1.5,
              margin: EdgeInsets.only(top: _height / 50, bottom: _height / 50),
              child: Center(
                child: Text(
                  _tel,
                  style: GoogleFonts.farro(
                      fontSize: _width / 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MusteriBakiye extends StatefulWidget {
  const MusteriBakiye({Key? key}) : super(key: key);

  @override
  State<MusteriBakiye> createState() => _MusteriBakiyeState();
}

class _MusteriBakiyeState extends State<MusteriBakiye> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: _height / 100),
      child: Column(
        children: [
          Text(
            'VIDEO YÜKLEME HAKKI',
            style: GoogleFonts.farro(
                fontSize: _width / 18,
                fontWeight: FontWeight.bold,
                color: Colors.white),
          ),
          Card(
            elevation: 30,
            shape: RoundedRectangleBorder(
              borderRadius: const BorderRadius.all(Radius.circular(30)),
            ),
            color: const Color(0XFFA6D7E7),
            child: Container(
              width: _width / 1.5,
              margin: EdgeInsets.only(top: _height / 50, bottom: _height / 50),
              child: Center(
                  child: Text(
                '$_videoCount ADET',
                style: GoogleFonts.farro(
                    fontSize: _width / 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              )),
            ),
          ),
        ],
      ),
    );
  }
}

class HomePageButtons extends StatelessWidget {
  const HomePageButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
        topRight: Radius.circular(20),
        topLeft: Radius.circular(20),
        bottomLeft: Radius.circular(20),
        bottomRight: Radius.circular(20),
      )),
      height: (_height / 13) * 4,
      width: _width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: const [
          ReklamVer(),
          NewVideo(),
        ],
      ),
    );
  }
}

class ReklamVer extends StatelessWidget {
  const ReklamVer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          side: BorderSide(
            color: Color(0XFF4D5262),
            width: 1.5,
          ),
          backgroundColor: Color(0XFF4D5262),
          elevation: 20,
          fixedSize: Size((_width * 0.35), (_height / 6)),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(70))),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: _height / 50),
            child: Icon(
              Icons.video_collection,
              color: Colors.blue.shade300,
              size: 60,
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: _height / 50),
            child: Text(
              'REKLAM\nVER',
              textAlign: TextAlign.center,
              style: GoogleFonts.farro(
                  fontSize: _width / 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
        ],
      ),
      onPressed: () {
        _reklamVer(context);
      },
    );
  }

  _reklamVer(BuildContext context) async {
    WebSocketChannel channel = IOWebSocketChannel.connect(url);
    var tok = await getToken(context);
    var token = Tokens();
    token.tokenDetails = tok;
    _cafe.tokens = token;
    _cafe.istekTip = 'video_sor';

    var json = jsonEncode(_cafe.toMap());
    channel.sink.add(json);

    channel.stream.listen(
      (data) {
        var jsonobject = jsonDecode(data);
        _cafe = Cafe.fromMap(jsonobject);
        if (_cafe.status == true) {
          _isFirstBakiyeSor = true;
          Navigator.pushNamedAndRemoveUntil(context, '/VideoSorPage',
              (route) => route.settings.name == '/HomePage',
              arguments: _cafe);
        } else {
          EasyLoading.showToast('BİR HATA OLDU');
        }
        channel.sink.close();
      },
      onError: (error) => EasyLoading.showToast('BAĞLANTI HATASI'),
      onDone: () => {},
    );
  }
}

class NewVideo extends StatelessWidget {
  const NewVideo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          side: BorderSide(
            color: Color(0XFF4D5262),
            width: 1.5,
          ),
          backgroundColor: Color(0XFF4D5262),
          elevation: 50,
          fixedSize: Size((_width * 0.35), (_height / 6)),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(70))),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(
              left: _height / 50,
              top: _height / 100,
            ),
            child: Icon(
              Icons.video_call_sharp,
              color: Colors.blue.shade300,
              size: _width / 5,
            ),
          ),
          Text(
            'VİDEO\nEKLE',
            textAlign: TextAlign.center,
            style: GoogleFonts.farro(
                fontSize: _width / 20,
                fontWeight: FontWeight.bold,
                color: Colors.white),
          ),
        ],
      ),
      onPressed: () {
        if (_cafe.videoCount == null) {
          EasyLoading.showToast('BİR HATA OLUŞTU DAHA SONRA TEKRAR DENEYİNİZ');
          return;
        }
        if (_cafe.videoCount! > 0) {
          _isFirstBakiyeSor = true;
          Navigator.pushNamed(context, '/NewVideoPage', arguments: _cafe);
          return;
        }

        EasyLoading.showToast(
            'YENI VİDEO YÜKLEYEBİLMEK İÇİN\n REKLAM VERMELİSİNİZ');
      },
    );
  }
}
