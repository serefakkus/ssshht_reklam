import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ssshht_reklam/helpers/database.dart';
import 'package:ssshht_reklam/home/home_page.dart';
import 'package:ssshht_reklam/login/giris_page.dart';
import 'package:ssshht_reklam/model/cafe.dart';

import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../main.dart';

Size _size = const Size(0, 0);
double _height = 0;
double _width = 0;
TextEditingController _namecontroller = TextEditingController();
TextEditingController _adrescontroller = TextEditingController();
TextEditingController _vergicontroller = TextEditingController();
TextEditingController _ilcontroller = TextEditingController();
TextEditingController _ilcecontroller = TextEditingController();
TextEditingController _mailcontroller = TextEditingController();
Cafe _cafe = Cafe();
double _fiyat = 0;
bool _isRef = false;
Cafe _fatura = Cafe();
int _videoDur = 0;

bool _isKurumsal = false;
bool _isChanged = false;

String _mesafeliSozlesme = '';

List<dynamic> _gelen = [];

bool _isOnay = false;
bool _isRead = false;
bool _isOnay2 = false;
bool _isRead2 = false;

class FaturaPage extends StatefulWidget {
  const FaturaPage({Key? key}) : super(key: key);

  @override
  State<FaturaPage> createState() => _FaturaPageState();
}

class _FaturaPageState extends State<FaturaPage> {
  @override
  void initState() {
    getTextS(_setS);
    _isChanged = false;
    _isOnay = false;
    _isOnay2 = false;
    _isRead = false;
    _isRead2 = false;
    // ignore: todo
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _gelen = ModalRoute.of(context)!.settings.arguments as List<dynamic>;
    _cafe = _gelen[0];
    _fiyat = _gelen[1];
    _fatura = _gelen[2];
    _isRef = _gelen[3];
    _videoDur = _gelen[4];

    return Scaffold(
      backgroundColor: backGroundColor,
      body: const Kayit(),
    );
  }

  _setS() {
    setState(() {});
  }
}

class Kayit extends StatefulWidget {
  const Kayit({Key? key}) : super(key: key);

  @override
  State<Kayit> createState() => _KayitState();
}

class _KayitState extends State<Kayit> {
  @override
  void initState() {
    if (!_isRef) {
      if (_fatura.name != null) {
        _namecontroller.text = _fatura.name!;
      }
    }

    if (_isRef) {
      _namecontroller.text = _fatura.name.toString();
      _adrescontroller.text = _fatura.adres.toString();
      _vergicontroller.text = _fatura.vergiDairesi.toString();
      _ilcecontroller.text = _fatura.ilce.toString();
      _ilcontroller.text = _fatura.il.toString();
      _mailcontroller.text = _fatura.mail.toString();
    }

    // ignore: todo
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.of(context).size;
    _height = _size.height;
    _width = _size.width;
    return ListView(
      children: [
        Column(
          children: [
            const Logo(),
            Container(
              margin: EdgeInsets.only(top: _height / 20),
              child: Text(
                'Fatura bilgileri',
                style: GoogleFonts.bungeeShade(
                  fontWeight: FontWeight.bold,
                  fontSize: _width / 18,
                  color: const Color(0xFF212F3C),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: _height / 30),
              child: Row(
                children: [_kurumsalButon(), _bireyselButon()],
              ),
            ),

            const Kimlik(),
            const Divider(
              color: Colors.black,
              height: 25,
            ),
            const Name(),
            const NameInput(),
            const Mail(),
            const MailInput(),
            const Adres(),
            const AdresInput(),
            // ignore: prefer_const_constructors
            VergiDairesi(),
            // ignore: prefer_const_constructors
            VergiDairesiInput(),
            const Il(),
            const IlInput(),
            const Ilce(),
            const IlceInput(),
            const _MesafeliSatis(),
            const FaturaButon(),
          ],
        ),
      ],
    );
  }

  _kurumsalButon() {
    return Container(
      margin: EdgeInsets.only(left: _width / 15, right: _width / 40),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: _color(!_isKurumsal),
          fixedSize: Size((_width * 0.4), (_height / 15)),
        ),
        child: const Text(
          'KURUMSAL',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        onPressed: () {
          _isKurumsal = true;
          setState(() {});
        },
      ),
    );
  }

