import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ssshht_reklam/helpers/credit_cart.dart';
import 'package:ssshht_reklam/home/home_page.dart';
import 'package:ssshht_reklam/home/video_detay_page.dart';
import 'package:ssshht_reklam/model/cafe.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../helpers/database.dart';
import '../main.dart';

Size _size = const Size(0, 0);
double _height = 0;
double _width = 0;
int? _videoDur = 0;

List<dynamic> _gelen = [];
double _fiyat = 0;
bool _resimOnay = false;
List<Taksit>? _taksitler = [];
double? _toplamTutar;

int? _selectedTaksit;

int _paketId = 0;

String _imageId = '';
String _videoId = '';
List<String>? _days;
int _taksitSayisi = 1;

TextEditingController _creditCardController = TextEditingController();
TextEditingController _sKtController = TextEditingController();
TextEditingController _guvenlikController = TextEditingController();
TextEditingController _nameController = TextEditingController();

class CreditCardPage extends StatefulWidget {
  const CreditCardPage({Key? key}) : super(key: key);

  @override
  State<CreditCardPage> createState() => _CreditCardPageState();
}

class _CreditCardPageState extends State<CreditCardPage> {
  @override
  void initState() {
    if (!isTest) {
      _creditCardController.text = '';
      _sKtController.text = '';
      _guvenlikController.text = '';
      _nameController.text = '';
      _selectedTaksit = null;
    }
    _taksitler = [];
    _selectedTaksit = null;
    _toplamTutar = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.of(context).size;
    _height = _size.height;
    _width = _size.width;
    _gelen = ModalRoute.of(context)!.settings.arguments as List<dynamic>;

    _fiyat = _gelen[1];
    _resimOnay = _gelen[2];

    _paketId = _gelen[4];
    _videoId = _gelen[5];
    _imageId = _gelen[6];
    _days = _gelen[7];

    _toplamTutar = _fiyat;

    if (_videoDur == null || _videoDur == 0 || _videoDur == -163) {
      _videoDur = videoDurFromFile;
    }
    return Container(color: backGroundColor, child: const CreditCardBody());
  }
}

class CreditCardBody extends StatefulWidget {
  const CreditCardBody({Key? key}) : super(key: key);

  @override
  CreditCardBodyState createState() => CreditCardBodyState();
}

class CreditCardBodyState extends State<CreditCardBody> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const Logo(),
        const CreditCardText(),
        CreditCardInput(_setS),
        const NameText(),
        const NameInput(),
        const SktAndGuvenlik(),
        // ignore: prefer_const_constructors
        TaksitSec(_setS),
        // ignore: prefer_const_constructors
        ToplamTutar(),
        const OdemeButon(),
        const GuvenliOdemeText(),
        const _IyzicoLogo(),
      ],
    );
  }

  _setS() {
    setState(() {});
  }
}

class CreditCardText extends StatelessWidget {
  const CreditCardText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: _height / 40),
      child: Center(
        child: Text(
          'KART NUMARASI',
          style: GoogleFonts.farro(
            fontSize: _width / 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}

class CreditCardInput extends StatefulWidget {
  const CreditCardInput(this.setS, {Key? key}) : super(key: key);
  final void Function() setS;

  @override
  State<CreditCardInput> createState() => _CreditCardInputState();
}

class _CreditCardInputState extends State<CreditCardInput> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: _height / 70,
        left: _width / 10,
        right: _width / 10,
      ),
      child: TextField(
        maxLength: 19,
        buildCounter: (context,
            {required currentLength, required isFocused, maxLength}) {
          return;
        },
        decoration: const InputDecoration(
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
          filled: true,
          fillColor: Color(0XFFA6D7E7),
        ),
        controller: _creditCardController,
        cursorColor: Colors.black,
        keyboardType:
            const TextInputType.numberWithOptions(signed: true, decimal: true),
        textInputAction: TextInputAction.go,
        onChanged: (value) {
          _cardContol(_creditCardController.text);
          if (value.length == 7 ||
              value.length == 18 ||
              value.length == 19 ||
              value.length == 15 ||
              value.length == 16) {
            _taksitSor(widget.setS, context, _creditCardController.text);
          }
        },
      ),
    );
  }
}

