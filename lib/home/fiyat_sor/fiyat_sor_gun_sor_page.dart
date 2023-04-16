import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ssshht_reklam/home/home_page.dart';

import '../../main.dart';
import '../../model/cafe.dart';

Cafe _cafe = Cafe();
List<dynamic> _gelen = [];
Size _size = const Size(0, 0);
double _height = 0;
double _width = 0;
List<int>? _gunList;

class FiyatSorGunSorPage extends StatefulWidget {
  const FiyatSorGunSorPage({Key? key}) : super(key: key);

  @override
  State<FiyatSorGunSorPage> createState() => _FiyatSorGunSorPageState();
}

class _FiyatSorGunSorPageState extends State<FiyatSorGunSorPage> {
  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.of(context).size;
    _height = _size.height;
    _width = _size.width;
    _gelen = [];
    _gelen = ModalRoute.of(context)!.settings.arguments as List<dynamic>;
    _cafe = _gelen[0];
    _gunList = [];
    if (_cafe.paketList != null) {
      for (var i = 0; i < _cafe.paketList!.length; i++) {
        if (_cafe.paketList![i].day != null) {
          _gunList!.add(_cafe.paketList![i].day!);
        }
      }
    }
    if (_gunList != null) {
      var uniqGun = <int>{};
      for (var i = 0; i < _gunList!.length; i++) {
        uniqGun.add(_gunList![i]);
      }
      _gunList = uniqGun.toList();
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
    if (_gunList != null) {
      count = _gunList!.length + 2;
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
              margin: EdgeInsets.only(top: _height / 25),
              child: SizedBox(
                height: _height / 10,
                child: ListTile(
                  title: Center(
                    child: Text(
                      'GÜN SEÇ',
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
          var gun = _gunList![index];

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
              child: ListTile(
                title: Text(
                  '$gun GÜNLÜK',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
                onTap: () {
                  List<Paket> paketList = [];
                  for (var i = 0; i < _cafe.paketList!.length; i++) {
                    if (_cafe.paketList![i].day == gun) {
                      paketList.add(_cafe.paketList![i]);
                    }
                  }
                  _cafe.paketList = paketList;
                  _paketSor(context);
                },
              ),
            ),
          );
        }
      },
      itemCount: count,
    );
  }

  _paketSor(BuildContext context) {
    _gelen[0] = _cafe;
    Navigator.pushNamedAndRemoveUntil(context, '/PaketSorFiyatPage',
        (route) => route.settings.name == '/SehirSorFiyatPage',
        arguments: _gelen);
  }
}