  _bireyselButon() {
    return Container(
      margin: EdgeInsets.only(left: _width / 40, right: _width / 20),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: _color(_isKurumsal),
          fixedSize: Size((_width * 0.4), (_height / 15)),
        ),
        child: const Text(
          'BİREYSEL',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        onPressed: () {
          _isKurumsal = false;
          setState(() {});
        },
      ),
    );
  }
}

_color(bool ok) {
  if (ok) {
    return Colors.white;
  }
  return Colors.indigoAccent;
}

_sendCode(BuildContext context) async {
  if (!(_namecontroller.text.isNotEmpty &&
      _adrescontroller.text.isNotEmpty &&
      _ilcecontroller.text.isNotEmpty &&
      _ilcontroller.text.isNotEmpty)) {
    EasyLoading.showToast('LÜTFEN TÜM ALANLARI DOLURUNUZ!');
    return;
  }
  if (_isKurumsal && _vergicontroller.text.isEmpty) {
    EasyLoading.showToast('LÜTFEN TÜM ALANLARI DOLURUNUZ!');
    return;
  }
  if (!_isOnay) {
    EasyLoading.showToast('MESAFELİ SATİŞ SÖZLEŞMESİNİ ONAYLAYINIZ');
    return;
  }
  if (!_isOnay2) {
    EasyLoading.showToast('TESLİMAT VE İADE SÖZLEŞMESİNİ ONAYLAYINIZ');
    return;
  }
  if (!_isChanged) {
    List<dynamic> giden = [_cafe, _fiyat, _cafe];
    Navigator.pushNamedAndRemoveUntil(context, '/CreditCardPage',
        (route) => route.settings.name == '/HomePage',
        arguments: giden);
    _isChanged = false;
    return;
  }
  WebSocketChannel channel = IOWebSocketChannel.connect(url);
  Cafe pers = Cafe();
  var tok = await getToken(context);
  Tokens tokens = Tokens();
  tokens.tokenDetails = tok;
  pers.tokens = tokens;

  pers.kimlik = _fatura.kimlik;
  pers.name = _namecontroller.text;
  pers.adres = _adrescontroller.text;
  pers.vergiDairesi = _vergicontroller.text;
  pers.ilce = _ilcecontroller.text;
  pers.il = _ilcontroller.text;
  pers.mail = _mailcontroller.text;

  if (_isRef) {
    pers.istekTip = 'fatura_bilgi_ref';
  } else {
    pers.istekTip = 'fatura_bilgi_new';
  }

  var json = jsonEncode(pers.toMap());

  channel.sink.add(json);

  channel.stream.listen((data) {
    var musteri = Cafe();
    var jsonobject = jsonDecode(data);
    musteri = Cafe.fromMap(jsonobject);

    if (musteri.status == true) {
      List<dynamic> giden = [_cafe, _fiyat, musteri];
      Navigator.pushNamedAndRemoveUntil(context, '/CreditCardPage',
          (route) => route.settings.name == '/HomePage',
          arguments: giden);
    } else {
      EasyLoading.showToast(
          'BİR HATA OLUŞTU SORUN DEVAM EDERSE BİZİMLE İLETİŞİME GEÇİNİZ');
    }
    channel.sink.close();
  });
}

