import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:ssshht_reklam/helpers/database.dart';
import 'package:ssshht_reklam/main.dart';
import 'package:ssshht_reklam/model/cafe.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

Size _size = const Size(0, 0);
double _height = 0;
double _width = 0;
Cafe _cafe = Cafe();

class MusteriPage extends StatefulWidget {
  const MusteriPage({Key? key}) : super(key: key);

  @override
  State<MusteriPage> createState() => _MusteriPageState();
}

class _MusteriPageState extends State<MusteriPage> {
  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.of(context).size;
    _height = _size.height;
    _width = _size.width;
    _cafe = ModalRoute.of(context)!.settings.arguments as Cafe;
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: const [
        MusteriName(),
        MusteriBakiye(),
        BakiyeEkle(),
        ReklamVer(),
        NewVideo()
      ],
    );
  }
}

class MusteriName extends StatelessWidget {
  const MusteriName({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('MÜŞTERİ'),
        Text(_cafe.phone!.no.toString()),
      ],
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
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    _bakiyesor();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('BAKİYE'),
        Text(_cafe.bakiye.toString()),
      ],
    );
  }

  _bakiyesor() async {
    WebSocketChannel channel = IOWebSocketChannel.connect(url);
    var tok = await getToken(context);
    var token = Tokens();
    token.tokenDetails = tok;
    _cafe.tokens = token;
    _cafe.istekTip = 'bakiye_sor';

    var json = jsonEncode(_cafe.toMap());
    channel.sink.add(json);

    channel.stream.listen(
      (data) {
        var jsonobject = jsonDecode(data);
        _cafe = Cafe.fromMap(jsonobject);
        if (_cafe.status == true) {
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

class ReklamVer extends StatelessWidget {
  const ReklamVer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          elevation: 10,
          fixedSize: Size((_width * 0.8), (_height / 15)),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(50))),
      child: const Text('REKLAM VER'),
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
    _cafe.istekTip = 'sor_video';

    var json = jsonEncode(_cafe.toMap());
    channel.sink.add(json);

    channel.stream.listen(
      (data) {
        var jsonobject = jsonDecode(data);
        _cafe = Cafe.fromMap(jsonobject);
        if (_cafe.status == true) {
          Navigator.pushNamed(context, '/VideoSorPage', arguments: _cafe);
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
          elevation: 10,
          fixedSize: Size((_width * 0.8), (_height / 15)),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(50))),
      child: const Text('VİDEO EKLE'),
      onPressed: () {
        Navigator.pushNamed(context, '/NewVideoPage', arguments: _cafe);
      },
    );
  }
}

class BakiyeEkle extends StatelessWidget {
  const BakiyeEkle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          elevation: 10,
          fixedSize: Size((_width * 0.8), (_height / 15)),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(50))),
      child: const Text('BAKİYE EKLE'),
      onPressed: () {
        Navigator.pushNamed(context, '/BekiyeEklePage', arguments: _cafe);
      },
    );
  }
}
