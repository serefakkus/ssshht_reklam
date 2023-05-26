import 'dart:convert';

import 'package:flutter/cupertino.dart';
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
TextEditingController _surNamecontroller = TextEditingController();
TextEditingController _adrescontroller = TextEditingController();
TextEditingController _vergiNocontroller = TextEditingController();
TextEditingController _vergiDairecontroller = TextEditingController();
TextEditingController _ilcecontroller = TextEditingController();
TextEditingController _mailcontroller = TextEditingController();
TextEditingController _tckncontroller = TextEditingController();
TextEditingController _ulkecontroleer = TextEditingController();
TextEditingController _unvancontroleer = TextEditingController();

Cafe _cafe = Cafe();
double _fiyat = 0;
bool _isRef = false;
Cafe _fatura = Cafe();
int _videoDur = 0;

bool _isKurumsal = false;
bool _isChanged = false;
bool? _oldIsKurumsal = false;

String _mesafeliSozlesme = '';

List<dynamic> _gelen = [];

bool _isOnay = false;
bool _isRead = false;
bool _isOnay2 = false;
bool _isRead2 = false;
bool _resimOnay = false;
double _paketFiyat = 0;
int _paketId = 0;

String _videoId = '';
String _imageId = '';
List<String>? _days = [];

const double _kItemExtent = 32.0;
String _selectedSehir = 'ŞEHİR SEÇ';
bool _isSelSehir = false;

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
    _isSelSehir = false;
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
    _resimOnay = _gelen[5];
    _paketFiyat = _gelen[6];
    _paketId = _gelen[7];
    _videoId = _gelen[8];
    _imageId = _gelen[9];
    _days = _gelen[10];

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
      _vergiNocontroller.text = _fatura.vergiNo.toString();
      _unvancontroleer.text = _fatura.unvan.toString();
      _tckncontroller.text = _fatura.kimlik.toString();
      _namecontroller.text = _fatura.name.toString();
      _surNamecontroller.text = _fatura.surName.toString();
      _mailcontroller.text = _fatura.mail.toString();
      _selectedSehir = _fatura.il.toString();
      _isSelSehir = true;
      _ilcecontroller.text = _fatura.ilce.toString();
      _adrescontroller.text = _fatura.adres.toString();
      _vergiDairecontroller.text = _fatura.vergiDairesi.toString();
      _oldIsKurumsal = _fatura.isKurumsal;
      if (_fatura.isKurumsal != null) {
        _isKurumsal = _fatura.isKurumsal!;
      }
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
            const Divider(
              color: Colors.black,
              height: 25,
            ),
            // ignore: prefer_const_constructors
            VergiNo(),
            // ignore: prefer_const_constructors
            VergiNoInput(),
            // ignore: prefer_const_constructors
            Unvan(),
            // ignore: prefer_const_constructors
            UnvanInput(),
            const Tckn(),
            const TcknInput(),
            const Name(),
            const NameInput(),
            const SurName(),
            const SurNameInput(),
            const Mail(),
            const MailInput(),
            const Il(),
            const IlInput(),
            const Ilce(),
            const IlceInput(),
            const Adres(),
            const AdresInput(),
            // ignore: prefer_const_constructors
            VergiDairesi(),
            // ignore: prefer_const_constructors
            VergiDairesiInput(),

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
  if (!_isSelSehir) {
    EasyLoading.showToast('LÜTFEN ŞEHİR SEÇİNİZ!');
    return;
  }

  if (!(_tckncontroller.text.isNotEmpty &&
      _namecontroller.text.isNotEmpty &&
      _surNamecontroller.text.isNotEmpty &&
      _mailcontroller.text.isNotEmpty &&
      _ilcecontroller.text.isNotEmpty &&
      _adrescontroller.text.isNotEmpty)) {
    EasyLoading.showToast('LÜTFEN TÜM ALANLARI DOLURUNUZ!');
    return;
  }

  if (_isKurumsal &&
      _vergiNocontroller.text.isNotEmpty &&
      _unvancontroleer.text.isNotEmpty &&
      _vergiDairecontroller.text.isEmpty) {
    EasyLoading.showToast('LÜTFEN TÜM ALANLARI DOLURUNUZ!');
    return;
  }

  if (!_isKimlikTrue(_tckncontroller.text, false)) {
    return;
  }

  if (_isKurumsal) {
    if (!_isKimlikTrue(_vergiNocontroller.text, true)) {
      return;
    }
  }

  if (!_isOnay) {
    EasyLoading.showToast('MESAFELİ SATİŞ SÖZLEŞMESİNİ ONAYLAYINIZ');
    return;
  }

  if (!_isOnay2) {
    EasyLoading.showToast('TESLİMAT VE İADE SÖZLEŞMESİNİ ONAYLAYINIZ');
    return;
  }

  if (_oldIsKurumsal != _isKurumsal) {
    _isChanged = true;
  }

  if (!_isChanged) {
    List<dynamic> giden = [
      _cafe,
      _fiyat,
      _resimOnay,
      _paketFiyat,
      _paketId,
      _videoId,
      _imageId,
      _days,
    ];
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

  pers.isKurumsal = _isKurumsal;
  pers.vergiNo = _vergiNocontroller.text;
  pers.unvan = _unvancontroleer.text;
  pers.kimlik = _tckncontroller.text;
  pers.name = _namecontroller.text;
  pers.surName = _surNamecontroller.text;
  pers.mail = _mailcontroller.text;
  pers.il = _selectedSehir;
  pers.ilce = _ilcecontroller.text;
  pers.adres = _adrescontroller.text;
  pers.vergiDairesi = _vergiDairecontroller.text;

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
      List<dynamic> giden = [
        _cafe,
        _fiyat,
        _resimOnay,
        _paketFiyat,
        _paketId,
        _videoId,
        _imageId,
        _days,
      ];
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

class Tckn extends StatelessWidget {
  const Tckn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: _height / 20),
      //margin: const EdgeInsets.only(top: 180),
      child: Center(
        child: Text(
          'KİMLİK NUMARASI',
          style: GoogleFonts.bungeeShade(
            fontWeight: FontWeight.bold,
            fontSize: _width / 18,
            color: const Color(0xFF212F3C),
          ),
        ),
      ),
    );
  }
}