class Kimlik extends StatelessWidget {
  const Kimlik({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (_fatura.kimlik?.length == 11) {
      return Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: (_height / 20)),
            child: Text(
              "KİMLİK NUMARASI",
              style: GoogleFonts.bungeeShade(
                fontWeight: FontWeight.bold,
                fontSize: _width / 18,
                color: const Color(0xFF212F3C),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(
                top: _height / 40, left: _width / 5, right: _width / 5),
            child: Card(
              color: Colors.white.withOpacity(0),
              child: SizedBox(
                height: _height / 20,
                child: Center(
                  child: Text(
                    _fatura.kimlik.toString(),
                    style: GoogleFonts.farro(
                        fontSize: _width / 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    }
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(top: (_height / 20)),
          child: Text(
            "VERGİ NUMARASI",
            style: GoogleFonts.bungeeShade(
              fontWeight: FontWeight.bold,
              fontSize: _width / 18,
              color: const Color(0xFF212F3C),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(
              top: _height / 40, left: _width / 5, right: _width / 5),
          child: Card(
            color: Colors.white.withOpacity(0),
            child: SizedBox(
              height: _height / 20,
              child: Center(
                child: Text(
                  _fatura.kimlik.toString(),
                  style: GoogleFonts.farro(
                      fontSize: _width / 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class Mail extends StatelessWidget {
  const Mail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: (_height / 20)),
      child: Text(
        'MAİL ADRESİ',
        style: GoogleFonts.bungeeShade(
          fontWeight: FontWeight.bold,
          fontSize: _width / 18,
          color: const Color(0xFF212F3C),
        ),
      ),
    );
  }
}

class MailInput extends StatelessWidget {
  const MailInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          top: (_height / 50), right: (_width / 15), left: (_width / 15)),
      child: TextField(
        decoration: InputDecoration(
            border: const OutlineInputBorder(),
            filled: true,
            fillColor: Colors.blue.shade50),
        keyboardType: TextInputType.emailAddress,
        onChanged: (value) {
          _isChanged = true;
        },
        controller: _mailcontroller,
        cursorColor: Colors.blue,
        textInputAction: TextInputAction.go,
      ),
    );
  }
}

class Name extends StatelessWidget {
  const Name({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: (_height / 20)),
      child: Text(
        'İSİM',
        style: GoogleFonts.bungeeShade(
          fontWeight: FontWeight.bold,
          fontSize: _width / 18,
          color: const Color(0xFF212F3C),
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
          top: (_height / 50), right: (_width / 15), left: (_width / 15)),
      child: TextField(
        decoration: InputDecoration(
            border: const OutlineInputBorder(),
            filled: true,
            fillColor: Colors.blue.shade50),
        onChanged: (value) {
          _isChanged = true;
        },
        controller: _namecontroller,
        cursorColor: Colors.blue,
        textInputAction: TextInputAction.go,
      ),
    );
  }
}

class Adres extends StatelessWidget {
  const Adres({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: (_height / 20)),
      child: Text(
        'ADRES',
        style: GoogleFonts.bungeeShade(
          fontWeight: FontWeight.bold,
          fontSize: _width / 18,
          color: const Color(0xFF212F3C),
        ),
      ),
    );
  }
}

class AdresInput extends StatelessWidget {
  const AdresInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          top: (_height / 50), right: (_width / 15), left: (_width / 15)),
      child: Padding(
        padding: const EdgeInsets.only(),
        child: TextField(
          maxLines: 4,
          decoration: InputDecoration(
              border: const OutlineInputBorder(),
              filled: true,
              fillColor: Colors.blue.shade50),
          onChanged: (value) {
            _isChanged = true;
          },
          controller: _adrescontroller,
          cursorColor: Colors.blue,
          textInputAction: TextInputAction.go,
        ),
      ),
    );
  }
}

class VergiDairesi extends StatelessWidget {
  const VergiDairesi({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!_isKurumsal) {
      return Container();
    }
    return Container(
      margin: EdgeInsets.only(top: (_height / 20)),
      child: Text(
        'VERGİ DAİRESİ',
        style: GoogleFonts.bungeeShade(
          fontWeight: FontWeight.bold,
          fontSize: _width / 18,
          color: const Color(0xFF212F3C),
        ),
      ),
    );
  }
}

class VergiDairesiInput extends StatelessWidget {
  const VergiDairesiInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!_isKurumsal) {
      return Container();
    }
    return Container(
      margin: EdgeInsets.only(
          top: (_height / 50), right: (_width / 15), left: (_width / 15)),
      child: Padding(
        padding: const EdgeInsets.only(),
        child: TextField(
          decoration: InputDecoration(
              border: const OutlineInputBorder(),
              filled: true,
              fillColor: Colors.blue.shade50),
          onChanged: (value) {
            _isChanged = true;
          },
          controller: _vergicontroller,
          cursorColor: Colors.blue,
          textInputAction: TextInputAction.go,
        ),
      ),
    );
  }
}

class Ilce extends StatelessWidget {
  const Ilce({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: (_height / 20)),
      child: Text(
        'İLÇE',
        style: GoogleFonts.bungeeShade(
          fontWeight: FontWeight.bold,
          fontSize: _width / 18,
          color: const Color(0xFF212F3C),
        ),
      ),
    );
  }
}

class IlceInput extends StatelessWidget {
  const IlceInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          top: (_height / 50), right: (_width / 15), left: (_width / 15)),
      child: Padding(
        padding: const EdgeInsets.only(),
        child: TextField(
          decoration: InputDecoration(
              border: const OutlineInputBorder(),
              filled: true,
              fillColor: Colors.blue.shade50),
          onChanged: (value) {
            _isChanged = true;
          },
          controller: _ilcecontroller,
          cursorColor: Colors.blue,
          textInputAction: TextInputAction.go,
        ),
      ),
    );
  }
}

