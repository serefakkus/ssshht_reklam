import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:ssshht_reklam/helpers/database.dart';
import 'package:ssshht_reklam/home/home_page.dart';
import 'package:ssshht_reklam/model/cafe.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import '../main.dart';

TextEditingController _namecontroller = TextEditingController();
Size _size = const Size(0, 0);
double _height = 0;
double _width = 0;
Cafe _cafe = Cafe();
bool _isFullScreen = false;
bool _isWaiting = false;

File? _video;
ImagePicker picker = ImagePicker();

File _file2 = File('');
VideoPlayerController _videoPlayerController =
    VideoPlayerController.file(_file2);

class NewVideoPage extends StatefulWidget {
  const NewVideoPage({Key? key}) : super(key: key);

  @override
  State<NewVideoPage> createState() => _NewVideoPageState();
}

class _NewVideoPageState extends State<NewVideoPage> {
  @override
  void initState() {
    _isWaiting = false;
    // ignore: todo
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.of(context).size;
    _height = _size.height;
    _width = _size.width;
    _cafe = ModalRoute.of(context)!.settings.arguments as Cafe;
    if (_isFullScreen) {
      SystemChrome.setPreferredOrientations(
          [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeLeft]);
    } else {
      SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    }

    if (_isWaiting) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_isFullScreen) {
      return Scaffold(
        body: UrunImg(_setS),
      );
    }
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const Logo(),
          const NameInput(),
          UrunImg(_setS),
          Container()
        ],
      ),
      bottomNavigationBar: OnayButon(_setS, _goHome),
    );
  }

  _setS() {
    setState(() {});
  }

  _goHome() {
    Navigator.pushNamedAndRemoveUntil(
        context, '/HomePage', (route) => route.settings.name == '/HomePage');
  }
}

class NameInput extends StatelessWidget {
  const NameInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'İSİM',
          style: TextStyle(fontSize: 20),
          textAlign: TextAlign.center,
        ),
        Container(
          margin: EdgeInsets.only(
              top: (_height / 120), left: (_width / 10), right: (_width / 10)),
          child: TextField(
            decoration: InputDecoration(
                border: const OutlineInputBorder(),
                filled: true,
                fillColor: Colors.blue.shade50),
            controller: _namecontroller,
            textInputAction: TextInputAction.go,
          ),
        ),
      ],
    );
  }
}

class OnayButon extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  OnayButon(this.resultCallback, this.goHome, {Key? key}) : super(key: key);
  final void Function() resultCallback;
  final void Function() goHome;

  @override
  State<OnayButon> createState() => _OnayButonState();
}

class _OnayButonState extends State<OnayButon> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          bottom: (_height / 18), left: (_width / 10), right: (_width / 10)),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            elevation: 10,
            fixedSize: Size((_width * 0.8), (_height / 15)),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50))),
        child: const Text('EKLE'),
        onPressed: () {
          _sendImage(context, widget.resultCallback, widget.goHome);
        },
      ),
    );
  }
}

_sendImage(BuildContext context, Function setS, Function goHome) async {
  if (_isAsset && _namecontroller.text.isNotEmpty) {
    _isWaiting = true;
    setS();
    _cafe.video = _imagebit;
    _cafe.videoname = _namecontroller.text;

    var tok = Tokens();
    tok.tokenDetails = await getToken(context);
    _cafe.tokens = tok;

    _cafe.istekTip = 'video_ekle';

    _cafe.videoTip = _imgtip;

    WebSocketChannel channel2 = IOWebSocketChannel.connect(url);

    var json = jsonEncode(_cafe.toMap());

    channel2.sink.add(json);

    channel2.stream.listen((data) {
      var musteri = Cafe();
      var jsonobject = jsonDecode(data);
      musteri = Cafe.fromMap(jsonobject);

      if (musteri.status == true) {
        EasyLoading.showToast('KAYIT BAŞARILI');
        _isWaiting = false;
        goHome();
        return;
      } else if (musteri.status == false) {
        EasyLoading.showToast(
            'VİDEO YÜKLERNİRKEN BİR HATA OLUŞTU\nTEKRAR DENEYİNİZ');
        _isWaiting = false;
        setS();
      } else {
        EasyLoading.showToast(
            'VİDEO YÜKLERNİRKEN BİR HATA OLUŞTU\nTEKRAR DENEYİNİZ');
        _isWaiting = false;
        setS();
      }

      channel2.sink.close();
    });
  } else if (!_isAsset) {
    EasyLoading.showToast('LÜTFEN VİDEO SEÇİNİZ');
    _isWaiting = false;
    setS();
  } else {
    EasyLoading.showToast('LÜTFEN İSİM GİRİNİZ');
    _isWaiting = false;
    setS();
  }
}

