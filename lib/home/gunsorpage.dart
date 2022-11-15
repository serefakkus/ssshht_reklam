import 'package:flutter/material.dart';
import 'package:ssshht_reklam/home/home_page.dart';

import '../model/cafe.dart';

Cafe _cafe = Cafe();
List<dynamic> _gelen = [];
Size _size = const Size(0, 0);
double _height = 0;
double _width = 0;
List<int>? _gunList;

class GunSorPage extends StatefulWidget {
  const GunSorPage({Key? key}) : super(key: key);

  @override
  State<GunSorPage> createState() => _GunSorPageState();
}

class _GunSorPageState extends State<GunSorPage> {
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

    return const PaketBody();
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
      count = _gunList!.length + 3;
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
                    'GÜN SEÇ',
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
                  title: Text(
                    'GÜN',
                    style: TextStyle(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            );
          }
          index--;
          index--;
          var gun = _gunList![index];

          return Card(
            child: ListTile(
              title: Text('$gun GÜNLÜK'),
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
          );
        }
      },
      itemCount: count,
    );
  }

  _paketSor(BuildContext context) {
    _gelen[0] = _cafe;
    Navigator.pushNamedAndRemoveUntil(context, '/PaketSorPage',
        (route) => route.settings.name == '/SehirSorPage',
        arguments: _gelen);
  }
}
