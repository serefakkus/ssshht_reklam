import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ssshht_reklam/home/home_page.dart';
import 'package:ssshht_reklam/main.dart';
import 'package:video_player/video_player.dart';

import '../model/cafe.dart';

Directory dir = Directory('');
File? _imgFile;

Video _video = Video();
String _videourl = '';

String? _imageUrl;

bool _isImageDown = false;

Size _size = const Size(0, 0);
double _height = 0;
double _width = 0;

String _uyari = '';

class RejectedVideoPage extends StatefulWidget {
  const RejectedVideoPage({Key? key}) : super(key: key);

  @override
  State<RejectedVideoPage> createState() => _RejectedVideoPageState();
}

class _RejectedVideoPageState extends State<RejectedVideoPage> {
  @override
  void initState() {
    _imageUrl = null;
    _isImageDown = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _video = ModalRoute.of(context)!.settings.arguments as Video;
    _videourl = mediaUrl + _video.videoId!;

    if (_video.url != null && _video.url != '') {
      _imageUrl = imageUrl + _video.url!;
    }

    _size = MediaQuery.of(context).size;
    _height = _size.height;
    _width = _size.width;
    if (_video.waiting == false && _video.verify == false) {
      _uyari = 'VIDEO TOPLULUK KURALLARINA\nUYMADIĞI İÇİN ONAYLANMADI';
    } else if (_video.waiting == true) {
      _uyari = 'VIDEO MERKEZDEN ONAY BEKLİYOR';
    }

    return const Scaffold(
      body: RejectVideoBody(),
    );
  }
}

class RejectVideoBody extends StatefulWidget {
  const RejectVideoBody({Key? key}) : super(key: key);

  @override
  State<RejectVideoBody> createState() => _RejectVideoBodyState();
}

class _RejectVideoBodyState extends State<RejectVideoBody> {
  late VideoPlayerController _controller;
  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(_videourl)
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
        _controller.play();
        _controller.setVolume(0);
        _controller.setLooping(true);
      });
  }

  @override
  Widget build(BuildContext context) {
    if (!_controller.value.isPlaying) {
      _controller.play();
    }

    if (_width > _height) {
      return ListView(
        children: [
          const Logo(),
          const Uyari(),
          const VideoText(),
          Container(
            margin: EdgeInsets.only(
              left: _width / 5,
              right: _width / 5,
              bottom: _height / 20,
            ),
            height: (_height / 2),
            child: _controller.value.isInitialized
                ? AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  )
                : Container(),
          ),
          Divider(
            thickness: 3,
            color: Colors.grey.shade700,
            endIndent: 40,
            indent: 40,
          ),
          const ImageText(),
          const ReklamImage(),
          const Not(),
          const OnayButon(),
        ],
      );
    }

    return ListView(
      children: [
        const Logo(),
        const Uyari(),
        const VideoText(),
        Container(
          margin: EdgeInsets.only(
            top: _height / 50,
            bottom: _height / 50,
          ),
          height: (_height / 2),
          child: _controller.value.isInitialized
              ? AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                )
              : Container(),
        ),
        Divider(
          thickness: 3,
          color: Colors.grey.shade700,
        ),
        const ImageText(),
        const ReklamImage(),
        const Not(),
        const OnayButon(),
      ],
    );
  }
}

class Not extends StatelessWidget {
  const Not({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (_video.not != null && _video.not != '') {
      return Center(
        child: Text(
          'AÇIKLAMA\n${_video.not}',
          style: const TextStyle(
            color: Colors.black,
            fontSize: 23,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }
    return Container();
  }
}

class Uyari extends StatelessWidget {
  const Uyari({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: _height / 50,
      ),
      child: SizedBox(
        child: Center(
          child: Text(
            _uyari,
            style: const TextStyle(
              color: Colors.red,
              fontSize: 23,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
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
        top: _height / 20,
        bottom: _height / 30,
        left: _width / 5,
        right: _width / 5,
      ),
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              side: const BorderSide(
                color: Colors.white54,
                width: 1.5,
              ),
              backgroundColor: Colors.blueAccent.withOpacity(0.8),
              elevation: 20,
              fixedSize: Size((_width * 0.4), (_height / 16)),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30))),
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('TAMAM')),
    );
  }
}

class ReklamImage extends StatefulWidget {
  const ReklamImage({super.key});

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
    if (_imageUrl == null) {
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

    return Image.file(_imgFile!);
  }

  _setS() {
    setState(() {});
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
          color: Colors.black,
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
      margin: EdgeInsets.only(top: _height / 20, bottom: _height / 20),
      child: Center(
          child: Text(
        'MENÜ İÇİ RESİM',
        style: GoogleFonts.farro(
          fontSize: _width / 18,
          fontWeight: FontWeight.bold,
          color: Colors.black,
          decoration: TextDecoration.underline,
        ),
      )),
    );
  }
}

Future<void> _downloadReklamImageRemote(Function sets) async {
  if (_imageUrl != null) {
    dir = await getApplicationDocumentsDirectory();

    Dio dio = Dio();
    try {
      await dio.download(
        _imageUrl!,
        "${dir.path}/reklamimages/${_video.url}",
      );

      _imgFile = File("${dir.path}/reklamimages/${_video.url}");
      _isImageDown = true;
      sets();
    } catch (e) {
//
    }
  }
}
