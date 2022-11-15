import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:ssshht_reklam/helpers/database.dart';
import 'package:ssshht_reklam/home/home_page.dart';
import 'package:ssshht_reklam/model/cafe.dart';

import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../main.dart';

Cafe _cafe = Cafe();
List<dynamic> _gelen = [];
String _videoId = '';
Size _size = const Size(0, 0);
double _height = 0;
double _width = 0;
int? _videoDur;

class SehirSorPage extends StatefulWidget {
  const SehirSorPage({Key? key}) : super(key: key);

  @override
  State<SehirSorPage> createState() => _SehirSorPageState();
}

class _SehirSorPageState extends State<SehirSorPage> {
  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.of(context).size;
    _height = _size.height;
    _width = _size.width;
    _gelen = [];
    _gelen = ModalRoute.of(context)!.settings.arguments as List<dynamic>;
    _cafe = _gelen[0];
    _videoId = _gelen[1];
    _videoDur = _gelen[2];
    return const SehirBody();
  }
}

class SehirBody extends StatefulWidget {
  const SehirBody({Key? key}) : super(key: key);

  @override
  State<SehirBody> createState() => _SehirBodyState();
}

class _SehirBodyState extends State<SehirBody> {
  @override
  Widget build(BuildContext context) {
    int count = 0;
    bool busy = false;
    if (_cafe.sehir != null) {
      var uniqSehir = <String>{};
      for (var i = 0; i < _cafe.sehir!.length; i++) {
        uniqSehir.add(_cafe.sehir![i]);
      }
      _cafe.sehir = uniqSehir.toList();
      count = _cafe.sehir!.length + 2;
    }
    if (count == 0) {
      busy = true;
      count = 2;
    }
    return ListView.builder(
      itemBuilder: (context, index) {
        if (index == 0) {
          return const Logo();
        }
        index--;
        if (busy == true) {
          return const Center(
            child: Text('HİÇ ŞEHİR YOK'),
          );
        } else {
          if (index == 0) {
            return Container(
              margin: EdgeInsets.only(bottom: _height / 20),
              child: Card(
                child: SizedBox(
                  height: _height / 10,
                  child: ListTile(
                    title: Center(
                        child: Text(
                      'ŞEHİR SEÇ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: _width / 20,
                      ),
                    )),
                  ),
                ),
              ),
            );
          }

          index--;
          var video = _cafe.sehir![index];
          return Card(
            child: SizedBox(
              height: _height / 10,
              child: ListTile(
                onTap: () {
                  _paketSor(context, video);
                },
                title: Center(
                    child: Text(
                  video.toString(),
                  style: TextStyle(
                    fontSize: _width / 20,
                  ),
                )),
              ),
            ),
          );
        }
      },
      itemCount: count,
    );
  }

  _paketSor(BuildContext context, String sehir) async {
    WebSocketChannel channel = IOWebSocketChannel.connect(url);
    var tok = await getToken(context);
    var token = Tokens();
    token.tokenDetails = tok;
    _cafe.tokens = token;
    _cafe.istekTip = 'paket_sor';
    _cafe.sehir = [sehir];

    var giden = [];
    _cafe.paketList = null;
    var json = jsonEncode(_cafe.toMap());
    channel.sink.add(json);

    channel.stream.listen(
      (data) {
        var jsonobject = jsonDecode(data);
        _cafe = Cafe.fromMap(jsonobject);
        if (_cafe.status == true) {
          giden = [_cafe, _videoId, _videoDur];
          Navigator.pushNamed(context, '/GunSorPage', arguments: giden);
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
