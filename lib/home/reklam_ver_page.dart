import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ssshht_reklam/helpers/database.dart';
import 'package:ssshht_reklam/home/home_page.dart';
import 'package:ssshht_reklam/home/video_detay_page.dart';
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
double _ilkFiyat = 0;
bool _isTarihSelect = false;
int _paketId = 0;
int _day = 0;
Size _size = const Size(0, 0);
double _height = 0;
double _width = 0;

String _ilkTarih = '';
String _sonTarih = '';
int _videoDur = 0;
String _selectedDay = '';

List<String>? _videoList;
File _file = File('');
File _file2 = File('');
bool _isFirst = false;
VideoPlayerController videoController = VideoPlayerController.file(_file2);
bool _isDownloadedVideo = false;

bool _isOnay = false;

String? _imageId;
bool _isImageDown = false;
File? _imgFile;
double? _paketFiyat;

class ReklamVerPage extends StatefulWidget {
  const ReklamVerPage({Key? key}) : super(key: key);

  @override
  State<ReklamVerPage> createState() => _ReklamVerPageState();
}

class _ReklamVerPageState extends State<ReklamVerPage> {
  @override
  void initState() {
    _isFirst = true;
    _isOnay = false;
    _isImageDown = false;
    // ignore: todo
    // TODO: implement initState
    super.initState();
    _isTarihSelect = false;
    _ilkTarih = '';
    _sonTarih = '';
    _selectedDay = '';
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
    _imageId = _gelen[7];
    _paketFiyat = _gelen[8];

    _ilkFiyat = _fiyat;

    if (_isFirst) {
      _isDownloadedVideo = false;
      _isFirst = false;
      _getVideoIds(_setS);
    }
    // ignore: prefer_const_constructors
    return Container(
      color: backGroundColor,
      // ignore: prefer_const_constructors
      child: CafeSorBody(),
    );
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
  videoController.setVolume(0);
  videoController.setLooping(true);
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
            child: Text(
              'KAFELER',
              style: GoogleFonts.bungeeShade(
                fontWeight: FontWeight.bold,
                fontSize: _width / 18,
                color: const Color(0xFF212F3C),
              ),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(
            top: _height / 50,
            left: _width / 8,
            right: _width / 8,
          ),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            color: Colors.white.withOpacity(0),
            child: Center(
              child: Container(
                  margin: EdgeInsets.only(top: (_height / 60)),
                  child: Text(
                    _infoString(_info),
                    textAlign: TextAlign.center,
                    style: GoogleFonts.farro(
                      fontSize: _width / 20,
                      fontWeight: FontWeight.normal,
                      color: Colors.white,
                    ),
                  )),
            ),
          ),
        ),
        const Divider(color: Colors.white),
        Center(
          child: Container(
            margin: EdgeInsets.only(top: (_height / 40)),
            child: Text(
              'VİDEO',
              style: GoogleFonts.bungeeShade(
                fontWeight: FontWeight.bold,
                fontSize: _width / 18,
                color: const Color(0xFF212F3C),
              ),
            ),
          ),
        ),
        // ignore: prefer_const_constructors
        Video(_setState),
        const Divider(color: Colors.white),
        Center(
          child: Container(
            margin: EdgeInsets.only(top: (_height / 40)),
            child: Text(
              'MENÜ İÇİ RESİM',
              style: GoogleFonts.bungeeShade(
                fontWeight: FontWeight.bold,
                fontSize: _width / 18,
                color: const Color(0xFF212F3C),
              ),
            ),
          ),
        ),
        const Divider(color: Colors.white),
        ReklamImage(_setState),
        const Divider(color: Colors.white),
        Container(
            margin: EdgeInsets.only(left: _width / 3, right: _width / 3),
            child: TarihSec(_setState)),
        Center(
          child: Container(
            margin: EdgeInsets.only(top: (_height / 15)),
            child: Text(
              'BAŞLANGIÇ TARİHİ',
              style: GoogleFonts.bungeeShade(
                fontWeight: FontWeight.bold,
                fontSize: _width / 18,
                color: const Color(0xFF212F3C),
              ),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(
            top: _height / 50,
            left: _width / 5,
            right: _width / 5,
          ),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            color: Colors.white.withOpacity(0),
            child: Center(
              child: Container(
                  margin: EdgeInsets.only(top: (_height / 60)),
                  child: Text(
                    _tarihString(_ilkTarih),
                    style: GoogleFonts.farro(
                        fontSize: _width / 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  )),
            ),
          ),
        ),
        const Divider(color: Colors.white),
        Center(
          child: Container(
            margin: EdgeInsets.only(top: (_height / 30)),
            child: Text(
              'BİTİŞ TARİHİ',
              style: GoogleFonts.bungeeShade(
                fontWeight: FontWeight.bold,
                fontSize: _width / 20,
                color: const Color(0xFF212F3C),
              ),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(
            top: _height / 50,
            left: _width / 5,
            right: _width / 5,
          ),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            color: Colors.white.withOpacity(0),
            child: Center(
              child: Container(
                  margin: EdgeInsets.only(top: (_height / 60)),
                  child: Text(
                    _tarihString(_sonTarih),
                    style: GoogleFonts.farro(
                        fontSize: _width / 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  )),
            ),
          ),
        ),
        const Divider(color: Colors.white),
        Center(
          child: Container(
            margin: EdgeInsets.only(top: (_height / 15)),
            child: Text(
              'TOPLAM FİYAT',
              style: GoogleFonts.bungeeShade(
                fontWeight: FontWeight.bold,
                fontSize: _width / 18,
                color: const Color(0xFF212F3C),
              ),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(
            top: _height / 50,
            left: _width / 5,
            right: _width / 5,
          ),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            color: Colors.white.withOpacity(0),
            child: Center(
              child: Container(
                  margin: EdgeInsets.only(top: (_height / 60)),
                  child: Text(
                    '${_fiyatString(_fiyat)} TL',
                    style: GoogleFonts.farro(
                        fontSize: _width / 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  )),
            ),
          ),
        ),
        const Divider(color: Colors.white),
        // ignore: prefer_const_constructors
        _ResimOnay(_setState),
        const OnayButon(),
        const _IyzicoLogo(),
      ],
    );
  }

  void _setState() {
    setState(() {});
  }
}

String _tarihString(String? tarih) {
  if (_isTarihSelect == false) {
    return '';
  }
  if (tarih == null) {
    return '';
  }
  tarih =
      '${tarih.substring(0, 2)}/${tarih.substring(3, 5)}/${tarih.substring(6, 10)}';
  return tarih;
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
        showCupertinoModalPopup(
          context: context,
          builder: (context) => Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    var thisDay = _suan;
                    if (_selectedDay == '') {
                      _cafe.day = [];
                      _isTarihSelect = true;
                      for (var i = 0; i < _day; i++) {
                        var strm = thisDay.month.toString();
                        var strd = thisDay.day.toString();
                        if (strd.length != 2) {
                          strd = '0$strd';
                        }
                        if (strm.length != 2) {
                          strm = '0$strm';
                        }

                        var day = '$strd-$strm-${thisDay.year}';
                        _selectedDay = day;
                        if (i == 0) {
                          _ilkTarih = day;
                        }
                        if (i == _day - 1) {
                          _sonTarih = day;
                        }
                        _cafe.day!.add(day);
                        thisDay = thisDay.add(const Duration(days: 1));
                      }
                    }
                    widget.resultCallback();
                    Navigator.pop(context);
                  },
                  child: Text(
                    'ONAY',
                    style: GoogleFonts.farro(
                      fontSize: _width / 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 250,
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  backgroundColor: Colors.white,
                  initialDateTime: _suan,
                  maximumDate: _last,
                  minimumDate: _suan,
                  onDateTimeChanged: (value) {
                    _cafe.day = [];
                    _isTarihSelect = true;
                    for (var i = 0; i < _day; i++) {
                      var strm = value.month.toString();
                      var strd = value.day.toString();
                      if (strd.length != 2) {
                        strd = '0$strd';
                      }
                      if (strm.length != 2) {
                        strm = '0$strm';
                      }

                      var day = '$strd-$strm-${value.year}';
                      _selectedDay = day;
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
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

bool _isFirstTap = true;
double _sizeHeight = _height / 5;

class Video extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  Video(this.setS, {Key? key}) : super(key: key);
  final void Function() setS;

  @override
  State<Video> createState() => _VideoState();
}

class _VideoState extends State<Video> {
  @override
  Widget build(BuildContext context) {
    if (!_isDownloadedVideo) {
      return Container(
        margin: EdgeInsets.only(top: _height / 10, bottom: _height / 10),
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
              height: _sizeHeight,
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
                _sizeHeight = _height / 2;
              } else {
                _isFirstTap = true;
                _sizeHeight = _height / 5;
              }
              widget.setS();
            },
          ),
          // ignore: prefer_const_constructors
          DurationSec(),
        ],
      ),
    );
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

          List<dynamic> giden = [
            pers,
            fiyat,
            _cafe,
            isRef,
            _videoDur,
            _isOnay,
            _paketFiyat,
            _paketId,
            _videoid,
            _imageId,
            pers.day,
          ];

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

    //  print(e.toString());

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
    //  print(e);

  }
}

class _IyzicoLogo extends StatelessWidget {
  const _IyzicoLogo();

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      // margin: EdgeInsets.only(top: _height / 20),
      width: _width,
      height: _height / 10,
      decoration: const BoxDecoration(
          image: DecorationImage(
        image: AssetImage("assets/images/iyzico-logo.png"),
        fit: BoxFit.contain,
      )),
    );
  }
}

bool _isFirstTapImg = true;
double _sizeHeightImg = _height / 5;

class ReklamImage extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  ReklamImage(this.setS, {Key? key}) : super(key: key);
  final void Function() setS;