class TcknInput extends StatelessWidget {
  const TcknInput({Key? key}) : super(key: key);

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
        keyboardType: TextInputType.number,
        onChanged: (value) {
          _isChanged = true;
        },
        controller: _tckncontroller,
        cursorColor: Colors.blue,
        textInputAction: TextInputAction.go,
      ),
    );
  }
}

class VergiNo extends StatefulWidget {
  const VergiNo({Key? key}) : super(key: key);

  @override
  State<VergiNo> createState() => _VergiNoState();
}

class _VergiNoState extends State<VergiNo> {
  @override
  Widget build(BuildContext context) {
    if (!_isKurumsal) {
      return Container();
    }
    return Container(
      margin: EdgeInsets.only(top: _height / 20),
      //margin: const EdgeInsets.only(top: 180),
      child: Column(
        children: [
          Center(
            child: Text(
              'VERGI NUMARASI',
              style: GoogleFonts.bungeeShade(
                fontWeight: FontWeight.bold,
                fontSize: _width / 18,
                color: const Color(0xFF212F3C),
              ),
            ),
          ),
          Center(
            child: Text(
              '(şahış şirketi için kimlik numarası)',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: _width / 20),
            ),
          ),
        ],
      ),
    );
  }
}

class VergiNoInput extends StatefulWidget {
  const VergiNoInput({Key? key}) : super(key: key);

  @override
  State<VergiNoInput> createState() => _VergiNoInputState();
}

