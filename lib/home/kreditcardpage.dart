import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ssshht_reklam/home/home_page.dart';

Size _size = const Size(0, 0);
double _height = 0;
double _width = 0;

class CreditCardPage extends StatefulWidget {
  const CreditCardPage({Key? key}) : super(key: key);

  @override
  State<CreditCardPage> createState() => _CreditCardPageState();
}

class _CreditCardPageState extends State<CreditCardPage> {
  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.of(context).size;
    _height = _size.height;
    _width = _size.width;
    return Container(
        color: const Color(0XFF0017FF), child: const WebViewExample());
  }
}

class WebViewExample extends StatefulWidget {
  const WebViewExample({Key? key}) : super(key: key);

  @override
  WebViewExampleState createState() => WebViewExampleState();
}

class WebViewExampleState extends State<WebViewExample> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const Logo(),
        Container(
          margin: EdgeInsets.only(top: _height / 3),
          child: Center(
            child: Text(
              'Kredi karti ödeme sistemimiz yakında sizlerle',
              style: GoogleFonts.farro(
                  fontSize: _width / 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
        ),
        const _IyzicoLogo(),
      ],
    );
  }
}

class _IyzicoLogo extends StatelessWidget {
  const _IyzicoLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      margin: EdgeInsets.only(top: _height / 3),
      width: _width,
      height: _height / 10,
      decoration: const BoxDecoration(
          image: DecorationImage(
        image: AssetImage("assets/images/iyzico-logo.png"),
        fit: BoxFit.contain,
      )),
    );
  }
}
