import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:ssshht_reklam/helpers/database.dart';
import 'package:ssshht_reklam/home/home_page.dart';
import 'package:ssshht_reklam/home/videodetay_page.dart';
import 'package:ssshht_reklam/model/cafe.dart';
import 'package:video_player/video_player.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:path_provider/path_provider.dart';

import '../main.dart';

List<dynamic> _gelen = [];
Cafe _cafe = Cafe();
String _videoid = '';
String _info = '';
double _fiyat = 0;
bool _isTarihSelect = false;
int _paketId = 0;
int _day = 0;
Size _size = const Size(0, 0);
double _height = 0;
double _width = 0;

String _ilkTarih = '';
String _sonTarih = '';
int _videoDur = 0;

List<String>? _videoList;
File _file = File('');
File _file2 = File('');
bool _isFirst = false;
VideoPlayerController videoController = VideoPlayerController.file(_file2);
bool _isDownloadedVideo = false;

class ReklamVerPage extends StatefulWidget {
  const ReklamVerPage({Key? key}) : super(key: key);

  @override
  State<ReklamVerPage> createState() => _ReklamVerPageState();
}

class _ReklamVerPageState extends State<ReklamVerPage> {
  @override
  void initState() {
    _isFirst = true;
    // ignore: todo
    // TODO: implement initState
    super.initState();
    _isTarihSelect = false;
    _ilkTarih = '';
    _sonTarih = '';
  }

  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.of(context).size;
    _height = _size.height;
    _width = _size.width;
    _gelen = [];
    _gelen = ModalRoute.of(context)!.settings.arguments as List<dynamic>;
    _cafe = _gelen[0];
    _videoid = _gelen[1];
    _paketId = _gelen[2];
    _day = _gelen[3];
    _fiyat = _gelen[4];
    _info = _gelen[5];
    _videoDur = _gelen[6];

    if (_isFirst) {
      _isDownloadedVideo = false;
      _isFirst = false;
      _getVideoIds(_setS);
    }
    // ignore: prefer_const_constructors
    return CafeSorBody();
  }

  _setS() {
    if (mounted) {
      setState(() {});
    }
  }
}

Future _getVideoIds(Function setS) async {
  var ok = false;
  _videoList = await videoIdSGet();
  if (_videoList != null) {
    for (var i = 0; i < _videoList!.length; i++) {
      if (_videoList![i] == _videoid) {
        ok = true;
      }
    }
    if (!ok && _videoList!.length > 1) {
      for (var i = 0; i < _videoList!.length; i++) {
        await _delvideo(_videoid);
      }
      await videoIdSDel();
    }
  }
  if (!ok) {
    await _downloadVideoRemote(_videoid);
  }
  try {
    videoController.dispose();
  } catch (e) {
    //print(e);
  }
  dir = await getApplicationDocumentsDirectory();
  _file = File("${dir.path}/reklamvideo/$_videoid");
  videoController = VideoPlayerController.file(_file);
  await videoController.initialize();
  _isDownloadedVideo = true;
  setS();
}

class CafeSorBody extends StatefulWidget {
  const CafeSorBody({Key? key}) : super(key: key);

  @override
  State<CafeSorBody> createState() => _CafeSorBodyState();
}