class _VergiNoInputState extends State<VergiNoInput> {
  @override
  Widget build(BuildContext context) {
    if (!_isKurumsal) {
      return Container();
    }
    return Container(
      margin: EdgeInsets.only(
          top: (_height / 50), right: (_width / 15), left: (_width / 15)),
      child: TextField(
        decoration: InputDecoration(
            border: const OutlineInputBorder(),
            filled: true,
            fillColor: Colors.blue.shade50),
        keyboardType: TextInputType.number,
        onChanged: (value) {
          _isChanged = true;
        },
        controller: _vergiNocontroller,
        cursorColor: Colors.blue,
        textInputAction: TextInputAction.go,
      ),
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

class Unvan extends StatelessWidget {
  const Unvan({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!_isKurumsal) {
      return Container();
    }
    return Container(
      margin: EdgeInsets.only(top: (_height / 20)),
      child: Text(
        'ŞİRKET ÜNVANI',
        style: GoogleFonts.bungeeShade(
          fontWeight: FontWeight.bold,
          fontSize: _width / 18,
          color: const Color(0xFF212F3C),
        ),
      ),
    );
  }
}

class UnvanInput extends StatelessWidget {
  const UnvanInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!_isKurumsal) {
      return Container();
    }
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
        controller: _unvancontroleer,
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

class SurName extends StatelessWidget {
  const SurName({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: (_height / 20)),
      child: Text(
        'SOYAD',
        style: GoogleFonts.bungeeShade(
          fontWeight: FontWeight.bold,
          fontSize: _width / 18,
          color: const Color(0xFF212F3C),
        ),
      ),
    );
  }
}

class SurNameInput extends StatelessWidget {
  const SurNameInput({Key? key}) : super(key: key);

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
        controller: _surNamecontroller,
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
          controller: _vergiDairecontroller,
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

class Ulke extends StatelessWidget {
  const Ulke({Key? key}) : super(key: key);

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

class UlkeInput extends StatelessWidget {
  const UlkeInput({Key? key}) : super(key: key);

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
          controller: _ulkecontroleer,
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

class IlInput extends StatefulWidget {
  const IlInput({Key? key}) : super(key: key);

  @override
  State<IlInput> createState() => _IlInputState();
}

class _IlInputState extends State<IlInput> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: _height / 30),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey.shade300,
          fixedSize: Size(_width * 0.85, _height / 13),
        ),
        child: Text(
          _selectedSehir,
          style: GoogleFonts.farro(
            fontSize: _width / 14,
            fontWeight: FontWeight.bold,
            color: Colors.blue.shade700,
          ),
        ),
        onPressed: () {
          _showDialog(
              CupertinoPicker(
                magnification: 1.22,
                squeeze: 1.2,
                useMagnifier: true,
                itemExtent: _kItemExtent,
                // This is called when selected item is changed.
                onSelectedItemChanged: (int selectedItem) {
                  setState(() {
                    _selectedSehir = _sehirler[selectedItem];
                    _isSelSehir = true;
                  });
                },
                children: List<Widget>.generate(_sehirler.length, (int index) {
                  return Center(
                    child: Text(
                      _sehirler[index],
                    ),
                  );
                }),
              ),
              context);
        },
      ),
    );
  }
}

void _showDialog(Widget child, BuildContext context) {
  showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Container(
            height: 216,
            padding: const EdgeInsets.only(top: 6.0),
            // The Bottom margin is provided to align the popup above the system navigation bar.
            margin: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            // Provide a background color for the popup.
            color: CupertinoColors.systemBackground.resolveFrom(context),
            // Use a SafeArea widget to avoid system overlaps.
            child: SafeArea(
              top: false,
              child: child,
            ),
          ));
}

