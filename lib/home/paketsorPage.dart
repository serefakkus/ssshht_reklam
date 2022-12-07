import 'package:flutter/material.dart';
import 'package:ssshht_reklam/home/home_page.dart';
import 'package:ssshht_reklam/model/cafe.dart';

Cafe _cafe = Cafe();
List<dynamic> _gelen = [];
String _videoId = '';
int? _videoDur;
Size _size = const Size(0, 0);
double _height = 0;
double _width = 0;
double _fiyat = 0;

class PaketSorPage extends StatefulWidget {
  const PaketSorPage({Key? key}) : super(key: key);

  @override
  State<PaketSorPage> createState() => _PaketSorPageState();
}

class _PaketSorPageState extends State<PaketSorPage> {
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

    return Container(
      color: const Color(0XFF0017FF),
      child: const PaketBody(),
    );
  }
}

class PaketBody extends StatefulWidget {
  const PaketBody({Key? key}) : super(key: key);

  @override
  State<PaketBody> createState() => _PaketBodyState();
}

class _PaketBodyState extends State<PaketBody> {
  @override
  Widget build(BuildContext context) {
    int count = 0;
    bool busy = false;
    if (_cafe.paketList != null) {
      count = _cafe.paketList!.length + 3;
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
            child: Text('HİÇ PAKET YOK'),
          );
        } else {
          if (index == 0) {
            return Card(
              child: SizedBox(
                height: _height / 10,
                child: ListTile(
                  title: Center(
                      child: Text(
                    'PAKET SEÇ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: _width / 20,
                    ),
                  )),
                ),
              ),
            );
          }
          if (index == 1) {
            return Container(
              margin: EdgeInsets.only(bottom: _height / 30),
              child: const Card(
                child: ListTile(
                  leading: Text(
                    'PAKET İSMİ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  trailing: Text(
                    'FİYAT (SANİYE)',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  title: Center(
                    child: Text(
                      'KAFELER',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            );
          }
          index--;
          index--;
          var paket = _cafe.paketList![index];
          var dayCount = paket.day;
          return Card(
            child: ListTile(
              onTap: () {
                _paketSor(
                    context, paket.id!, dayCount!, paket.name!, paket.info!);
              },
              leading: Text(paket.name.toString()),
              trailing: Text('${_fiyatString(paket.fiyat, _videoDur)} TL'),
              title: Center(child: Text(_infoString(paket.info.toString()))),
              subtitle: Center(child: Text('GÜN = ${paket.day}')),
            ),
          );
        }
      },
      itemCount: count,
    );
  }

  String _infoString(String? info) {
    if (info == null) {
      return '';
    }
    info = info.substring(1);
    return info;
  }

  String _fiyatString(double? fiyat, int? videoDur) {
    if (fiyat == null) {
      return '0';
    }
    if (videoDur == null) {
      return '0';
    }
    fiyat = fiyat;
    _fiyat = fiyat * videoDur;
    var str = fiyat.toString();
    for (var i = 0; i < str.length; i++) {
      if (str[i] == '.') {
        if (i == str.length - 2) {
          str = '${str}0';
        }
      }
    }
    return str;
  }

  _paketSor(BuildContext context, int paketId, int day, String paketName,
      String info) {
    var giden = [_cafe, _videoId, paketId, day, _fiyat, info, _videoDur];
    Navigator.pushNamed(context, '/ReklamVerPage', arguments: giden);
  }
}