  @override
  State<ReklamImage> createState() => _ReklamImageState();
}

class _ReklamImageState extends State<ReklamImage> {
  @override
  void initState() {
    _downloadReklamImageRemote(_setS);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_imageId == null || _imageId == '') {
      return Center(
          child: Text(
        'HİÇ RESİM YÜKLENMEDİ !',
        style: GoogleFonts.farro(
          fontSize: _width / 18,
          fontWeight: FontWeight.bold,
          color: Colors.red,
          decoration: TextDecoration.underline,
        ),
      ));
    }

    if (!_isImageDown) {
      return const Center(child: CircularProgressIndicator());
    }

    return GestureDetector(
      child: SizedBox(height: _sizeHeightImg, child: Image.file(_imgFile!)),
      onTap: () {
        if (_isFirstTapImg) {
          _sizeHeightImg = _height / 1.5;
          _isFirstTapImg = !_isFirstTapImg;
        } else {
          _sizeHeightImg = _height / 5;
          _isFirstTapImg = !_isFirstTapImg;
        }
        widget.setS();
      },
    );
  }

  _setS() {
    setState(() {});
  }
}

Future<void> _downloadReklamImageRemote(Function sets) async {
  if (_imageId != null || _imageId == '') {
    dir = await getApplicationDocumentsDirectory();

    Dio dio = Dio();
    try {
      await dio.download(
        imageUrl + _imageId!,
        "${dir.path}/reklamimages/$_imageId",
      );

      _imgFile = File("${dir.path}/reklamimages/$_imageId");
      _isImageDown = true;
      sets();
    } catch (e) {
//
    }
  }
}