void _cardContol(String card) {
  if (card.isEmpty) {
    return;
  }

  int? rakam = int.tryParse(card[card.length - 1]);

  if (rakam == null) {
    if (card[card.length - 1] != '-') {
      EasyLoading.showToast('Lütfen rakam kullanın!',
          duration: const Duration(seconds: 7));
    }

    if (card.length == 1) {
      _creditCardController.text = '';
      _creditCardController.selection = TextSelection.fromPosition(
        TextPosition(offset: _creditCardController.text.length),
      );
      return;
    }
    _creditCardController.text = card.substring(0, card.length - 1);
    _creditCardController.selection = TextSelection.fromPosition(
      TextPosition(offset: _creditCardController.text.length),
    );
    return;
  }

  if (card.length == 5 && card[4] == '-') {
    card = card.substring(0, 4);
  } else if (card.length == 5) {
    card = '${card.substring(0, 4)}-${card.substring(4)}';
  } else if (card.length == 4) {
    if (card[3] == '-') {
      card = card.substring(0, 3);
    } else if (card.length == 5) {
      card = '${card.substring(0, 4)}-${card.substring(4)}';
    }
  }

  if (card.length > 4) {
    if (card[4] == '-') {
      if (card.length == 10 && card[9] == '-') {
        card = card.substring(0, 9);
      } else if (card.length == 10) {
        card = '${card.substring(0, 9)}-${card.substring(9)}';
      } else if (card.length == 9) {
        if (card[8] == '-') {
          card = card.substring(0, 8);
        } else if (card.length == 10) {
          card = '${card.substring(0, 9)}-${card.substring(9)}';
        }
      }
    }
  }

  if (card.length > 9) {
    if (card[9] == '-' && card[4] == '-') {
      if (card.length == 15 && card[14] == '-') {
        card = card.substring(0, 14);
      } else if (card.length == 15) {
        card = '${card.substring(0, 14)}-${card.substring(14)}';
      } else if (card.length == 14) {
        if (card[13] == '-') {
          card = card.substring(0, 14);
        } else if (card.length == 15) {
          card = '${card.substring(0, 14)}-${card.substring(14)}';
        }
      }
    }
  }

  if (card.length > 14) {
    if (card[4] != '-') {
      card = '${card.substring(0, 4)}-${card.substring(4)}';
    }

    if (card[9] != '-') {
      card = '${card.substring(0, 9)}-${card.substring(9)}';
    }

    if (card.length > 15) {
      if (card[14] != '-') {
        card = '${card.substring(0, 14)}-${card.substring(14)}';
      }
    }

    if (card.length == 18) {
      card = card.substring(0, 18);
    }

    if (card.length > 18) {
      card = card.substring(0, 19);
    }
  }
  _creditCardController.text = card;
  _creditCardController.selection = TextSelection.fromPosition(
    TextPosition(offset: _creditCardController.text.length),
  );
}

_taksitSor(Function setS, BuildContext context, String binNumber) async {
  WebSocketChannel channel = IOWebSocketChannel.connect(url);
  Cafe pers = Cafe();
  var tok = await getToken(context);
  Tokens tokens = Tokens();
  tokens.tokenDetails = tok;
  pers.tokens = tokens;

  pers.binNumber = binNumber.substring(0, 4) + binNumber.substring(5, 7);

  pers.istekTip = 'tak_sor';

  pers.tutar = _fiyat;

  var json = jsonEncode(pers.toMap());

  channel.sink.add(json);

  channel.stream.listen((data) {
    var musteri = Cafe();
    var jsonobject = jsonDecode(data);
    musteri = Cafe.fromMap(jsonobject);

    if (musteri.status == true) {
      _taksitler = musteri.taksit;
      setS();
    } else {
      EasyLoading.showToast(
          'BİR HATA OLUŞTU SORUN DEVAM EDERSE BİZİMLE İLETİŞİME GEÇİNİZ');
    }
    channel.sink.close();
  });
}

class NameText extends StatelessWidget {
  const NameText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: _height / 16),
      child: Center(
        child: Text(
          'KART ÜZERİNDEKİ İSİM',
          style: GoogleFonts.farro(
            fontSize: _width / 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}

class NameInput extends StatelessWidget {
  const NameInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: _height / 70,
        left: _width / 10,
        right: _width / 10,
      ),
      child: TextField(
        decoration: const InputDecoration(
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
          filled: true,
          fillColor: Color(0XFFA6D7E7),
        ),
        controller: _nameController,
        cursorColor: Colors.black,
        textInputAction: TextInputAction.go,
      ),
    );
  }
}

