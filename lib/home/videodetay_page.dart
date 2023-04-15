// ignore_for_file: unnecessary_const

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ssshht_reklam/helpers/database.dart';
import 'package:ssshht_reklam/home/home_page.dart';
import 'package:ssshht_reklam/model/cafe.dart';

import 'package:video_player/video_player.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

import '../main.dart';

List<dynamic> _gelen = [];
Cafe _cafe = Cafe();
String _videoid = '';
List<String>? _videoList;
int _videoDur = 0;
Size _size = const Size(0, 0);
double _height = 0;
double _width = 0;
int videoDurFromFile = 0;

Directory dir = Directory('');
File _file = File('');
File _file2 = File('');
bool _isFirst = false;
VideoPlayerController videoController = VideoPlayerController.file(_file2);
bool _isDownloadedVideo = false;

class VideoDetayPage extends StatefulWidget {
  const VideoDetayPage({Key? key}) : super(key: key);

  @override
  State<VideoDetayPage> createState() => _VideoDetayPageState();
}

class _VideoDetayPageState extends State<VideoDetayPage> {
  @override
  void initState() {
    _isFirst = true;
    // ignore: todo
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.of(context).size;
    _height = _size.height;
    _width = _size.width;
    _gelen = ModalRoute.of(context)!.settings.arguments as List<dynamic>;
    _cafe = _gelen[0];
    _videoid = _gelen[1];
    _videoDur = _gelen[2];
    if (_isFirst) {
      _isDownloadedVideo = false;
      _isFirst = false;
      _getVideoIds(_setS);
    }

    return Scaffold(
      backgroundColor: backGroundColor,
      body: ListView(
        // ignore: prefer_const_literals_to_create_immutables
        children: [
          const Logo(),
          // ignore: prefer_const_constructors
          Video(),
        ],
      ),
      bottomNavigationBar: const OnayButon(),
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
  videoController.setLooping(true);
  videoController.setVolume(0);
  videoDurFromFile = videoController.value.duration.inSeconds;
  _isDownloadedVideo = true;
  setS();
}

class DurationSec extends StatelessWidget {
  const DurationSec({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: _height / 15),
      child: Column(
        children: [
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
              child: SizedBox(
                height: _height / 20,
                child: Center(
                  child: Text(
                    'SÜRE = ${_sureStr(_videoDur)} saniye',
                    style: GoogleFonts.farro(
                        fontSize: _width / 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(
                top: (_height / 120),
                left: (_width / 10),
                right: (_width / 10)),
            child: Text(_cafe.videoname.toString()),
          ),
        ],
      ),
    );
  }
}

String _sureStr(int sure) {
  if (sure == -163 || sure == 0) {
    String str = videoDurFromFile.toString();
    return str;
  }
  String str = sure.toString();
  return str;
}

class Video extends StatefulWidget {
  const Video({Key? key}) : super(key: key);

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
          SizedBox(
            height: (_height / 2),
            child: videoController.value.isInitialized
                ? AspectRatio(
                    aspectRatio: videoController.value.aspectRatio,
                    child: VideoPlayer(videoController),
                  )
                : Container(),
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
          bottom: (_height / 30), left: (_width / 10), right: (_width / 10)),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            elevation: 10,
            fixedSize: Size((_width * 0.8), (_height / 15)),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50))),
        child: Text(
          'SEÇ',
          style: TextStyle(fontSize: _width / 20),
        ),
        onPressed: () {
          if (_videoDur == -163 || _videoDur == 0) {
            if (videoDurFromFile == 0) {
              EasyLoading.showToast(
                  'VİDEO YÜKLENENE KADAR BEKLEYİN SORUN DEVAM EDERSE \n BİZE info@ssshht.com MAİL ADRESİNDEN ULAŞABİLİRSİNİZ',
                  duration: const Duration(seconds: 6));
              return;
            }
          }
          _reklamVer(context);
        },
      ),
    );
  }

  _reklamVer(BuildContext context) async {
    WebSocketChannel channel = IOWebSocketChannel.connect(url);
    var tok = await getToken(context);
    var token = Tokens();
    token.tokenDetails = tok;
    _cafe.tokens = token;
    _cafe.istekTip = 'sehir_sor';

    var json = jsonEncode(_cafe.toMap());
    channel.sink.add(json);

    channel.stream.listen(
      (data) {
        var jsonobject = jsonDecode(data);
        _cafe = Cafe.fromMap(jsonobject);
        if (_cafe.status == true) {
          _gelen[0] = _cafe;
          Navigator.pushNamed(context, '/SehirSorPage', arguments: _gelen);
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