class Il extends StatelessWidget {
  const Il({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: (_height / 20)),
      child: Text(
        'ŞEHİR',
        style: GoogleFonts.bungeeShade(
          fontWeight: FontWeight.bold,
          fontSize: _width / 18,
          color: const Color(0xFF212F3C),
        ),
      ),
    );
  }
}

class IlInput extends StatelessWidget {
  const IlInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          top: (_height / 50), right: (_width / 15), left: (_width / 15)),
      child: Padding(
        padding: const EdgeInsets.only(),
        child: TextField(
          decoration: InputDecoration(
              border: const OutlineInputBorder(),
              filled: true,
              fillColor: Colors.blue.shade50),
          onChanged: (value) {
            _isChanged = true;
          },
          controller: _ilcontroller,
          cursorColor: Colors.blue,
          textInputAction: TextInputAction.go,
        ),
      ),
    );
  }
}

class FaturaButon extends StatelessWidget {
  const FaturaButon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: _height / 10,
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
        child: const Text('KAYDET'),
        onPressed: () {
          _sendCode(context);
        },
      ),
    );
  }
}

class _MesafeliSatis extends StatefulWidget {
  const _MesafeliSatis({Key? key}) : super(key: key);

  @override
  State<_MesafeliSatis> createState() => __MesafeliSatisState();
}

class __MesafeliSatisState extends State<_MesafeliSatis> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        _Sozlesme(),
        _TeslimatVeIade(),
      ],
    );
  }
}

class _Sozlesme extends StatefulWidget {
  const _Sozlesme({Key? key}) : super(key: key);

  @override
  State<_Sozlesme> createState() => __SozlesmeState();
}

class __SozlesmeState extends State<_Sozlesme> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: _isOnay,
          onChanged: (value) {
            if (!(_namecontroller.text.isNotEmpty &&
                _adrescontroller.text.isNotEmpty &&
                _ilcecontroller.text.isNotEmpty &&
                _ilcontroller.text.isNotEmpty)) {
              EasyLoading.showToast('LÜTFEN TÜM ALANLARI DOLURUNUZ!');
              return;
            }
            if (_isKurumsal && _vergicontroller.text.isEmpty) {
              EasyLoading.showToast('LÜTFEN TÜM ALANLARI DOLURUNUZ!');
              return;
            }
            if (!_isRead) {
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return ListView(
                    children: [
                      Container(
                          margin: EdgeInsets.only(
                            top: _height / 20,
                            left: _width / 20,
                            right: _width / 20,
                          ),
                          child: _SozlesmeText(_setSt)),
                    ],
                  );
                },
              );
              return;
            }
            _isOnay = !_isOnay;
            setState(() {});
          },
        ),
        TextButton(
          onPressed: () {
            if (!(_namecontroller.text.isNotEmpty &&
                _adrescontroller.text.isNotEmpty &&
                _ilcecontroller.text.isNotEmpty &&
                _ilcontroller.text.isNotEmpty)) {
              EasyLoading.showToast('LÜTFEN TÜM ALANLARI DOLURUNUZ!');
              return;
            }
            if (_isKurumsal && _vergicontroller.text.isEmpty) {
              EasyLoading.showToast('LÜTFEN TÜM ALANLARI DOLURUNUZ!');
              return;
            }
            if (!_isRead) {
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return ListView(
                    children: [
                      Container(
                          margin: EdgeInsets.only(
                            top: _height / 20,
                            left: _width / 20,
                            right: _width / 20,
                          ),
                          child: _SozlesmeText(_setSt)),
                    ],
                  );
                },
              );
              return;
            }
            _isOnay = !_isOnay;
            setState(() {});
          },
          child: const Text(
            'Mesafeli satış sözleşmesini onaylıyorum.',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }

  _setSt() {
    setState(() {});
  }
}