class SktAndGuvenlik extends StatelessWidget {
  const SktAndGuvenlik({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: const [
            SKTText(),
            GuvenlikText(),
            CvvInfo(),
          ],
        ),
        Row(
          children: const [
            SKTInput(),
            GuvenlikInput(),
          ],
        ),
      ],
    );
  }
}

class SKTText extends StatelessWidget {
  const SKTText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: _height / 20,
        left: _width / 20,
      ),
      child: Center(
        child: Text(
          'SON KULLANMA TARİHİ',
          style: GoogleFonts.farro(
            fontSize: _width / 25,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}

class SKTInput extends StatefulWidget {
  const SKTInput({Key? key}) : super(key: key);

  @override
  State<SKTInput> createState() => _SKTInputState();
}

class _SKTInputState extends State<SKTInput> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _width / 2,
      child: Container(
        margin: EdgeInsets.only(
          top: _height / 70,
          left: _width / 20,
        ),
        child: TextField(
          maxLength: 5,
          decoration: const InputDecoration(
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            filled: true,
            fillColor: Color(0XFFA6D7E7),
          ),
          controller: _sKtController,
          cursorColor: Colors.black,
          keyboardType: const TextInputType.numberWithOptions(
              signed: true, decimal: true),
          textInputAction: TextInputAction.go,
          onChanged: (value) {
            _sktContol(_sKtController.text);
          },
        ),
      ),
    );
  }
}

void _sktContol(String skt) {
  String sktAyStr = '';
  String sktYilStr = '';
  int? sktAy;
  int? sktYil;
  if (skt.isEmpty) {
    return;
  }
  if (skt.length > 1) {
    sktAyStr = skt.substring(0, 2);
    sktAy = int.tryParse(sktAyStr);
    if (sktAy == null) {
      EasyLoading.showToast('Lütfen rakam kullanın!',
          duration: const Duration(seconds: 7));

      return;
    }

    if (sktAy > 12) {
      _sKtController.text = '';
      _sKtController.selection = TextSelection.fromPosition(
        TextPosition(offset: _sKtController.text.length),
      );
      EasyLoading.showToast('Ay 12 den büyük olamaz !',
          duration: const Duration(seconds: 7));
      return;
    }
  }

  if (skt.length == 3) {
    if (skt[2] != '/') {
      skt = '$sktAyStr/${skt.substring(2)}';
    }
  }

  if (skt.length > 4) {
    sktYilStr = skt.substring(3, 5);
    sktYil = int.tryParse(sktYilStr);

    if (sktYil == null) {
      EasyLoading.showToast('Lütfen rakam kullanın!',
          duration: const Duration(seconds: 7));
      _sKtController.text = '';
      _sKtController.selection = TextSelection.fromPosition(
        TextPosition(offset: _sKtController.text.length),
      );
      return;
    }
  }
  if (skt.length > 4) {
    skt = '$sktAyStr/$sktYilStr';
    bool ok = _dateController(skt);

    if (!ok) {
      EasyLoading.showToast('Kartin son kullanma tarihi geçmiş !',
          duration: const Duration(seconds: 7));
      _sKtController.text = '';
      _sKtController.selection = TextSelection.fromPosition(
        TextPosition(offset: _sKtController.text.length),
      );
      return;
    }
  }
  _sKtController.text = skt;
  _sKtController.selection = TextSelection.fromPosition(
    TextPosition(offset: _sKtController.text.length),
  );
}

bool _dateController(String date) {
  String sktAyStr = '';
  String sktYilStr = '';
  int sktAy;
  int sktYil;
  sktAyStr = date.substring(0, 2);
  sktAy = int.parse(sktAyStr);

  sktYilStr = date.substring(3, 5);
  sktYilStr = '20$sktYilStr';
  sktYil = int.parse(sktYilStr);

  int nowAy;
  int nowYil;

  DateTime now = DateTime.now();

  nowAy = now.month;
  nowYil = now.year;

  if (nowYil < sktYil) {
    return true;
  }

  if (nowYil > sktYil) {
    return false;
  }

  if (nowAy > sktAy) {
    return false;
  }

  return true;
}