class _CafeSorBodyState extends State<CafeSorBody> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const Logo(),
        Center(
          child: Container(
              margin: EdgeInsets.only(top: (_height / 30)),
              child: const Text(
                'KAFELER',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              )),
        ),
        Center(
          child: Container(
              margin: EdgeInsets.only(top: (_height / 60)),
              child: Text(
                _infoString(_info),
                style: const TextStyle(
                    fontSize: 20, fontWeight: FontWeight.normal),
              )),
        ),
        const Divider(color: Colors.black),
        Center(
          child: Container(
              margin: EdgeInsets.only(top: (_height / 40)),
              child: const Text(
                'VİDEO',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              )),
        ),
        // ignore: prefer_const_constructors
        Video(_setState),
        const Divider(color: Colors.black),
        Container(
            margin: EdgeInsets.only(left: _width / 3, right: _width / 3),
            child: TarihSec(_setState)),
        Center(
          child: Container(
              margin: EdgeInsets.only(top: (_height / 15)),
              child: const Text(
                'BAŞLANGIÇ TARİHİ',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              )),
        ),
        Center(
          child: Container(
              margin: EdgeInsets.only(top: (_height / 60)),
              child: Text(
                _ilkTarih.toString(),
                style: const TextStyle(
                    fontSize: 20, fontWeight: FontWeight.normal),
              )),
        ),
        const Divider(color: Colors.black),
        Center(
          child: Container(
              margin: EdgeInsets.only(top: (_height / 15)),
              child: const Text(
                'BİTİŞ TARİHİ',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              )),
        ),
        Center(
          child: Container(
              margin: EdgeInsets.only(top: (_height / 60)),
              child: Text(
                _sonTarih.toString(),
                style: const TextStyle(
                    fontSize: 20, fontWeight: FontWeight.normal),
              )),
        ),
        const Divider(color: Colors.black),
        Center(
          child: Container(
              margin: EdgeInsets.only(top: (_height / 15)),
              child: const Text(
                'TOPLAM FİYAT',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              )),
        ),
        Center(
          child: Container(
              margin: EdgeInsets.only(top: (_height / 60)),
              child: Text(
                '${_fiyatString(_fiyat)} TL',
                style: const TextStyle(
                    fontSize: 20, fontWeight: FontWeight.normal),
              )),
        ),
        const Divider(color: Colors.black),
        const OnayButon()
      ],
    );
  }

  void _setState() {
    setState(() {});
  }
}

String _infoString(String? info) {
  if (info == null) {
    return '';
  }
  info = info.substring(1);
  return info;
}

class TarihSec extends StatefulWidget {
  // ignore: use_key_in_widget_constructors
  const TarihSec(this.resultCallback);
  final void Function() resultCallback;

  @override
  State<TarihSec> createState() => _TarihSecState();
}

class _TarihSecState extends State<TarihSec> {
  final DateTime _last = DateTime.now().add(const Duration(days: 90));
  final DateTime _suan = DateTime.now().add(const Duration(days: 1));
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: const Text('TARİH SEÇ'),
      onPressed: () {
        showDatePicker(
                context: context,
                initialDate: _suan,
                firstDate: _suan,
                lastDate: _last)
            .then((value) {
          _cafe.day = [];
          _isTarihSelect = true;
          for (var i = 0; i < _day; i++) {
            var strm = value!.month.toString();
            var strd = value.day.toString();
            if (strd.length != 2) {
              strd = '0$strd';
            }
            if (strm.length != 2) {
              strm = '0$strm';
            }

            var day = '$strd-$strm-${value.year}';
            if (i == 0) {
              _ilkTarih = day;
            }
            if (i == _day - 1) {
              _sonTarih = day;
            }
            _cafe.day!.add(day);
            value = value.add(const Duration(days: 1));
          }
          widget.resultCallback();
        });
      },
    );
  }
}

bool _isFirstTap = true;
double sizeHeight = _height / 15;

class Video extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  Video(this.resultCallback, {Key? key}) : super(key: key);
  final void Function() resultCallback;

  @override
  State<Video> createState() => _VideoState();
}

