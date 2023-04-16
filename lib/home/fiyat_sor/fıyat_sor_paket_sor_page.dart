import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ssshht_reklam/home/home_page.dart';
import 'package:ssshht_reklam/home/video_detay_page.dart';
import 'package:ssshht_reklam/model/cafe.dart';

import '../../main.dart';

Cafe _cafe = Cafe();
List<dynamic> _gelen = [];
int? _videoDur;
Size _size = const Size(0, 0);
double _height = 0;
double _width = 0;

class FiyatSorPaketSorPage extends StatefulWidget {
  const FiyatSorPaketSorPage({Key? key}) : super(key: key);

  @override
  State<FiyatSorPaketSorPage> createState() => _FiyatSorPaketSorPageState();
}

class _FiyatSorPaketSorPageState extends State<FiyatSorPaketSorPage> {
  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.of(context).size;
    _height = _size.height;
    _width = _size.width;
    _gelen = [];
    _gelen = ModalRoute.of(context)!.settings.arguments as List<dynamic>;
    _cafe = _gelen[0];
    _videoDur = _gelen[1];

    if (_videoDur == 0 || _videoDur == null || _videoDur == -163) {
      _videoDur = videoDurFromFile;
    }

    return Container(
      color: backGroundColor,
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
            return Container(
              margin: EdgeInsets.only(top: _height / 30),
              child: SizedBox(
                height: _height / 15,
                child: ListTile(
                  title: Center(
                      child: Text(
                    'PAKET SEÇ',
                    style: GoogleFonts.bungeeShade(
                      fontWeight: FontWeight.bold,
                      fontSize: _width / 15,
                      color: const Color(0xFF212F3C),
                    ),
                  )),
                ),
              ),
            );
          }
          if (index == 1) {
            return Container(
              margin: EdgeInsets.only(bottom: _height / 30),
              child: Card(
                color: Colors.white.withOpacity(0),
                child: const ListTile(
                  leading: Text(
                    'PAKET İSMİ',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  trailing: Text(
                    'FİYAT (SANİYE)',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  title: Center(
                    child: Text(
                      'KAFELER',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
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
          return Column(
            children: [
              Center(
                child: Text(paket.name.toString(),
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: _width / 18)),
              ),
              Container(
                margin: EdgeInsets.only(
                    bottom: _height / 30,
                    left: _width / 30,
                    right: _width / 30),
                child: Card(
                  color: const Color(0XFFA6D7E7),
                  child: ListTile(
                    onTap: () {
                      _paketSor(context, paket.fiyat!);
                    },
                    leading: Text(paket.name.toString()),
                    trailing:
                        Text('${_fiyatString(paket.fiyat, _videoDur)} TL'),
                    title:
                        Center(child: Text(_infoString(paket.info.toString()))),
                    subtitle: Container(
                      margin: EdgeInsets.only(top: _height / 120),
                      child: Column(
                        children: [
                          Text(
                            'GÖRÜNTÜLEME =${_goruntuString(paket.goruntuleme)}',
                            style: TextStyle(
                                fontSize: _width / 25,
                                fontWeight: FontWeight.normal),
                          ),
                          Container(
                              margin: EdgeInsets.only(top: _height / 200),
                              child: Text(
                                'GÜN = ${paket.day}',
                                style: TextStyle(
                                    fontSize: _width / 25,
                                    fontWeight: FontWeight.normal),
                              )),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
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

  String _goruntuString(int? goruntuleme) {
    if (goruntuleme == null) {
      return '0';
    }

    String strOrginal = goruntuleme.toString();
    strOrginal = '${strOrginal}00';
    String str = strOrginal;
    int sayac = 0;

    for (var i = 0; i < strOrginal.length; i++) {
      if ((i % 3) == 2) {
        var strhelp = strOrginal.substring(0, strOrginal.length - i);
        var strhelp2 = str.substring(str.length - (i + sayac), str.length);
        str = '$strhelp,$strhelp2';
        sayac++;
      }
    }

    str = str.substring(0, str.length - 3);

    return str;
  }

  _paketSor(BuildContext context, double fiyat) {
    var giden = [_cafe, _videoDur, fiyat];
    Navigator.pushNamed(context, '/FiyatSorSonucPage', arguments: giden);
  }
}
