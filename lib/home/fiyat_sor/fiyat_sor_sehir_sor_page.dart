import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ssshht_reklam/helpers/database.dart';
import 'package:ssshht_reklam/home/home_page.dart';
import 'package:ssshht_reklam/model/cafe.dart';

import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../main.dart';

Cafe _cafe = Cafe();
List<dynamic> _gelen = [];
String _videoId = '';
Size _size = const Size(0, 0);
double _height = 0;
double _width = 0;
int? _videoDur;

class FiyatSorSehirSorPage extends StatefulWidget {
  const FiyatSorSehirSorPage({Key? key}) : super(key: key);

  @override
  State<FiyatSorSehirSorPage> createState() => _FiyatSorSehirSorPageState();
}

class _FiyatSorSehirSorPageState extends State<FiyatSorSehirSorPage> {
  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.of(context).size;
    _height = _size.height;
    _width = _size.width;
    _gelen = [];
    _gelen = ModalRoute.of(context)!.settings.arguments as List<dynamic>;
    _cafe = _gelen[0];
    _videoDur = _gelen[1];
    return Container(
      color: backGroundColor,
      child: const SehirBody(),
    );
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
              margin: EdgeInsets.only(bottom: _height / 30, top: _height / 15),
              child: SizedBox(
                height: _height / 15,
                child: ListTile(
                  title: Center(
                    child: Text(
                      'ŞEHİR SEÇ',
                      style: GoogleFonts.bungeeShade(
                        fontWeight: FontWeight.bold,
                        fontSize: _width / 15,
                        color: const Color(0xFF212F3C),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }

          index--;
          var video = _cafe.sehir![index];
          return Container(
            margin: EdgeInsets.only(
              top: _height / 100,
              left: _width / 50,
              right: _width / 50,
            ),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              color: const Color(0XFFA6D7E7),
              child: SizedBox(
                height: _height / 13,
                child: ListTile(
                  onTap: () {
                    _paketSor(context, video);
                  },
                  title: Center(
                      child: Text(
                    video.toString(),
                    style: TextStyle(
                      fontSize: _width / 20,
                      color: Colors.black,
                    ),
                  )),
                ),
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
          giden = [_cafe, _videoDur];
          Navigator.pushNamed(context, '/GunSorFiyatPage', arguments: giden);
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