class _VideoState extends State<Video> {
  @override
  Widget build(BuildContext context) {
    if (!_isDownloadedVideo) {
      return Container(
        margin: EdgeInsets.only(top: _height / 4),
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    if (!videoController.value.isPlaying) {
      videoController.play();
    }

    // _controller.play();
    // _replay();
    return Container(
      margin: EdgeInsets.only(top: _height / 20),
      child: Column(
        children: [
          GestureDetector(
            child: SizedBox(
              height: sizeHeight,
              child: videoController.value.isInitialized
                  ? AspectRatio(
                      aspectRatio: videoController.value.aspectRatio,
                      child: VideoPlayer(videoController),
                    )
                  : Container(),
            ),
            onTap: () {
              if (_isFirstTap) {
                _isFirstTap = false;
                sizeHeight = _height / 2;
              } else {
                _isFirstTap = true;
                sizeHeight = _height / 15;
              }
              widget.resultCallback();
            },
          ),
          // ignore: prefer_const_constructors
          DurationSec(),
        ],
      ),
    );
  }

  @override
  void dispose() {
    try {
      videoController.dispose();
    } catch (e) {
      //print(e);
    }
    // ignore: todo
    // TODO: implement dispose
    super.dispose();
  }
}

class OnayButon extends StatelessWidget {
  const OnayButon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: (_height / 15),
        left: (_width / 10),
        right: (_width / 10),
        bottom: _height / 20,
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            elevation: 10,
            fixedSize: Size((_width * 0.8), (_height / 15)),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50))),
        child: const Text('ÖDEME YAP'),
        onPressed: () {
          _reklamVer(context);
        },
      ),
    );
  }

  void _reklamVer(BuildContext context) async {
    bool isRef = false;
    double fiyat = 0;
    fiyat = _fiyat;
    if (!_isTarihSelect) {
      EasyLoading.showToast('LÜTFEN TARİH SEÇİNİZ');
      return;
    }
    WebSocketChannel channel = IOWebSocketChannel.connect(url);
    var tok = await getToken(context);
    var token = Tokens();
    token.tokenDetails = tok;

    _cafe.tokens = token;

    _cafe.istekTip = 'fatura_bilgi_sor';
    var paketlist = _cafe.paketList;
    _cafe.paketList = null;

    var json = jsonEncode(_cafe.toMap());
    channel.sink.add(json);

    channel.stream.listen(
      (data) {
        var jsonobject = jsonDecode(data);
        _cafe = Cafe.fromMap(jsonobject);
        if (_cafe.status == true) {
          if (_cafe.istekTip != 'yok') {
            isRef = true;
          }
          Cafe pers = Cafe();
          pers.paketList = paketlist;
          pers.tokens = token;
          pers.istekTip = 'reklam_ver';
          pers.id = _cafe.id;
          pers.videoid = _videoid;
          pers.paketId = _paketId;
          pers.day = _cafe.day;
          pers.id = _cafe.id;
          pers.mail = _cafe.mail;

          List<dynamic> giden = [pers, fiyat, _cafe, isRef, _videoDur];

          Navigator.pushNamedAndRemoveUntil(context, '/FaturaPage',
              (route) => route.settings.name == '/HomePage',
              arguments: giden);
        } else {
          EasyLoading.showToast(
              'BİR HATA OLDU DEVAM EDERSE LÜTFEN BİZİMLE İLETİŞİME GEÇİNİZ');
        }
        channel.sink.close();
      },
      onError: (error) => EasyLoading.showToast('BAĞLANTI HATASI'),
      onDone: () => {},
    );
  }
}

String _fiyatString(double? fiyat) {
  if (fiyat == null) {
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

Future _downloadVideoRemote(String videoId) async {
  dir = await getApplicationDocumentsDirectory();
  bool ok = false;
  Dio dio = Dio();
  try {
    await dio.download(
      mediaUrl + videoId,
      "${dir.path}/reklamvideo/$videoId",
    );
    ok = true;
  } catch (e) {
    ok = false;
    if (kDebugMode) {
      print(e.toString());
    }
    EasyLoading.showToast('Internet bağlantınızı kontrol edin',
        duration: const Duration(seconds: 5));
  }
  if (ok) {
    _videoList = await videoIdSGet();

    _videoList ??= [];
    _videoList!.add(_videoid);
    await videoIdSInsert(_videoList);
  }
}

Future _delvideo(String videoId) async {
  var file = File("${dir.path}/reklamvideo/$videoId");

  try {
    await file.delete();
  } catch (e) {
    if (kDebugMode) {
      print(e);
    }
  }
}
