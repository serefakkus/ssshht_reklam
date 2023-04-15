import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:ssshht_reklam/helpers/database.dart';
import 'package:ssshht_reklam/model/cafe.dart';

import 'package:web_socket_channel/web_socket_channel.dart';

sendDataSignIn(
    BuildContext cnt, dynamic json, WebSocketChannel channel, Cafe mus) {
  channel.sink.add(json);
  channel.stream.listen(
    (data) {
      var jsonobject = jsonDecode(data);

      var musteri = Cafe.fromMap(jsonobject);

      if (musteri.status == true) {
        tokensIntert(musteri.tokens!.tokenDetails!);
        phoneAndPassIntert(mus);
        tokensIntert(musteri.tokens!.tokenDetails!);
        Navigator.pushNamedAndRemoveUntil(
            cnt, '/HomePage', (route) => route.settings.name == '/FirstPage',
            arguments: musteri);
      } else if (musteri.status == false) {
        EasyLoading.showToast('KULLANICI ADI VEYA ŞİFRE YANLIŞ');
      }
      channel.sink.close();
    },
  );
}

sendDataNewSignup(BuildContext cnt, dynamic json, WebSocketChannel channel,
    List<String> codeandphone) {
  channel.sink.add(json);
  channel.stream.listen(
    (data) {
      var jsonobject = jsonDecode(data);

      var musteri = Cafe.fromMap(jsonobject);

      if (musteri.status == true) {
        Navigator.pushNamed(cnt, '/NewPassPage', arguments: codeandphone);
      } else if (musteri.status == false) {
        EasyLoading.showToast('KOD HATALI');
      }
      channel.sink.close();
    },
  );
}

sendDataSignup(
    BuildContext cnt, dynamic json, WebSocketChannel channel, String passwd) {
  channel.sink.add(json);
  channel.stream.listen(
    (data) {
      var jsonobject = jsonDecode(data);

      var musteri = Cafe.fromMap(jsonobject);

      if (musteri.status == true) {
        tokensIntert(musteri.tokens!.tokenDetails!);
        musteri.pass = passwd;
        phoneAndPassIntert(musteri);
        tokensIntert(musteri.tokens!.tokenDetails!);
        Navigator.pushNamedAndRemoveUntil(
            cnt, '/HomePage', (route) => route.settings.name == '/FirstPage',
            arguments: musteri);
      } else if (musteri.status == false) {
        if (musteri.phone?.code == "kimlik var") {
          EasyLoading.showToast('KİMLİK SİSTEMDE KAYITLI');
        } else {
          EasyLoading.showToast('BİR HATA OLUŞTU!');
        }
      }
      channel.sink.close();
    },
  );
}

sendDataNewPassSignup(
    BuildContext cnt, dynamic json, WebSocketChannel channel) {
  channel.sink.add(json);
  channel.stream.listen(
    (data) {
      var jsonobject = jsonDecode(data);

      var musteri = Cafe.fromMap(jsonobject);

      if (musteri.status == true) {
        EasyLoading.showToast('ŞİFRE BAŞARIYLA DEĞİŞTİ');
        Navigator.pushNamedAndRemoveUntil(
            cnt, '/GirisPage', (route) => route.settings.name == '/GirisPage',
            arguments: musteri);
      } else if (musteri.status == false) {
        EasyLoading.showToast('BİR HATA OLUŞTU!');
      }
      channel.sink.close();
    },
  );
}

sendDataRefCode(BuildContext cnt, dynamic json, WebSocketChannel channel,
    List<String> codeandphone) {
  channel.sink.add(json);
  channel.stream.listen(
    (data) {
      var jsonobject = jsonDecode(data);

      var musteri = Cafe.fromMap(jsonobject);

      if (musteri.status == true) {
        Navigator.pushNamed(cnt, '/RefPassPage', arguments: codeandphone);
      } else if (musteri.status == false) {
        EasyLoading.showToast('KOD HATALI');
      }
      channel.sink.close();
    },
  );
}

sendDataRefToken(
    BuildContext cnt, dynamic json, WebSocketChannel channel) async {
  Cafe musteri = Cafe();
  channel.sink.add(json);
  channel.stream.listen(
    (data) {
      var jsonobject = jsonDecode(data);
      musteri = Cafe.fromMap(jsonobject);
      if (musteri.status == true) {
        tokensIntert(musteri.tokens!.tokenDetails!);
        Navigator.pushNamedAndRemoveUntil(
            cnt, '/HomePage', (route) => route.settings.name == '/FirstPage',
            arguments: musteri);
      } else if (musteri.status == false) {
        Navigator.pushNamed(cnt, '/WelcomePage');
      } else {
        Navigator.pushNamed(cnt, '/WelcomePage');
      }
      channel.sink.close();
    },
    onDone: () => {},
  );

  return musteri;
}

sendDataMusteriSor(BuildContext cnt, dynamic json, WebSocketChannel channel) {
  channel.sink.add(json);

  channel.stream.listen(
    (data) {
      var jsonobject = jsonDecode(data);
      var musteri = Cafe.fromMap(jsonobject);
      if (musteri.status == true) {
        Navigator.pushNamed(cnt, '/MusteriPage', arguments: musteri);
      } else if (musteri.status == false) {
        EasyLoading.showToast('KULLANICI BULUNAMADI');
      }
      channel.sink.close();
    },
    onError: (error) => EasyLoading.showToast('BAĞLANTI HATASI'),
    onDone: () => {},
  );
}