class GuvenlikText extends StatelessWidget {
  const GuvenlikText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: _height / 20,
        left: _width / 8,
      ),
      child: Center(
        child: Text(
          'CVV',
          style: GoogleFonts.farro(
            fontSize: _width / 25,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}

class GuvenlikInput extends StatelessWidget {
  const GuvenlikInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _width / 2.3,
      child: Container(
        margin: EdgeInsets.only(
          top: _height / 70,
          left: _width / 13,
        ),
        child: TextField(
          maxLength: 4,
          decoration: const InputDecoration(
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            filled: true,
            fillColor: Color(0XFFA6D7E7),
          ),
          controller: _guvenlikController,
          cursorColor: Colors.black,
          keyboardType: const TextInputType.numberWithOptions(
              signed: true, decimal: true),
          textInputAction: TextInputAction.go,
        ),
      ),
    );
  }
}

class CvvInfo extends StatelessWidget {
  const CvvInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: _height / 22, left: _width / 50),
      child: IconButton(
        icon: CircleAvatar(
          backgroundColor: Colors.white.withOpacity(0.4),
          child: const Icon(Icons.question_mark),
        ),
        onPressed: () {
          _ccvInfoDialog(context);
        },
      ),
    );
  }
}

void _ccvInfoDialog(BuildContext context) {
  showCupertinoModalPopup<void>(
    context: context,
    builder: (BuildContext context) => CupertinoAlertDialog(
      title: const Text('CVV'),
      content: const Text(
          'Kartınızın arkasındaki 3 haneli sayı.\n(American express kartında\nön yüzde 4 hane)'),
      actions: <CupertinoDialogAction>[
        CupertinoDialogAction(
          /// This parameter indicates this action is the default,
          /// and turns the action's text to bold text.
          isDefaultAction: true,
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('TAMAM'),
        ),
      ],
    ),
  );
}

class TaksitSec extends StatefulWidget {
  const TaksitSec(this.setS, {Key? key}) : super(key: key);
  final void Function() setS;

  @override
  State<TaksitSec> createState() => _TaksitSecState();
}

class _TaksitSecState extends State<TaksitSec> {
  @override
  Widget build(BuildContext context) {
    if (_taksitler == null) {
      return Container();
    }

    if (_taksitler!.isEmpty) {
      return Container();
    }
    return Column(
      // ignore: prefer_const_literals_to_create_immutables
      children: [
        const TaksitInfo(),
        // ignore: prefer_const_constructors
        Taksitler(widget.setS),
      ],
    );
  }
}

class TaksitInfo extends StatelessWidget {
  const TaksitInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Text(
        'Taksit sayısı',
        style: GoogleFonts.farro(
          fontSize: _width / 26,
          fontWeight: FontWeight.normal,
          color: Colors.black,
        ),
      ),
      title: Center(
          child: Text(
        'Taksit tutari',
        style: GoogleFonts.farro(
          fontSize: _width / 26,
          fontWeight: FontWeight.normal,
          color: Colors.black,
        ),
      )),
      trailing: Text(
        'Toplam Tutar',
        style: GoogleFonts.farro(
          fontSize: _width / 26,
          fontWeight: FontWeight.normal,
          color: Colors.black,
        ),
      ),
    );
  }
}

class Taksitler extends StatefulWidget {
  const Taksitler(this.setS, {Key? key}) : super(key: key);
  final void Function() setS;

  @override
  State<Taksitler> createState() => _TaksitlerState();
}

