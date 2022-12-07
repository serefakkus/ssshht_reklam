// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:ssshht_reklam/home/home_page.dart';
import 'package:ssshht_reklam/main.dart';
import 'package:video_player/video_player.dart';

import '../model/cafe.dart';

Video _video = Video();
String _videourl = '';

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
  Widget build(BuildContext context) {
    _video = ModalRoute.of(context)!.settings.arguments as Video;
    _videourl = mediaUrl + _video.videoId!;
    _size = MediaQuery.of(context).size;
    _height = _size.height;
    _width = _size.width;
    if (_video.waiting == false && _video.verify == false) {
      _uyari = 'VIDEO TOPLULUK KURALLARINA\nUYMADIĞI İÇİN ONAYLANMADI';
    } else if (_video.waiting == true) {
      _uyari = 'VIDEO ONAY BEKLİYOR';
    }

    return Scaffold(
      body: RejectVideoBody(),
      bottomNavigationBar: const OnayButon(),
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
      });
  }

  @override
  Widget build(BuildContext context) {
    if (!_controller.value.isPlaying) {
      _controller.play();
    }

    _replay();

    if (_width > _height) {
      return ListView(
        children: [
          const Logo(),
          Container(
            margin: EdgeInsets.only(
              left: _width / 5,
              right: _width / 5,
            ),
            height: (_height / 2),
            child: _controller.value.isInitialized
                ? AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  )
                : Container(),
          ),
          const Uyari(),
          const Not(),
        ],
      );
    }

    return ListView(
      children: [
        const Logo(),
        Container(
          margin: EdgeInsets.only(
            top: _height / 20,
          ),
          height: (_height / 2),
          child: _controller.value.isInitialized
              ? AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                )
              : Container(),
        ),
        const Uyari(),
        const Not(),
      ],
    );
  }

  _replay() async {
    await Future.delayed(const Duration(seconds: 10), () {
      _controller.play();
    });
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
    return SizedBox(
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
    );
  }
}

class OnayButon extends StatelessWidget {
  const OnayButon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        bottom: _height / 30,
        left: _width / 7,
        right: _width / 7,
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
