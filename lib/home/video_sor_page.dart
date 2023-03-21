import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ssshht_reklam/helpers/database.dart';
import 'package:ssshht_reklam/home/home_page.dart';
import 'package:ssshht_reklam/main.dart';
import 'package:ssshht_reklam/model/cafe.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

Size _size = const Size(0, 0);
double _height = 0;
double _width = 0;

Cafe _cafe = Cafe();
TextStyle _nameStyle = GoogleFonts.farro(
    fontSize: _width / 22, fontWeight: FontWeight.bold, color: Colors.black);

int _count = 0;
bool _busy = false;

class VideoSorPage extends StatefulWidget {
  const VideoSorPage({Key? key}) : super(key: key);

  @override
  State<VideoSorPage> createState() => _VideoSorPageState();
}

class _VideoSorPageState extends State<VideoSorPage> {
  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.of(context).size;
    _height = _size.height;
    _width = _size.width;
    _cafe = Cafe();
    _cafe = ModalRoute.of(context)!.settings.arguments as Cafe;
    return Container(
      color: backGroundColor,
      child: Column(
        children: const [
          Logo(),
          Flexible(child: VideoBody()),
        ],
      ),
    );
  }
}

class VideoBody extends StatefulWidget {
  const VideoBody({Key? key}) : super(key: key);

  @override
  State<VideoBody> createState() => _VideoBodyState();
}

class _VideoBodyState extends State<VideoBody> {
  @override
  Widget build(BuildContext context) {
    if (_cafe.videomongo != null) {
      _count = _cafe.videomongo!.length;
    }
    if (_count == 0) {
      _busy = true;
      _count = 1;
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [_baslikCard(), const Flexible(child: VideoList())],
    );
  }
}

class VideoList extends StatelessWidget {
  const VideoList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        if (_busy == true) {
          return const Center(
            child: Text('HİÇ VİDEO YOK'),
          );
        } else {
          var video = _cafe.videomongo![index];

          if (video.verify == true) {
            return _verifyedCard(video, context);
          }

          if (video.waiting == false) {
            return _rejectedCard(video, context);
          }

          return _waitingCard(video, context);
        }
      },
      itemCount: _count,
    );
  }
}

Widget _baslikCard() {
  return Column(
    children: [
      Container(
        margin: EdgeInsets.only(top: _height / 20, bottom: _height / 20),
        child: Center(
          child: Text(
            'VİDEO SEÇ',
            style: GoogleFonts.bungeeShade(
              fontWeight: FontWeight.bold,
              fontSize: _width / 15,
              color: const Color(0xFF212F3C),
            ),
          ),
        ),
      ),
      SizedBox(
        height: _height / 25,
        child: ListTile(
          leading: Container(
            margin: EdgeInsets.only(left: _width / 20),
            child: Text(
              'İSİM',
              style: GoogleFonts.farro(
                fontSize: _width / 15,
                fontWeight: FontWeight.bold,
                color: const Color(0xFFCCD1D1),
              ),
            ),
          ),
          trailing: Container(
            margin: EdgeInsets.only(right: _width / 20),
            child: Text(
              'ONAY',
              style: GoogleFonts.farro(
                fontSize: _width / 15,
                fontWeight: FontWeight.bold,
                color: const Color(0xFFCCD1D1),
              ),
            ),
          ),
        ),
      ),
    ],
  );
}

Card _verifyedCard(Video video, BuildContext context) {
  return Card(
    color: const Color(0xFFCCD1D1),
    child: ListTile(
        onTap: () async {
          var tok = await getToken(context);
          var token = Tokens();
          token.tokenDetails = tok;

          Cafe dur = Cafe();
          dur.tokens = token;
          dur.videoid = video.videoId;
          dur.videoDur = 0;
          dur.istekTip = "get_dur";

          WebSocketChannel channel = IOWebSocketChannel.connect(url);

          var json = jsonEncode(dur.toMap());
          channel.sink.add(json);

          channel.stream.listen(
            (data) {
              var jsonobject = jsonDecode(data);
              dur = Cafe.fromMap(jsonobject);
              if (dur.status == true) {
                List<dynamic> gelen = [_cafe, video.videoId, dur.videoDur];

                Navigator.pushNamed(context, '/VideoDetayPage',
                    arguments: gelen);
              } else {
                EasyLoading.showToast('BİR HATA OLDU');
              }
              channel.sink.close();
            },
            onError: (error) => _err(context),
            onDone: () => {},
          );
        },
        title: Text(
          video.videoName.toString(),
          style: _nameStyle,
        ),
        trailing: const Icon(
          Icons.verified,
          color: Colors.green,
        )),
  );
}

void _err(BuildContext context) {
  EasyLoading.showToast('BAĞLANTI HATASI');
}

Card _waitingCard(Video video, BuildContext context) {
  return Card(
    color: const Color(0XFFA6D7E7),
    child: ListTile(
        onTap: () async {
          if (video.waiting == null || video.verify == null) {
            EasyLoading.showToast(
                'BİR HATA OLUŞTU\nBİR SÜRE SONRA TEKRAR DENEYİNİZ',
                duration: const Duration(seconds: 5));
            return;
          }
          if (!video.verify!) {
            Navigator.pushNamed(context, '/RejectedVideoPage',
                arguments: video);
            return;
          }
        },
        title: Text(
          video.videoName.toString(),
          style: _nameStyle,
        ),
        trailing: const CircularProgressIndicator()),
  );
}

Card _rejectedCard(Video video, BuildContext context) {
  return Card(
    color: const Color(0XFFA6D7E7),
    child: ListTile(
        onTap: () async {
          if (video.verify != true) {
            Navigator.pushNamed(context, '/RejectedVideoPage',
                arguments: video);
            return;
          }
        },
        title: Text(
          video.videoName.toString(),
          style: _nameStyle,
        ),
        trailing: const Icon(
          Icons.dangerous,
          color: Colors.red,
        )),
  );
}
