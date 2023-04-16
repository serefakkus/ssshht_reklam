import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ssshht_reklam/helpers/database.dart';
import 'package:ssshht_reklam/helpers/upload_video.dart';

import 'package:ssshht_reklam/model/cafe.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:permission_handler/permission_handler.dart';
import '../main.dart';

TextEditingController _namecontroller = TextEditingController();
Size _size = const Size(0, 0);
double _height = 0;
double _width = 0;
Cafe _cafe = Cafe();

bool _isWaiting = false;

File? _videoFile;
String _videoPath = '';
ImagePicker _pickerVideo = ImagePicker();
bool _isAssetVideo = false;
Uint8List _videobit = Uint8List(0);
String _videotip = '';

int _videoDurationSec = 0;

File? _imgFile;
String _imgPath = '';
ImagePicker _pickerImg = ImagePicker();
bool _isAssetImg = false;
Uint8List _imgbit = Uint8List(0);
String _imgTip = '';

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
    _videoFile = null;
    _imgFile = null;
    _isAssetImg = false;
    _isAssetVideo = false;
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

    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

    if (_isWaiting) {
      return Stack(
        children: [
          const Center(child: CircularProgressIndicator()),
          Align(
            alignment: Alignment.center,
            child: Container(
                margin: EdgeInsets.only(bottom: _height / 6),
                child: Text(
                  'Video karşıya yükleniyor lütfen bekleyiniz',
                  style: TextStyle(fontSize: _width / 20),
                )),
          )
        ],
      );
    }
    return Scaffold(
      body: Container(
        color: backGroundColor,
        child: ListView(
          children: [
            const LogoNewVideoPage(),
            const NameInput(),
            const VideoText(),
            UrunVideo(_setS),
            Divider(
              thickness: 3,
              color: Colors.grey.shade700,
              endIndent: 40,
              indent: 40,
            ),
            const ImageText(),
            UrunImg(_setS),
            OnayButon(_setS, _goHome),
            Container()
          ],
        ),
      ),
    );
  }

  _setS() {
    setState(() {});
  }

  _goHome() {
    Navigator.pushNamedAndRemoveUntil(
        context, '/HomePage', (route) => route.settings.name == '/HomePage');
  }

  @override
  void dispose() {
    try {
      _videoPlayerController.dispose();
    } catch (e) {
      //print(e);
    }

    // ignore: todo
    // TODO: implement dispose
    super.dispose();
  }
}

class LogoNewVideoPage extends StatefulWidget {
  const LogoNewVideoPage({Key? key}) : super(key: key);

  @override
  State<LogoNewVideoPage> createState() => _LogoNewVideoPageState();
}

class _LogoNewVideoPageState extends State<LogoNewVideoPage> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.only(
            top: _height / 15,
          ),
          alignment: Alignment.topCenter,
          height: _height / 10,
          width: _width / 1,
          decoration: const BoxDecoration(
              image: DecorationImage(
            image: AssetImage("assets/images/logo.png"),
            fit: BoxFit.contain,
          )),
        ),
        const Align(
          alignment: Alignment.topLeft,
          child: GeriButonNewVideoPage(),
        ),
      ],
    );
  }
}

class GeriButonNewVideoPage extends StatelessWidget {
  const GeriButonNewVideoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: _height / 15),
      child: IconButton(
        icon: Icon(Icons.arrow_back_ios_new, size: _width / 8),
        onPressed: () {
          _videoFile = null;
          Navigator.pop(context);
        },
      ),
    );
  }
}

class NameInput extends StatelessWidget {
  const NameInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: _height / 20),
      child: Column(
        children: [
          Text(
            'VIDEO İSMİ',
            style: GoogleFonts.farro(
                fontSize: _width / 18,
                fontWeight: FontWeight.bold,
                color: Colors.white),
          ),
          Container(
            margin: EdgeInsets.only(
                top: (_height / 120),
                left: (_width / 10),
                right: (_width / 10)),
            child: TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30))),
                filled: true,
                fillColor: Color(0XFFA6D7E7),
              ),
              controller: _namecontroller,
              textInputAction: TextInputAction.go,
            ),
          ),
        ],
      ),
    );
  }
}

class VideoText extends StatelessWidget {
  const VideoText({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: _height / 20),
      child: Center(
          child: Text(
        'VİDEO',
        style: GoogleFonts.farro(
          fontSize: _width / 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          decoration: TextDecoration.underline,
        ),
      )),
    );
  }
}