class _SozlesmeText extends StatefulWidget {
  const _SozlesmeText(this.resultCallback);
  final void Function() resultCallback;

  @override
  State<_SozlesmeText> createState() => _SozlesmeTextState();
}

class _SozlesmeTextState extends State<_SozlesmeText> {
  @override
  void initState() {
    _getSozlesme();
    // ignore: todo
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _isRead = true;

    return Column(
      children: [
        Text(_mesafeliSozlesme),
        _SozlesmeTamamButon(widget.resultCallback),
      ],
    );
  }

  _getSozlesme() async {
    String mesafe1 = await getFileData('assets/texts/mesafeli_satis1.txt');
    String mesafe2 = await getFileData('assets/texts/mesafeli_satis2.txt');
    String mesafe4 = await getFileData('assets/texts/mesafeli_satis4.txt');
    String mesafe5 = await getFileData('assets/texts/mesafeli_satis5.txt');
    String mesafe6 = await getFileData('assets/texts/mesafeli_satis6.txt');
    double araToplam = _videoDur * _cafe.paketList![0].fiyat!;
    String phoneNo = '';
    if (_cafe.phone != null) {
      phoneNo = _cafe.phone!.no.toString();
    }
    _mesafeliSozlesme =
        '$mesafe1\nAD-SOYAD: ${_namecontroller.text}\nADRES: ${_adrescontroller.text}\n$mesafe2\nAD-SOYAD: ${_namecontroller.text}\nADRES: ${_adrescontroller.text}/n EPOSTA : ${_mailcontroller.text}\n6. SİPARİŞ VEREN KİŞİ BİLGİLERİ\n\nAD-SOYAD: ${_namecontroller.text}\nADRES: ${_adrescontroller.text}/n EPOSTA : ${_mailcontroller.text}$mesafe4\nÜrün Açıklaması\n Adet: $_videoDur\nBirim Fiyati: ${_cafe.paketList![0].fiyat} Tl\nAta Toplam: $araToplam TL\n(KDV DAHİL\n\nÖdeme Şekli ve Planı\nSipariş Tarihi\n${DateTime.now()}\nTeslimat tarihi\n${_cafe.day![0]}\nTeslimat şekli\n Elektronik ortam\n$mesafe5\nAd/Soyad/Unvan\n${_namecontroller.text}\nAdres\n${_adrescontroller.text}\nTelefon\n${phoneNo}Fatura teslim : fatura elektronik ortamdan teslim edilecektir\n$mesafe6';
    setState(() {});
  }
}

class _SozlesmeTamamButon extends StatefulWidget {
  const _SozlesmeTamamButon(this.resultCallback);
  final void Function() resultCallback;

  @override
  State<_SozlesmeTamamButon> createState() => _SozlesmeTamamButonState();
}

class _SozlesmeTamamButonState extends State<_SozlesmeTamamButon> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: _height / 30),
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              elevation: 10,
              fixedSize: Size((_width * 0.25), (_height / 20)),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15))),
          onPressed: () {
            if (!(_namecontroller.text.isNotEmpty &&
                _adrescontroller.text.isNotEmpty &&
                _ilcecontroller.text.isNotEmpty &&
                _ilcontroller.text.isNotEmpty)) {
              EasyLoading.showToast('LÜTFEN TÜM ALANLARI DOLURUNUZ!');
              return;
            }
            if (_isKurumsal && _vergicontroller.text.isEmpty) {
              EasyLoading.showToast('LÜTFEN TÜM ALANLARI DOLURUNUZ!');
              return;
            }
            _isOnay = true;
            Navigator.pop(context);
            widget.resultCallback();
          },
          child: const Text('ONAY')),
    );
  }
}