class _ResimOnay extends StatefulWidget {
  const _ResimOnay(this.setS, {Key? key}) : super(key: key);
  final void Function() setS;

  @override
  State<_ResimOnay> createState() => _ResimOnayState();
}

class _ResimOnayState extends State<_ResimOnay> {
  @override
  Widget build(BuildContext context) {
    if (_videoDur < 30 && (_imageId != null && _imageId != '')) {
      double toplam = 30 * _paketFiyat!;
      return Row(
        children: [
          Checkbox(
            value: _isOnay,
            onChanged: (value) {
              _isOnay = !_isOnay;
              if (_isOnay) {
                _fiyat = toplam;
              } else {
                _fiyat = _ilkFiyat;
              }
              widget.setS();
              setState(() {});
            },
          ),
          TextButton(
            onPressed: () {
              _isOnay = !_isOnay;
              if (_isOnay) {
                _fiyat = toplam;
              } else {
                _fiyat = _ilkFiyat;
              }
              widget.setS();
              setState(() {});
            },
            child: Text(
              'Menü içi resim istiyorum\n(Toplam Fiyat ${_fiyatString(toplam)})',
              style: TextStyle(color: Colors.white, fontSize: _width / 20),
            ),
          ),
        ],
      );
    }
    _isOnay = true;
    return Container();
  }
}