class _TaksitlerState extends State<Taksitler> {
  @override
  Widget build(BuildContext context) {
    if (_taksitler == null) {
      return Container();
    }

    if (_taksitler!.isEmpty) {
      return Container();
    }

    return SizedBox(
      height: (_height / 12) * _taksitler!.length,
      child: ListView.builder(
          controller: ScrollController(),
          itemCount: _taksitler!.length,
          itemBuilder: (context, index) {
            return Card(
              color: _taksitColor(index),
              child: ListTile(
                leading: Text(
                  '${_taksitler![index].taksitSayisi}',
                  style: GoogleFonts.farro(
                    fontSize: _width / 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                title: Center(
                    child: Text(
                  '${_taksitler![index].taksitTutar} ₺',
                  style: TextStyle(
                    fontSize: _width / 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                )),
                trailing: Text(
                  '${_taksitler![index].toplamTutar} ₺',
                  style: TextStyle(
                    fontSize: _width / 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                onTap: () {
                  setState(() {
                    _selectedTaksit = index;
                    _toplamTutar = _taksitler![index].toplamTutar;
                    _taksitSayisi = _taksitler![index].taksitSayisi!;
                    widget.setS();
                  });
                },
              ),
            );
          }),
    );
  }
}

_taksitColor(int index) {
  if (index == _selectedTaksit) {
    return Colors.green;
  }
  return backGroundColor;
}

class ToplamTutar extends StatefulWidget {
  const ToplamTutar({super.key});

  @override
  State<ToplamTutar> createState() => _ToplamTutarState();
}

class _ToplamTutarState extends State<ToplamTutar> {
  @override
  Widget build(BuildContext context) {
    if (_toplamTutar == null) {
      return Container();
    }
    return Container(
      margin: EdgeInsets.only(top: _height / 50),
      child: Center(
        child: Text(
          'TOPLAM TUTAR : $_toplamTutar ₺',
          style: TextStyle(
            fontSize: _width / 22,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}

class OdemeButon extends StatelessWidget {
  const OdemeButon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          top: _height / 30, left: _width / 10, right: _width / 10),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            elevation: 10,
            fixedSize: Size((_width * 0.8), (_height / 18)),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50))),
        child: Text('iyzico ile öde', style: TextStyle(fontSize: _width / 20)),
        onPressed: () {
          _odemeSend(context);
        },
      ),
    );
  }
}

Future<void> _odemeSend(BuildContext context) async {
  if (!(_creditCardController.text.length == 19 ||
      _creditCardController.text.length == 18)) {
    EasyLoading.showToast('Kredi kartı numarası 15 veya 16 haneli olamlıdır !',
        duration: const Duration(seconds: 5));
    return;
  }

  if (_nameController.text.length < 5) {
    EasyLoading.showToast('Lütfen geçerli bir isim giriniz !',
        duration: const Duration(seconds: 5));
    return;
  }

  if (_sKtController.text.length != 5) {
    EasyLoading.showToast('Lütfen geçerli bir son kullanma tarihi giriniz !',
        duration: const Duration(seconds: 5));
    return;
  }

  if (!(_guvenlikController.text.length == 4 ||
      _guvenlikController.text.length == 3)) {
    EasyLoading.showToast('Lütfen geçerli bir CVV giriniz !',
        duration: const Duration(seconds: 5));
    return;
  }

  String cardNo = _textToCard();
  if (!validateCardNumWithLuhnAlgorithm(cardNo)) {
    EasyLoading.showToast('Kredi kartı numarası geçersiz !',
        duration: const Duration(seconds: 5));
    return;
  }

  List<String>? sktList = _getSkt();
  if (sktList == null) {
    return;
  }

  int? guvenlik = int.tryParse(_guvenlikController.text);

  if (guvenlik == null) {
    EasyLoading.showToast('Lütfen geçerli bir CVV giriniz !',
        duration: const Duration(seconds: 5));
    return;
  }

  if (_selectedTaksit == null) {
    EasyLoading.showToast('Lütfen taksit seçiniz !',
        duration: const Duration(seconds: 5));
    return;
  }

  WebSocketChannel channel = IOWebSocketChannel.connect(url);
  Cafe pers = Cafe();
  var tok = await getToken(context);
  Tokens tokens = Tokens();
  tokens.tokenDetails = tok;
  pers.tokens = tokens;

  CreditCard card = CreditCard();
  card.cardHolderName = _nameController.text;
  card.cardNumber = cardNo;
  card.exMonth = sktList[0];
  card.exYear = '20${sktList[1]}';
  card.cvc = _guvenlikController.text;

  pers.card = card;

  pers.istekTip = 'three_ds_ode';
  pers.isResim = _resimOnay;
  pers.paketId = _paketId;
  pers.videoDur = _videoDur;
  pers.tutar = _fiyat;
  pers.videoid = _videoId;
  pers.day = _days;
  pers.taksitSayisi = _taksitSayisi;

  var json = jsonEncode(pers.toMap());

  channel.sink.add(json);

  channel.stream.listen((data) {
    var musteri = Cafe();
    var jsonobject = jsonDecode(data);
    musteri = Cafe.fromMap(jsonobject);

    if (musteri.status == true) {
      if (musteri.threeDsGelen!.status == 'success') {
        channel.sink.close();
        Navigator.pushNamedAndRemoveUntil(context, '/ThreeDSPage',
            (route) => route.settings.name == '/HomePage',
            arguments: musteri.threeDsGelen!.threeDSHTMLContent);

        return;
      }
      EasyLoading.showToast(
          'BİR HATA OLUŞTU SORUN DEVAM EDERSE BANKANIZ İLE İLETİŞİME GEÇİNİZ',
          duration: const Duration(seconds: 7));
    } else {
      EasyLoading.showToast(
          'BİR HATA OLUŞTU SORUN DEVAM EDERSE BİZİMLE İLETİŞİME GEÇİNİZ',
          duration: const Duration(seconds: 7));
    }
    channel.sink.close();
  });
}

List<String>? _getSkt() {
  String skt = _sKtController.text;
  String sktAyStr = '';
  String sktYilStr = '';
  int? sktAy;
  int? sktYil;
  if (skt.isEmpty) {
    return null;
  }
  if (skt.length > 1) {
    sktAyStr = skt.substring(0, 2);
    sktAy = int.tryParse(sktAyStr);
    if (sktAy == null) {
      EasyLoading.showToast('Kartin son kullanma tarihi hatalı !',
          duration: const Duration(seconds: 7));

      return null;
    }

    if (sktAy > 12) {
      _sKtController.text = '';
      _sKtController.selection = TextSelection.fromPosition(
        TextPosition(offset: _sKtController.text.length),
      );
      EasyLoading.showToast('son kullanma tarihi ay 12 den büyük olamaz !',
          duration: const Duration(seconds: 7));
      return null;
    }
  }

  if (skt.length == 3) {
    if (skt[2] != '/') {
      skt = '$sktAyStr/${skt.substring(2)}';
    }
  }

  if (skt.length > 4) {
    sktYilStr = skt.substring(3, 5);
    sktYil = int.tryParse(sktYilStr);

    if (sktYil == null) {
      EasyLoading.showToast('son kullanma tarihinde rakam kullanın!',
          duration: const Duration(seconds: 7));
      _sKtController.text = '';
      _sKtController.selection = TextSelection.fromPosition(
        TextPosition(offset: _sKtController.text.length),
      );
      return null;
    }
  }
  if (skt.length > 4) {
    skt = '$sktAyStr/$sktYilStr';
    bool ok = _dateController(skt);

    if (!ok) {
      EasyLoading.showToast('Kartin son kullanma tarihi geçmiş !',
          duration: const Duration(seconds: 7));
      _sKtController.text = '';
      _sKtController.selection = TextSelection.fromPosition(
        TextPosition(offset: _sKtController.text.length),
      );
      return null;
    }
  }
  List<String> sktList = [sktAyStr, sktYilStr];
  return sktList;
}

String _textToCard() {
  if (_creditCardController.text.length == 18) {
    return _creditCardController.text.substring(0, 4) +
        _creditCardController.text.substring(5, 9) +
        _creditCardController.text.substring(10, 14) +
        _creditCardController.text.substring(15, 18);
  }
  return _creditCardController.text.substring(0, 4) +
      _creditCardController.text.substring(5, 9) +
      _creditCardController.text.substring(10, 14) +
      _creditCardController.text.substring(15, 19);
}

class GuvenliOdemeText extends StatelessWidget {
  const GuvenliOdemeText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: _height / 60),
      child: Center(
        child: Text('Güvenli ödeme yöntemi',
            style: TextStyle(
                color: Colors.black.withOpacity(0.6), fontSize: _width / 36)),
      ),
    );
  }
}

class _IyzicoLogo extends StatelessWidget {
  const _IyzicoLogo();

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      margin: EdgeInsets.only(top: _height / 20),
      width: _width,
      height: _height / 13,
      decoration: const BoxDecoration(
          image: DecorationImage(
        image: AssetImage("assets/images/iyzico-logo.png"),
        fit: BoxFit.contain,
      )),
    );
  }
}