bool _isAsset = false;
Uint8List _imagebit = Uint8List(0);
String _imgtip = '';

class UrunImg extends StatefulWidget {
  const UrunImg(this.resultCallback, {Key? key}) : super(key: key);
  final void Function() resultCallback;
  @override
  State<UrunImg> createState() => _UrunImgState();
}

class _UrunImgState extends State<UrunImg> {
  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();

    _isAsset = false;
  }

  @override
  Widget build(BuildContext context) {
    if (_video != null) {
      if (_isFullScreen) {
        return SizedBox(
          height: (_height),
          width: _width,
          child: Stack(
            children: [
              SizedBox(
                height: (_height),
                width: _width,
                child: _videoPlayerController.value.isInitialized
                    ? AspectRatio(
                        aspectRatio: _videoPlayerController.value.aspectRatio,
                        child: VideoPlayer(_videoPlayerController),
                      )
                    : Container(),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  margin: EdgeInsets.only(
                    bottom: _height / 20,
                    right: _width / 20,
                  ),
                  child: IconButton(
                    icon: Icon(
                      Icons.fullscreen_exit,
                      size: _width / 15,
                    ),
                    onPressed: () {
                      _isFullScreen = false;
                      widget.resultCallback();
                    },
                  ),
                ),
              )
            ],
          ),
        );
      }
      return SizedBox(
        height: (_height / 2),
        child: Stack(
          children: [
            SizedBox(
              height: (_height / 2),
              child: _videoPlayerController.value.isInitialized
                  ? AspectRatio(
                      aspectRatio: _videoPlayerController.value.aspectRatio,
                      child: VideoPlayer(_videoPlayerController),
                    )
                  : Container(),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                margin: EdgeInsets.only(
                  bottom: _height / 30,
                  right: _width / 30,
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.fullscreen,
                    size: _width / 15,
                  ),
                  onPressed: () {
                    _isFullScreen = true;
                    widget.resultCallback();
                  },
                ),
              ),
            )
          ],
        ),
      );
    } else {
      return Center(
        child: GestureDetector(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(bottom: _height / 20),
                child: const Text(
                  'VİDEO YÜKLEMEK İÇİN TIKLAYIN',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              ClipRRect(
                  borderRadius: BorderRadius.circular(60),
                  child: const Icon(
                    Icons.add_a_photo,
                    size: 50,
                  )),
            ],
          ),
          onTap: () {
            _pickVideo();
          },
        ),
      );
    }
  }

  _pickVideo() async {
    XFile? pickedFile = await picker.pickVideo(source: ImageSource.gallery);
    if (pickedFile != null) {
      _isAsset = true;
      _video = File(pickedFile.path);
      _imagebit = _video!.readAsBytesSync();
      for (var i = 0; i < _video!.path.length; i++) {
        if (_video!.path[i] == '.') {
          _imgtip = _video!.path.substring(i + 1);
        }
      }

      try {
        await _videoPlayerController.dispose();
      } catch (e) {
        //print(e);
      }

      _videoPlayerController = VideoPlayerController.file(_video!)
        ..initialize().then((_) {
          setState(() {});
          _videoPlayerController.play();
          _videoPlayerController.setLooping(true);
        });
    }
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    // ignore: todo
    // TODO: implement dispose
    super.dispose();
  }
}
