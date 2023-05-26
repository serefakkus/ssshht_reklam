import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

Size _size = const Size(0, 0);
double _height = 0;
double _width = 0;

String _html = '';

class ThreedsPage extends StatefulWidget {
  const ThreedsPage({Key? key}) : super(key: key);

  @override
  State<ThreedsPage> createState() => _ThreedsPageState();
}

class _ThreedsPageState extends State<ThreedsPage> {
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

    _html = ModalRoute.of(context)!.settings.arguments as String;

    String decoded = utf8.decode(base64.decode(_html));

    decoded = 'r"""$decoded"""';

    return WillPopScope(
      onWillPop: () {
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/',
          (route) => route.settings.name == '/FirstPage',
        );
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: _height / 12,
          actions: [
            Container(
              margin: EdgeInsets.only(right: _width / 10),
              child: IconButton(
                icon: Icon(
                  Icons.cancel,
                  color: Colors.red.shade400,
                  size: _width / 8,
                ),
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/',
                    (route) => route.settings.name == '/FirstPage',
                  );
                },
              ),
            ),
          ],
          automaticallyImplyLeading: false,
          leading: Container(
            margin: EdgeInsets.only(left: _width / 20),
            child: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                size: _width / 10,
              ),
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/',
                  (route) => route.settings.name == '/FirstPage',
                );
              },
            ),
          ),
        ),
        body: Center(
          child: WebViewPlus(
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (controller) {
              controller.loadString(decoded);
            },
          ),
        ),
      ),
    );
  }
}
