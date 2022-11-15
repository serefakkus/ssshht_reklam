import 'package:flutter/material.dart';
import 'package:ssshht_reklam/home/home_page.dart';

Size _size = const Size(0, 0);
double _height = 0;

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
    return const WebViewExample();
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
          child: const Center(
            child: Text(
              'Kredi karti ödeme sistemimiz yakında sizlerle',
              style: TextStyle(fontSize: 18),
            ),
          ),
        ),
      ],
    );
  }
}