class ImageText extends StatelessWidget {
  const ImageText({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: _height / 20),
      child: Center(
          child: Text(
        'RESİM',
        style: GoogleFonts.farro(
          fontSize: _width / 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          decoration: TextDecoration.underline,
        ),
      )),
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
      color: backGroundColor,
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
          _sendData(context);
        },
      ),
    );
  }
}

class UrunVideo extends StatefulWidget {
  const UrunVideo(this.resultCallback, {Key? key}) : super(key: key);
  final void Function() resultCallback;
  @override
  State<UrunVideo> createState() => _UrunVideoState();
}

class _UrunVideoState extends State<UrunVideo> {
  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_videoFile != null) {
      return Container(
        margin: EdgeInsets.only(bottom: _height / 50, top: _height / 20),
        child: SizedBox(
          height: (_height / 2),
          child: SizedBox(
            height: (_height / 2),
            child: _videoPlayerController.value.isInitialized
                ? AspectRatio(
                    aspectRatio: _videoPlayerController.value.aspectRatio,
                    child: VideoPlayer(_videoPlayerController),
                  )
                : Container(),
          ),
        ),
      );
    } else {
      return Container(
        margin: EdgeInsets.only(bottom: _height / 15),
        child: Center(
          child: GestureDetector(
            child: Column(
              children: [
                Container(
                  margin:
                      EdgeInsets.only(bottom: _height / 20, top: _height / 10),
                  child: Text(
                    'VİDEO YÜKLEMEK İÇİN TIKLAYIN',
                    style: GoogleFonts.farro(
                        fontSize: _width / 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
                ClipRRect(
                    borderRadius: BorderRadius.circular(60),
                    child: const Icon(
                      Icons.video_call,
                      size: 50,
                      color: Colors.white,
                    )),
              ],
            ),
            onTap: () {
              _pickVideo(context);
            },
          ),
        ),
      );
    }
  }

  _pickVideo(BuildContext context) async {
    bool ok = await _permissonReq(context, _setS);

    if (!ok) {
      return;
    }

    XFile? pickedFile =
        await _pickerVideo.pickVideo(source: ImageSource.gallery);
    if (pickedFile != null) {
      _isAssetVideo = true;
      _videoFile = File(pickedFile.path);
      _videoPath = pickedFile.path;
      _videobit = await _videoFile!.readAsBytes();
      for (var i = 0; i < _videoFile!.path.length; i++) {
        if (_videoFile!.path[i] == '.') {
          _videotip = _videoFile!.path.substring(i + 1);
        }
      }
      if (!Platform.isIOS) {
        if (_videotip != 'mp4') {
          EasyLoading.showToast('Lütfen "mp4" uzantılı bir dosya yükleyiniz!');
          _videoFile = null;
          return;
        }
      }

      if (Platform.isIOS) {
        _videotip = 'mov';
      }

      if (_videobit.length > 1024 * 1024 * 49) {
        EasyLoading.showToast('Lütfen 50 MB`tan küçük bir dosya yükleyiniz!');
        _videoFile = null;
        return;
      }

      try {
        await _videoPlayerController.dispose();
      } catch (e) {
        //print(e);
      }

      _videoPlayerController = VideoPlayerController.file(_videoFile!)
        ..initialize().then((_) {
          setState(() {});
          _videoPlayerController.play();
          _videoPlayerController.setLooping(true);
          _videoPlayerController.setVolume(0);
          _videoDurationSec = _videoPlayerController.value.duration.inSeconds;
        });
    }
  }

  _setS() {
    setState(() {});
  }

  @override
  void dispose() {
    //_videoPlayerController.dispose();
    // ignore: todo
    // TODO: implement dispose
    super.dispose();
  }
}

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
  }

  @override
  Widget build(BuildContext context) {
    if (_imgFile != null) {
      return Container(
        margin: EdgeInsets.only(bottom: _height / 20, top: _height / 10),
        child: SizedBox(
          child: Image.file(_imgFile!),
        ),
      );
    } else {
      return Container(
        margin: EdgeInsets.only(bottom: _height / 15),
        child: Center(
          child: GestureDetector(
            child: Column(
              children: [
                Container(
                  margin:
                      EdgeInsets.only(bottom: _height / 20, top: _height / 10),
                  child: Text(
                    'RESİM YÜKLEMEK İÇİN TIKLAYIN',
                    style: GoogleFonts.farro(
                        fontSize: _width / 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
                ClipRRect(
                    borderRadius: BorderRadius.circular(60),
                    child: const Icon(
                      Icons.add_a_photo,
                      size: 50,
                      color: Colors.white,
                    )),
              ],
            ),
            onTap: () {
              _pickImg(context);
            },
          ),
        ),
      );
    }
  }

  _pickImg(BuildContext context) async {
    bool ok = await _permissonReq(context, _setS);

    if (!ok) {
      return;
    }

    XFile? pickedFile = await _pickerImg.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _isAssetImg = true;
      _imgFile = File(pickedFile.path);
      _imgPath = pickedFile.path;
      _imgbit = await _imgFile!.readAsBytes();
      for (var i = 0; i < _imgFile!.path.length; i++) {
        if (_imgFile!.path[i] == '.') {
          _imgTip = _imgFile!.path.substring(i + 1);
        }
      }

      if (_imgbit.length > 1024 * 1024 * 50) {
        EasyLoading.showToast('Lütfen 50 MB`tan küçük bir dosya yükleyiniz!');
        _imgFile = null;
        return;
      }
    }
    _setS();
  }

  _setS() {
    setState(() {});
  }

  @override
  void dispose() {
    //_videoPlayerController.dispose();
    // ignore: todo
    // TODO: implement dispose
    super.dispose();
  }
}

Future<bool> _permissonReq(BuildContext context, Function setS) async {
  bool ok = false;
  if (await Permission.mediaLibrary.request().isGranted) {
    return true;
  } else {
    try {
      XFile? pickedFile =
          await _pickerVideo.pickVideo(source: ImageSource.gallery);
      if (pickedFile != null) {
        _isAssetVideo = true;
        _videoFile = File(pickedFile.path);
        _videobit = _videoFile!.readAsBytesSync();
        for (var i = 0; i < _videoFile!.path.length; i++) {
          if (_videoFile!.path[i] == '.') {
            _videotip = _videoFile!.path.substring(i + 1);
          }
        }

        try {
          await _videoPlayerController.dispose();
        } catch (e) {
          //print(e);
        }

        _videoPlayerController = VideoPlayerController.file(_videoFile!)
          ..initialize().then((_) {
            setS();
            _videoPlayerController.play();
            _videoPlayerController.setLooping(true);
            _videoPlayerController.setVolume(0);
            _videoDurationSec = _videoPlayerController.value.duration.inSeconds;
          });
      }
      ok = true;
    } catch (e) {
      //print(e);
    }
  }
  if (ok) {
    return true;
  }

  await showDialog(
      context: context,
      builder: (_) => AlertDialog(
            title: const Text('LÜTFEN AYARLARDAN GALERİ ERİŞİM İZNİ VERİN'),
            content: Row(
              children: const [
                MediaLibraryPermissionBackButon(),
                MediaLibraryPermissionButon(),
              ],
            ),
          ));
  ok = await Permission.mediaLibrary.request().isGranted;
  if (!ok) {
    // ignore: use_build_context_synchronously
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/HomePage',
      (route) => route.settings.name == '/HomePage',
    );
  }
  return ok;
}

