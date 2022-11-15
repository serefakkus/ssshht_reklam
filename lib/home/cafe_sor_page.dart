import 'package:flutter/material.dart';
import 'package:ssshht_reklam/model/cafe.dart';

List<dynamic> _gelen = [];
Cafe _cafe = Cafe();
String _videoid = '';

Size _size = const Size(0, 0);
double _height = 0;

class CafeSorPage extends StatefulWidget {
  const CafeSorPage({Key? key}) : super(key: key);

  @override
  State<CafeSorPage> createState() => _CafeSorPageState();
}

class _CafeSorPageState extends State<CafeSorPage> {
  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.of(context).size;
    _height = _size.height;
    _gelen = ModalRoute.of(context)!.settings.arguments as List<dynamic>;
    _cafe = _gelen[0];
    _videoid = _gelen[1];

    return const CafeBody();
  }
}

class CafeBody extends StatefulWidget {
  const CafeBody({Key? key}) : super(key: key);

  @override
  State<CafeBody> createState() => _CafeBodyState();
}

class _CafeBodyState extends State<CafeBody> {
  @override
  Widget build(BuildContext context) {
    int count = 0;
    bool busy = false;
    if (_cafe.cafelist != null) {
      busy = false;
      count = _cafe.cafelist!.length + 1;
    }

    if (count == 0) {
      busy = true;
      count = 1;
    }

    return ListView.builder(
      itemBuilder: (context, index) {
        if (busy) {
          return const Center(
            child: Text('HİÇ KAFE YOK'),
          );
        } else {
          if (index == 0) {
            return _baslikCard();
          }
          index--;
          var caf = _cafe.cafelist![index];
          return Card(
            child: ListTile(
              onTap: () {
                List<dynamic> gelen2 = [_cafe, _videoid, caf];
                Navigator.pushNamed(context, '/ReklamVerPage',
                    arguments: gelen2);
              },
              title: Center(child: Text(caf.name.toString())),
            ),
          );
        }
      },
      itemCount: count,
    );
  }
}

Container _baslikCard() {
  return Container(
    margin: EdgeInsets.only(bottom: _height / 30),
    child: const Card(
      child: ListTile(
        title: Center(
          child: Text(
            'KAFE',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 25,
            ),
          ),
        ),
      ),
    ),
  );
}