class FaturaButon extends StatelessWidget {
  const FaturaButon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: _height / 30,
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
        child: const Text('ONAYLA'),
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
                _isSelSehir)) {
              EasyLoading.showToast('LÜTFEN TÜM ALANLARI DOLURUNUZ!');
              return;
            }
            if (_isKurumsal && _vergiDairecontroller.text.isEmpty) {
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
                _isSelSehir)) {
              EasyLoading.showToast('LÜTFEN TÜM ALANLARI DOLURUNUZ!');
              return;
            }
            if (_isKurumsal && _vergiDairecontroller.text.isEmpty) {
              EasyLoading.showToast('LÜTFEN TÜM ALANLARI DOLURUNUZ!');
              return;
            }

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
                _isSelSehir)) {
              EasyLoading.showToast('LÜTFEN TÜM ALANLARI DOLURUNUZ!');
              return;
            }
            if (_isKurumsal && _vergiDairecontroller.text.isEmpty) {
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
                _isSelSehir)) {
              EasyLoading.showToast('LÜTFEN TÜM ALANLARI DOLURUNUZ!');
              return;
            }
            if (_isKurumsal && _vergiDairecontroller.text.isEmpty) {
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
                _isSelSehir)) {
              EasyLoading.showToast('LÜTFEN TÜM ALANLARI DOLURUNUZ!');
              return;
            }
            if (_isKurumsal && _vergiDairecontroller.text.isEmpty) {
              EasyLoading.showToast('LÜTFEN TÜM ALANLARI DOLURUNUZ!');
              return;
            }

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
                _isSelSehir)) {
              EasyLoading.showToast('LÜTFEN TÜM ALANLARI DOLURUNUZ!');
              return;
            }
            if (_isKurumsal && _vergiDairecontroller.text.isEmpty) {
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

List<String> _sehirler = [
  "Adana",
  "Adıyaman",
  "Afyon",
  "Ağrı",
  "Amasya",
  "Ankara",
  "Antalya",
  "Artvin",
  "Aydın",
  "Balıkesir",
  "Bilecik",
  "Bingöl",
  "Bitlis",
  "Bolu",
  "Burdur",
  "Bursa",
  "Çanakkale",
  "Çankırı",
  "Çorum",
  "Denizli",
  "Diyarbakır",
  "Edirne",
  "Elâzığ",
  "Erzincan",
  "Erzurum",
  "Eskişehir",
  "Gaziantep",
  "Giresun",
  "Gümüşhane",
  "Hakkari",
  "Hatay",
  "Isparta",
  "Mersin",
  "İstanbul",
  "İzmir",
  "Kars",
  "Kastamonu",
  "Kayseri",
  "Kırklareli",
  "Kırşehir",
  "Kocaeli",
  "Konya",
  "Kütahya",
  "Malatya",
  "Manisa",
  "Kahramanmaraş",
  "Mardin",
  "Muğla",
  "Muş",
  "Nevşehir",
  "Niğde",
  "Ordu",
  "Rize",
  "Sakarya",
  "Samsun",
  "Siirt",
  "Sinop",
  "Sivas",
  "Tekirdağ",
  "Tokat",
  "Trabzon",
  "Tunceli",
  "Şanlıurfa",
  "Uşak",
  "Van",
  "Yozgat",
  "Zonguldak",
  "Aksaray",
  "Bayburt",
  "Karaman",
  "Kırıkkale",
  "Batman",
  "Şırnak",
  "Bartın",
  "Ardahan",
  "Iğdır",
  "Yalova",
  "Karabük",
  "Kilis",
  "Osmaniye",
  "Düzce",
];

bool _isKimlikTrue(String? kimlik, bool _isVergi) {
  if (kimlik == null) {
    if (_isVergi) {
      EasyLoading.showToast('VERGİ KİMLİK NUMARSININ BOŞ OLAMAZ!');
      return false;
    }
    EasyLoading.showToast('KİMLİK NUMARSININ BOŞ OLAMAZ!');
    return false;
  }
  if (kimlik.length == 11) {
    if (kimlik[0] == '0') {
      if (_isVergi) {
        EasyLoading.showToast('VERGİ KİMLİK NUMARSININ İLK HANESİ 0 OLAMAZ!');
        return false;
      }
      EasyLoading.showToast('KİMLİK NUMARSININ İLK HANESİ 0 OLAMAZ!');
      return false;
    }

    var tek = int.parse(kimlik[0]) +
        int.parse(kimlik[2]) +
        int.parse(kimlik[4]) +
        int.parse(kimlik[6]) +
        int.parse(kimlik[8]);
    var cift = int.parse(kimlik[1]) +
        int.parse(kimlik[3]) +
        int.parse(kimlik[5]) +
        int.parse(kimlik[7]);

    var t10 = ((tek * 7) - cift) % 10;

    var t11 = ((int.parse(kimlik[0]) +
            int.parse(kimlik[1]) +
            int.parse(kimlik[2]) +
            int.parse(kimlik[3]) +
            int.parse(kimlik[4]) +
            int.parse(kimlik[5]) +
            int.parse(kimlik[6]) +
            int.parse(kimlik[7]) +
            int.parse(kimlik[8]) +
            int.parse(kimlik[9])) %
        10);

    var n10 = int.parse(kimlik[9]);
    var n11 = int.parse(kimlik[10]);

    if ((t10 == n10) && (t11 == n11)) {
      return true;
    } else {
      if (_isVergi) {
        EasyLoading.showToast('VERGİ KİMLİK NUMARSI GEÇERSİZ!');
        return false;
      }
      EasyLoading.showToast('KİMLİK NUMARSI GEÇERSİZ!');
      return false;
    }
  }
  if (_isVergi) {
    if (kimlik.length == 10) {
      return true;
    }
  }
  if (_isVergi) {
    EasyLoading.showToast('VERGİ KİMLİK NUMARSI GEÇERSİZ!');
    return false;
  }
  EasyLoading.showToast('KİMLİK NUMARSI GEÇERSİZ!');
  return false;
}