class MediaLibraryPermissionButon extends StatelessWidget {
  const MediaLibraryPermissionButon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: _width / 20),
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              elevation: 10,
              fixedSize: Size((_width * 0.3), (_height / 15)),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20))),
          child: const Text('AYARLAR'),
          onPressed: () async {
            await openAppSettings();
          }),
    );
  }
}

class MediaLibraryPermissionBackButon extends StatelessWidget {
  const MediaLibraryPermissionBackButon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          elevation: 10,
          fixedSize: Size((_width * 0.3), (_height / 15)),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
      child: const Text('VAZGEÇ'),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }
}

_sendData(BuildContext context) async {
  if (_videoDurationSec < 10) {
    EasyLoading.showToast("VIDEO EN AZ 10 SANİYE OLAMLI");
    return;
  }

  showDialog(
    context: context,
    builder: (context) {
      return Container(
        height: _height,
        width: _width,
        color: Colors.white12,
        child: SizedBox(
          height: _width / 2,
          width: _width / 2,
          child: const CircularProgressIndicator(),
        ),
      );
    },
  );

  if (!_isAssetVideo) {
    EasyLoading.showToast('LÜTFEN VİDEO SEÇİNİZ');
    Navigator.pop(context);
    return;
  } else if (_namecontroller.text.isEmpty) {
    EasyLoading.showToast('LÜTFEN İSİM GİRİNİZ');
    Navigator.pop(context);
    return;
  }

  if (_isAssetImg) {
    _sendImage(context);
  } else {
    _sendVideo(context);
  }
}