sendDataBakiyeSor(dynamic json, WebSocketChannel channel, BuildContext cnt) {
  Cafe musteri = Cafe();
  channel.sink.add(json);
  var toast = '';
  channel.stream.listen(
    (data) {
      var jsonobject = jsonDecode(data);
      musteri = Cafe.fromMap(jsonobject);
      if (musteri.status == false) {
        Navigator.pushNamed(cnt, '/MenuPage');
      } else if (musteri.status == false) {
        toast = 'Tekrar Deneyin yada \n Qrkodun altindaki yaziyi girin';
        Navigator.pushNamed(cnt, '/QrPageFail');
      } else {
        toast = 'Tekrar Deneyin yada \n Qrkodun altindaki yaziyi girin';

        Navigator.pushNamed(cnt, '/QrPageFail');
      }
      if (toast != '') {
        EasyLoading.showToast(toast, duration: const Duration(seconds: 5));
      }
      channel.sink.close();
    },
    onDone: () => {},
  );
}

sendDataToken(dynamic json, WebSocketChannel channel) async {
  channel.sink.add(json);

  channel.stream.listen(
    (data) {
      var jsonobject = jsonDecode(data);
      var musteri = Cafe.fromMap(jsonobject);
      if (musteri.status == true) {
        tokensIntert(musteri.tokens!.tokenDetails!);
      }

      channel.sink.close();
    },
    onDone: () => {},
  );
}

sendDataIsToken(
    dynamic json, WebSocketChannel channel, BuildContext context) async {
  channel.sink.add(json);

  channel.stream.listen(
    (data) {
      var jsonobject = jsonDecode(data);
      var musteri = Cafe.fromMap(jsonobject);
      if (musteri.status == true) {
      } else {
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/GirisPage',
          (route) => route.settings.name == "/WelcomePage",
        );
      }

      channel.sink.close();
    },
    onDone: () => {},
  );
}

sendDataIsOk(dynamic json, WebSocketChannel channel, BuildContext cnt) async {
  Cafe musteri = Cafe();
  channel.sink.add(json);
  channel.stream.listen(
    (data) {
      var jsonobject = jsonDecode(data);
      musteri = Cafe.fromMap(jsonobject);

      if (musteri.status == true) {
        Navigator.pushNamedAndRemoveUntil(
            cnt, '/HomePage', (route) => route.settings.name == '/HomePage',
            arguments: musteri);
      } else if (musteri.status == false) {
        Navigator.pushNamed(cnt, '/GirisPage');
      } else {
        Navigator.pushNamed(cnt, '/GirisPage');
      }

      channel.sink.close();
    },
    onError: (error) => {},
    onDone: () => {},
  );
}

sendDataCode(dynamic json, WebSocketChannel channel, BuildContext context) {
  channel.sink.add(json);

  channel.stream.listen(
    (data) {
      var jsonobject = jsonDecode(data);
      var musteri = Cafe.fromMap(jsonobject);
      if (musteri.status == true) {
        EasyLoading.showToast('KOD GÖNDERİLDİ');
      } else {
        if (musteri.phone?.code == "telefon var") {
          EasyLoading.showToast('TELEFON ZATEN KAYITLI');
        } else {
          EasyLoading.showToast('BİR HATA OLDU');
        }
      }

      channel.sink.close();
    },
    onDone: () => {},
  );
}

sendDataNewMusteri(
    dynamic json, WebSocketChannel channel, BuildContext cnt) async {
  Cafe musteri = Cafe();
  channel.sink.add(json);
  channel.stream.listen(
    (data) {
      var jsonobject = jsonDecode(data);
      musteri = Cafe.fromMap(jsonobject);

      if (musteri.status == true) {
        EasyLoading.showToast('KAYIT BAŞARILI');
        Navigator.pushNamedAndRemoveUntil(
            cnt, '/HomePage', (route) => route.settings.name == '/HomePage',
            arguments: musteri);
      } else if (musteri.status == false) {
        EasyLoading.showToast('KOD HATALI');
      } else {
        EasyLoading.showToast('BİR HATA OLUŞTU');
      }

      channel.sink.close();
    },
    onError: (error) => {},
    onDone: () => {},
  );
}

sendDataBakiyeEkle(
    dynamic json, WebSocketChannel channel, BuildContext cnt) async {
  Cafe musteri = Cafe();
  channel.sink.add(json);
  channel.stream.listen(
    (data) {
      var jsonobject = jsonDecode(data);
      musteri = Cafe.fromMap(jsonobject);

      if (musteri.status == true) {
        EasyLoading.showToast('BAŞARILI');
        Navigator.pushNamedAndRemoveUntil(
            cnt, '/HomePage', (route) => route.settings.name == '/HomePage',
            arguments: musteri);
      } else if (musteri.status == false) {
        EasyLoading.showToast('BAKİYE EKLENEMEDİ');
      } else {
        EasyLoading.showToast('BİR HATA OLUŞTU');
      }

      channel.sink.close();
    },
    onError: (error) => {},
    onDone: () => {},
  );
}
