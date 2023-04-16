import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ssshht_reklam/home/fiyat_sor/f%C4%B1yat_sor_paket_sor_page.dart';
import 'package:ssshht_reklam/home/fatura_page.dart';
import 'package:ssshht_reklam/home/fiyat_sor/fiyat_sor_page.dart';
import 'package:ssshht_reklam/home/fiyat_sor/fiyat_sor_gun_sor_page.dart';
import 'package:ssshht_reklam/home/fiyat_sor/fiyat_sor_sehir_sor_page.dart';
import 'package:ssshht_reklam/home/fiyat_sor/fiyat_sor_sonuc_page.dart';
import 'package:ssshht_reklam/home/gun_sor_page.dart';
import 'package:ssshht_reklam/home/kredit_card_page.dart';
import 'package:ssshht_reklam/home/rejected_video_page.dart';
import 'package:ssshht_reklam/login/kayit_page.dart';
import 'package:ssshht_reklam/login/kod_giris_page.dart';

import 'home/cafe_sor_page.dart';
import 'home/home_page.dart';
import 'home/musteri_page.dart';
import 'home/new_video_page.dart';
import 'home/paket_sor_page.dart';
import 'home/reklam_ver_page.dart';
import 'home/sehir_sor_page.dart';
import 'home/video_detay_page.dart';
import 'home/video_sor_page.dart';
import 'login/first_page.dart';
import 'login/giris_page.dart';
import 'login/login_new_pass_page.dart';
import 'login/ref_token_page.dart';
import 'login/welcome_page.dart';
import 'login/yeni_sifre_page.dart';

class RouteGenerator {
  static Route<dynamic>? _rotaOlustur(Widget hedef, RouteSettings settings) {
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return CupertinoPageRoute(
          settings: settings, builder: (context) => hedef);
    } else {
      return MaterialPageRoute(settings: settings, builder: (context) => hedef);
    }
  }

  static Route<dynamic>? routeGenerator(RouteSettings settings) {
    switch (settings.name) {
      case '/FirstPage':
        return _rotaOlustur(const FirstPage(), settings);

      case '/GirisPage':
        return _rotaOlustur(const GirisPage(), settings);

      case '/RefTokenPage':
        return _rotaOlustur(const RefTokenPage(), settings);

      case '/HomePage':
        return _rotaOlustur(const HomePage(), settings);

      case '/MusteriPage':
        return _rotaOlustur(const MusteriPage(), settings);

      case '/NewVideoPage':
        return _rotaOlustur(const NewVideoPage(), settings);

      case '/VideoSorPage':
        return _rotaOlustur(const VideoSorPage(), settings);

      case '/VideoDetayPage':
        return _rotaOlustur(const VideoDetayPage(), settings);

      case '/CafeSorPage':
        return _rotaOlustur(const CafeSorPage(), settings);

      case '/ReklamVerPage':
        return _rotaOlustur(const ReklamVerPage(), settings);

      case '/WelcomePage':
        return _rotaOlustur(const WelcomePage(), settings);

      case '/NewPassPage':
        return _rotaOlustur(const NewLoginPage(), settings);

      case '/RefPassPage':
        return _rotaOlustur(const NewPassLoginPage(), settings);

      case '/KayitPage':
        return _rotaOlustur(const KayitPage(), settings);

      case '/KodGirisPage':
        return _rotaOlustur(const KodGirisPage(), settings);

      case '/RejectedVideoPage':
        return _rotaOlustur(const RejectedVideoPage(), settings);

      case '/SehirSorPage':
        return _rotaOlustur(const SehirSorPage(), settings);

      case '/PaketSorPage':
        return _rotaOlustur(const PaketSorPage(), settings);

      case '/CreditCardPage':
        return _rotaOlustur(const CreditCardPage(), settings);

      case '/FaturaPage':
        return _rotaOlustur(const FaturaPage(), settings);

      case '/GunSorPage':
        return _rotaOlustur(const GunSorPage(), settings);

      case '/FiyatHesaplaPage':
        return _rotaOlustur(const FiyatSorPage(), settings);

      case '/SehirSorFiyatPage':
        return _rotaOlustur(const FiyatSorSehirSorPage(), settings);

      case '/GunSorFiyatPage':
        return _rotaOlustur(const FiyatSorGunSorPage(), settings);

      case '/PaketSorFiyatPage':
        return _rotaOlustur(const FiyatSorPaketSorPage(), settings);

      case '/FiyatSorSonucPage':
        return _rotaOlustur(const FiyatSorSonucPage(), settings);

      default:
        return (MaterialPageRoute(
          builder: (context) => const Scaffold(
            body: Center(
              child: Text('Bir Hata Oluştu Bos sayfa'),
            ),
          ),
        ));
    }
  }
}