_sendImage(BuildContext context) async {
  var tok = Tokens();
  tok.tokenDetails = await getToken(context);
  _cafe.tokens = tok;

  _cafe.istekTip = 'new_image_id';
  _cafe.videoTip = _imgTip;

  WebSocketChannel channel2 = IOWebSocketChannel.connect(url);
  var json = jsonEncode(_cafe.toMap());

  channel2.sink.add(json);

  channel2.stream.listen((data) async {
    var musteri = Cafe();
    var jsonobject = jsonDecode(data);
    musteri = Cafe.fromMap(jsonobject);

    if (musteri.status == true) {
      String? videoId;
      if (musteri.videoid != null && musteri.videoid != '') {
        videoId = musteri.videoid;
      } else {
        EasyLoading.showToast(
            'RESIM YÜKLERNİRKEN BİR HATA OLUŞTU\nTEKRAR DENEYİNİZ');
        Navigator.pop(context);
        return;
      }
      bool ok = false;
      ok = await uploadVideoToServer(_imgPath, videoId!, _imgTip);
      if (!ok) {
        EasyLoading.showToast(
            'RESIM YÜKLERNİRKEN BİR HATA OLUŞTU\nTEKRAR DENEYİNİZ');
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
        return;
      }
      _cafe.url = musteri.videoid;
      // ignore: use_build_context_synchronously
      _sendVideo(context);
    } else if (musteri.status == false) {
      EasyLoading.showToast(
          'RESIM YÜKLERNİRKEN BİR HATA OLUŞTU\nTEKRAR DENEYİNİZ');
      Navigator.pop(context);
    } else {
      EasyLoading.showToast(
          'RESIM YÜKLERNİRKEN BİR HATA OLUŞTU\nTEKRAR DENEYİNİZ');
      Navigator.pop(context);
    }

    channel2.sink.close();
  });
}

_sendVideo(BuildContext context) async {
  _cafe.videoname = _namecontroller.text;

  var tok = Tokens();
  tok.tokenDetails = await getToken(context);
  _cafe.tokens = tok;

  _cafe.istekTip = 'new_video_id';
  _cafe.videoTip = _videotip;
  _cafe.videoDur = _videoDurationSec;

  WebSocketChannel channel2 = IOWebSocketChannel.connect(url);
  var json = jsonEncode(_cafe.toMap());

  channel2.sink.add(json);

  channel2.stream.listen((data) async {
    var musteri = Cafe();
    var jsonobject = jsonDecode(data);
    musteri = Cafe.fromMap(jsonobject);

    if (musteri.status == true) {
      String? videoId;
      if (musteri.videoid != null && musteri.videoid != '') {
        videoId = musteri.videoid;
      } else {
        EasyLoading.showToast(
            'VİDEO YÜKLERNİRKEN BİR HATA OLUŞTU\nTEKRAR DENEYİNİZ');
        Navigator.pop(context);
        return;
      }
      bool ok = false;
      ok = await uploadVideoToServer(_videoPath, videoId!, _videotip);
      if (!ok) {
        EasyLoading.showToast(
            'VİDEO YÜKLERNİRKEN BİR HATA OLUŞTU\nTEKRAR DENEYİNİZ');
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
        return;
      }
      EasyLoading.showToast('KAYIT BAŞARILI');
      musteri.video = null;
      // ignore: use_build_context_synchronously
      Navigator.pushNamedAndRemoveUntil(
          context, '/HomePage', (route) => route.settings.name == '/HomePage',
          arguments: musteri);
    } else if (musteri.status == false) {
      EasyLoading.showToast(
          'VİDEO YÜKLERNİRKEN BİR HATA OLUŞTU\nTEKRAR DENEYİNİZ');
      Navigator.pop(context);
    } else {
      EasyLoading.showToast(
          'VİDEO YÜKLERNİRKEN BİR HATA OLUŞTU\nTEKRAR DENEYİNİZ');
      Navigator.pop(context);
    }

    channel2.sink.close();
  });
}