class _TeslimatVeIade extends StatefulWidget {
  const _TeslimatVeIade({Key? key}) : super(key: key);

  @override
  State<_TeslimatVeIade> createState() => _TeslimatVeIadeState();
}

class _TeslimatVeIadeState extends State<_TeslimatVeIade> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: _isOnay2,
          onChanged: (value) {
            if (!(_namecontroller.text.isNotEmpty &&
                _adrescontroller.text.isNotEmpty &&
                _ilcecontroller.text.isNotEmpty &&
                _ilcontroller.text.isNotEmpty)) {
              EasyLoading.showToast('LÜTFEN TÜM ALANLARI DOLURUNUZ!');
              return;
            }
            if (_isKurumsal && _vergicontroller.text.isEmpty) {
              EasyLoading.showToast('LÜTFEN TÜM ALANLARI DOLURUNUZ!');
              return;
            }
            if (!_isRead2) {
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return ListView(
                    children: [
                      Container(
                          margin: EdgeInsets.only(
                            top: _height / 20,
                            left: _width / 20,
                            right: _width / 20,
                          ),
                          child: _TeslimatVeIadeText(_setSt)),
                    ],
                  );
                },
              );
              return;
            }
            _isOnay2 = !_isOnay2;
            setState(() {});
          },
        ),
        TextButton(
          onPressed: () {
            if (!(_namecontroller.text.isNotEmpty &&
                _adrescontroller.text.isNotEmpty &&
                _ilcecontroller.text.isNotEmpty &&
                _ilcontroller.text.isNotEmpty)) {
              EasyLoading.showToast('LÜTFEN TÜM ALANLARI DOLURUNUZ!');
              return;
            }
            if (_isKurumsal && _vergicontroller.text.isEmpty) {
              EasyLoading.showToast('LÜTFEN TÜM ALANLARI DOLURUNUZ!');
              return;
            }
            if (!_isRead2) {
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return ListView(
                    children: [
                      Container(
                          margin: EdgeInsets.only(
                            top: _height / 20,
                            left: _width / 20,
                            right: _width / 20,
                          ),
                          child: _TeslimatVeIadeText(_setSt)),
                    ],
                  );
                },
              );
              return;
            }
            _isOnay2 = !_isOnay2;
            setState(() {});
          },
          child: const Text(
            'Teslimat ve iade sözleşmesini onaylıyorum.',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }

  _setSt() {
    setState(() {});
  }
}

class _TeslimatVeIadeText extends StatefulWidget {
  const _TeslimatVeIadeText(this.resultCallback);
  final void Function() resultCallback;

  @override
  State<_TeslimatVeIadeText> createState() => _TeslimatVeIadeTextState();
}

class _TeslimatVeIadeTextState extends State<_TeslimatVeIadeText> {
  @override
  Widget build(BuildContext context) {
    _isRead2 = true;
    return Column(
      children: [
        Text(teslimatIadeText),
        _TeslimatVeIadeTamamButon(widget.resultCallback),
      ],
    );
  }
}

class _TeslimatVeIadeTamamButon extends StatefulWidget {
  const _TeslimatVeIadeTamamButon(this.resultCallback);
  final void Function() resultCallback;

  @override
  State<_TeslimatVeIadeTamamButon> createState() =>
      _TeslimatVeIadeTamamButonState();
}

class _TeslimatVeIadeTamamButonState extends State<_TeslimatVeIadeTamamButon> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: _height / 30),
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              elevation: 10,
              fixedSize: Size((_width * 0.25), (_height / 20)),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15))),
          onPressed: () {
            if (!(_namecontroller.text.isNotEmpty &&
                _adrescontroller.text.isNotEmpty &&
                _ilcecontroller.text.isNotEmpty &&
                _ilcontroller.text.isNotEmpty)) {
              EasyLoading.showToast('LÜTFEN TÜM ALANLARI DOLURUNUZ!');
              return;
            }
            if (_isKurumsal && _vergicontroller.text.isEmpty) {
              EasyLoading.showToast('LÜTFEN TÜM ALANLARI DOLURUNUZ!');
              return;
            }
            _isOnay2 = true;
            Navigator.pop(context);
            widget.resultCallback();
          },
          child: const Text('ONAY')),
    );
  }
}
