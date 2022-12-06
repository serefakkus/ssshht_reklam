import 'package:flutter/material.dart';
import 'package:ssshht_reklam/login/giris_page.dart';

Size _size = const Size(0, 0);
double _height = 0;
double _width = 0;

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
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
    return Scaffold(
      body: Container(
        color: const Color(0XFF0017FF),
        child: ListView(
          children: const [
            QrImg(),
            GirisButon(),
            KayitButon(),
            GirissizButon(),
            _IyzicoLogo(),
            _BottomBarHakkimizda(),
          ],
        ),
      ),
    );
  }

  _setS() {
    setState(() {});
  }
}

class QrImg extends StatelessWidget {
  const QrImg({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(
          (_width / 3.5), (_height / 20), (_width / 3.5), (_height / 6)),
      alignment: Alignment.topCenter,
      width: _width / 2.5,
      height: _height / 4,
      decoration: const BoxDecoration(
          image: DecorationImage(
        image: AssetImage("assets/images/QR.png"),
        fit: BoxFit.contain,
      )),
    );
  }
}

class GirisButon extends StatelessWidget {
  const GirisButon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: (_height / 50), top: (_height / 20)),
      alignment: Alignment.center,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: Color(0XFF4D5262),
            elevation: 10,
            fixedSize: Size((_width * 0.8), (_height / 15)),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50))),
        child: const Text('GİRİŞ YAP'),
        onPressed: () {
          Navigator.pushNamed(context, '/GirisPage', arguments: 'seref');
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
      margin: EdgeInsets.only(bottom: (_height / 50)),
      alignment: Alignment.center,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: Color(0XFF4D5262),
            elevation: 10,
            fixedSize: Size((_width * 0.8), (_height / 15)),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50))),
        child: const Text('KAYIT OL'),
        onPressed: () {
          Navigator.pushNamed(context, '/KayitPage', arguments: 'seref');
        },
      ),
    );
  }
}

class GirissizButon extends StatelessWidget {
  const GirissizButon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () =>
          {Navigator.pushNamed(context, '/KodGirisPage', arguments: 'seref')},
      child: const Text(
        "ŞİFREMİ UNUTTUM",
        style: TextStyle(color: Colors.lightBlueAccent),
      ),
    );
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
      margin: EdgeInsets.only(top: _height / 20),
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
