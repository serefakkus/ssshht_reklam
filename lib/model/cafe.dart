import 'dart:typed_data';

class Cafe {
  Cafe({
    this.id,
    this.istekTip,
    this.status,
    this.tokens,
    this.phone,
    this.bakiye,
    this.cafeid,
    this.cafelist,
    this.day,
    this.name,
    this.surName,
    this.pass,
    this.usertip,
    this.video,
    this.videoid,
    this.videomongo,
    this.videoname,
    this.arsiv,
    this.kimlik,
    this.not,
    this.offset,
    this.paketId,
    this.paketList,
    this.sehir,
    this.url,
    this.videoDur,
    this.videoTip,
    this.adres,
    this.il,
    this.ilce,
    this.vergiDairesi,
    this.videoCount,
    this.ulke,
    this.isResim,
    this.mail,
    this.tckn,
    this.unvan,
    this.vergiNo,
    this.isKurumsal,
    this.binNumber,
    this.taksit,
    this.tutar,
    this.card,
    this.threeDsGelen,
  });

  int? offset;
  int? paketId;
  int? videoDur;
  String? videoTip;
  String? kimlik;
  String? not;
  String? url;
  List<String>? day;
  List<String>? sehir;
  List<HesapArsiv>? arsiv;
  List<Paket>? paketList;
  int? id;
  String? istekTip;
  bool? status;
  Tokens? tokens;
  Phone? phone;
  int? cafeid;
  String? name;
  String? surName;
  String? pass;
  int? usertip;
  double? bakiye;
  String? videoid;
  String? videoname;
  Uint8List? video;
  List<Video>? videomongo;
  List<CafeInfo>? cafelist;
  String? adres;
  String? vergiDairesi;
  String? il;
  String? ilce;
  int? videoCount;
  String? mail;
  bool? isResim;
  String? tckn;
  String? ulke;
  String? unvan;
  String? vergiNo;
  bool? isKurumsal;
  String? binNumber;
  List<Taksit>? taksit;
  double? tutar;
  CreditCard? card;
  ThreeDsGelen? threeDsGelen;

  Cafe.fromMap(Map<String, dynamic> json) {
    tutar = double.parse(json["tutar"].toString());
    binNumber = json["bin_number"];
    isKurumsal = json["is_kurumsal"];
    isResim = json["is_resim"];
    mail = json["mail"];
    videoCount = json["video_count"];
    adres = json["adres"];
    vergiDairesi = json["vergi_dairesi"];
    il = json["il"];
    ilce = json["ilce"];
    offset = json["offset"];
    paketId = json["paket_id"];
    videoDur = json["video_dur"];
    videoTip = json["video_tip"];
    kimlik = json["kimlik"];
    not = json["not"];
    url = json["url"];
    tckn = json["tckn"];
    ulke = json["ulke"];
    unvan = json["unvan"];
    vergiNo = json["vergi_no"];
    if (json["day"] != null) {
      day = (json["day"] as List<dynamic>).cast<String>();
    }
    if (json["sehir"] != null) {
      sehir = (json["sehir"] as List<dynamic>).cast<String>();
    }

    if (json['arsiv'] != null) {
      arsiv = <HesapArsiv>[];
      json['arsiv'].forEach((v) {
        arsiv!.add(HesapArsiv.fromMap(v));
      });
    }

    if (json['paket_list'] != null) {
      paketList = <Paket>[];
      json['paket_list'].forEach((v) {
        paketList!.add(Paket.fromMap(v));
      });
    }

    id = json["id"];
    istekTip = json["istek_tip"];
    status = json["status"];
    phone = Phone.fromMap(json["phone"]);
    if (json["token"] != null) {
      tokens = Tokens.fromJson(json["token"]);
    }

    if (json["video"] != null) {}

    cafeid = json["cafe_id"];
    name = json["name"];
    surName = json["surname"];
    pass = json["pass"];
    usertip = json["user_tip"];
    bakiye = double.parse(json["bakiye"].toString());
    videoid = json["video_id"];
    videoname = json["video_name"];
    if (json['video_mongo'] != null) {
      videomongo = <Video>[];
      json['video_mongo'].forEach((v) {
        videomongo!.add(Video.fromJson(v));
      });
    }
    if (json['cafe_list'] != null) {
      cafelist = <CafeInfo>[];
      json['cafe_list'].forEach((v) {
        cafelist!.add(CafeInfo.fromJson(v));
      });
    }

    if (json['taksitler'] != null) {
      taksit = <Taksit>[];
      json['taksitler'].forEach((v) {
        taksit!.add(Taksit.fromMap(v));
      });
    }

    if (json["card"] != null) {
      card = CreditCard.fromJson(json["card"]);
    }

    if (json["three_ds"] != null) {
      threeDsGelen = ThreeDsGelen.fromJson(json["three_ds"]);
    }
  }

  Map<String, dynamic> toMap() => {
        "tutar": tutar,
        "bin_number": binNumber,
        "is_kurumsal": isKurumsal,
        "is_resim": isResim,
        "mail": mail,
        "video_count": videoCount,
        "adres": adres,
        "vergi_dairesi": vergiDairesi,
        "il": il,
        "ilce": ilce,
        "offset": offset,
        "paket_id": paketId,
        "video_dur": videoDur,
        "video_tip": videoTip,
        "kimlik": kimlik,
        "not": not,
        "url": url,
        "day": day,
        "sehir": sehir,
        "arsiv": arsiv,
        "paket_list": paketList,
        "phone": phone?.toMap(),
        "id": id,
        "istek_tip": istekTip,
        "status": status,
        "token": tokens?.toJson(),
        "video": video,
        "cafe_id": cafeid,
        "name": name,
        "surname": surName,
        "pass": pass,
        "user_tip": usertip,
        "bakiye": bakiye,
        "video_id": videoid,
        "video_name": videoname,
        "video_mongo": videomongo,
        "cafe_list": cafelist,
        "tckn": tckn,
        "ulke": ulke,
        "unvan": unvan,
        "vergi_no": vergiNo,
        "taksitler": taksit,
        "card": card,
        "three_ds": threeDsGelen,
      };
}

class Tokens {
  int? id;
  int? userType;
  bool? ok;
  TokenDetails? tokenDetails;
  String? auth;
  int? istekId;
  int? istekType;

  Tokens({
    this.id,
    this.userType,
    this.ok,
    this.tokenDetails,
    this.auth,
    this.istekId,
    this.istekType,
  });

  Tokens.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userType = json['user_type'];
    ok = json['ok'];
    tokenDetails = json['token_details'] != null
        ? TokenDetails.fromJson(json['token_details'])
        : null;
    auth = json['auth'];
    istekId = json['istek_id'];
    istekType = json['istek_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_type'] = userType;
    data['ok'] = ok;
    if (tokenDetails != null) {
      data['token_details'] = tokenDetails!.toJson();
    }
    data['auth'] = auth;
    data['istek_id'] = istekId;
    data['istek_type'] = istekType;
    return data;
  }
}

class TokenDetails {
  String? accessToken;
  String? refreshToken;
  String? accessUuid;
  String? refreshUuid;
  int? atExpires;
  int? rtExpires;

  TokenDetails(
      {this.accessToken,
      this.refreshToken,
      this.accessUuid,
      this.refreshUuid,
      this.atExpires,
      this.rtExpires});

  TokenDetails.fromJson(Map<String, dynamic> json) {
    accessToken = json['access_token'];
    refreshToken = json['refresh_token'];
    accessUuid = json['access_uuid'];
    refreshUuid = json['refresh_uuid'];
    atExpires = json['at_expires'];
    rtExpires = json['rt_expires'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['access_token'] = accessToken;
    data['refresh_token'] = refreshToken;
    data['access_uuid'] = accessUuid;
    data['refresh_uuid'] = refreshUuid;
    data['at_expires'] = atExpires;
    data['rt_expires'] = rtExpires;
    return data;
  }
}

class Phone {
  Phone({
    this.istekTip,
    this.status,
    this.id,
    this.userId,
    this.userType,
    this.ok,
    this.no,
    this.code,
    this.rawTime,
    this.time,
  });

  String? istekTip;
  bool? status;
  int? id;
  int? userId;
  int? userType;
  bool? ok;
  String? no;
  String? code;
  dynamic rawTime;
  DateTime? time;

  factory Phone.fromMap(Map<String, dynamic> json) => Phone(
        istekTip: json["istek_tip"],
        status: json["status"],
        id: json["id"],
        userId: json["user_id"],
        userType: json["user_type"],
        ok: json["ok"],
        no: json["no"],
        code: json["code"],
        rawTime: json["raw_time"],
        time: DateTime.parse(json["time"]),
      );

  Map<String, dynamic> toMap() => {
        "istek_tip": istekTip,
        "status": status,
        "id": id,
        "user_id": userId,
        "user_type": userType,
        "ok": ok,
        "no": no,
        "code": code,
        "raw_time": rawTime,
        "time": time?.toIso8601String(),
      };
}

class Video {
  Video({
    this.videoId,
    this.videoName,
    this.duration,
    this.not,
    this.personelId,
    this.url,
    this.verify,
    this.waiting,
  });

  String? videoId;
  String? videoName;
  bool? waiting;
  bool? verify;
  int? duration;
  String? not;
  int? personelId;
  String? url;

  factory Video.fromJson(Map<String, dynamic> json) => Video(
        videoId: json["video_id"],
        videoName: json["video_name"],
        waiting: json["waiting"],
        verify: json["verify"],
        duration: json["duration"],
        not: json["not"],
        personelId: json["personel_id"],
        url: json["url"],
      );

  Map<String, dynamic> toJson() => {
        "video_id": videoId,
        "video_name": videoName,
        "waiting": waiting,
        "verify": verify,
        "duration": duration,
        "not": not,
        "personel_id": personelId,
        "url": url,
      };
}

class CafeInfo {
  CafeInfo({
    this.id,
    this.locX,
    this.locY,
    this.name,
  });
  int? id;
  String? name;
  double? locX;
  double? locY;

  factory CafeInfo.fromJson(Map<String, dynamic> json) => CafeInfo(
        id: json["id"],
        name: json["name"],
        locX: double.parse(json["loc_x"].toString()),
        locY: double.parse(json["loc_y"].toString()),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "loc_y": locY,
        "loc_x": locX,
        "name": name,
      };
}

class Paket {
  Paket({
    this.id,
    this.aylikTarih,
    this.cafeId,
    this.fiyat,
    this.gunlukTarih,
    this.haftalikTarih,
    this.info,
    this.masa,
    this.name,
    this.sehir,
    this.day,
    this.adet,
    this.goruntuleme,
  });
  int? id;
  int? day;
  String? name;
  int? masa;
  List<String>? gunlukTarih;
  List<String>? haftalikTarih;
  List<String>? aylikTarih;
  double? fiyat;
  String? info;
  List<int>? cafeId;
  String? sehir;
  int? adet;
  int? goruntuleme;

  Paket.fromMap(Map<String, dynamic> json) {
    adet = json["adet"];
    goruntuleme = json["goruntuleme"];
    day = json["day"];
    id = json["id"];
    name = json["name"];
    masa = json["masa"];
    if (json["gunluk_tarih"] != null) {
      gunlukTarih = (json["gunluk_tarih"] as List<dynamic>).cast<String>();
    }
    if (json["haftalik_tarih"] != null) {
      haftalikTarih = (json["haftalik_tarih"] as List<dynamic>).cast<String>();
    }
    if (json["aylik_tarih"] != null) {
      aylikTarih = (json["aylik_tarih"] as List<dynamic>).cast<String>();
    }
    fiyat = double.parse(json["fiyat"].toString());
    info = json["info"];
    if (json["cafe_id"] != null) {
      cafeId = (json["cafe_id"] as List<dynamic>).cast<int>();
    }
    sehir = json["sehir"];
  }

  Map<String, dynamic> toMap() => {
        "goruntuleme": goruntuleme,
        "adet": adet,
        "day": day,
        "id": id,
        "name": name,
        "masa": masa,
        "gunluk_tarih": gunlukTarih,
        "haftalik_tarih": haftalikTarih,
        "aylik_tarih": aylikTarih,
        "fiyat": fiyat,
        "info": info,
        "cafe_id": cafeId,
        "sehir": sehir,
      };
}

class HesapArsiv {
  HesapArsiv({
    this.personelId,
    this.bakiyeDegisim,
    this.cafeName,
    this.kalanBakiye,
    this.paketName,
    this.reklamTarih,
    this.tip,
    this.videoId,
  });

  int? personelId;
  double? bakiyeDegisim;
  double? kalanBakiye;
  String? videoId;
  List<String>? reklamTarih;
  List<String>? cafeName;
  String? paketName;
  String? tip;

  HesapArsiv.fromMap(Map<String, dynamic> json) {
    personelId = json["personel_id"];
    bakiyeDegisim = double.parse(json["bakiye_degisim"].toString());
    kalanBakiye = double.parse(json["kalan_bakiye"].toString());
    json["kalan_bakiye"];
    videoId = json["video_id"];
    if (json["reklam_tarih"] != null) {
      reklamTarih = (json["reklam_tarih"] as List<dynamic>).cast<String>();
    }

    if (json["cafe_name"] != null) {
      cafeName = (json["cafe_name"] as List<dynamic>).cast<String>();
    }

    paketName = json["paket_name"];
    tip = json["tip"];
  }

  Map<String, dynamic> toMap() => {
        "personel_id": personelId,
        "bakiye_degisim": bakiyeDegisim,
        "kalan_bakiye": kalanBakiye,
        "video_id": videoId,
        "reklam_tarih": reklamTarih,
        "cafe_name": cafeName,
        "paket_name": paketName,
        "tip": tip,
      };
}

class Taksit {
  Taksit({
    this.taksitSayisi,
    this.taksitTutar,
    this.toplamTutar,
  });

  double? taksitTutar;
  double? toplamTutar;
  int? taksitSayisi;

  Taksit.fromMap(Map<String, dynamic> json) {
    taksitSayisi = json["taksit_sayisi"];
    toplamTutar = double.parse(json["toplam_tutar"].toString());
    taksitTutar = double.parse(json["taksit_tutar"].toString());
  }

  Map<String, dynamic> toMap() => {
        "taksit_sayisi": taksitSayisi,
        "toplam_tutar": toplamTutar,
        "taksit_tutar": taksitTutar,
      };
}

class CreditCard {
  String? cardHolderName;
  String? cardNumber;
  String? exMonth;
  String? exYear;
  String? cvc;

  CreditCard({
    this.cardHolderName,
    this.cardNumber,
    this.exMonth,
    this.exYear,
    this.cvc,
  });

  CreditCard.fromJson(Map<String, dynamic> json) {
    cardHolderName = json['card_holder_name'];
    cardNumber = json['card_number'];
    exMonth = json['expire_month'];
    exYear = json['expire_year'];
    cvc = json['cvc'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['card_holder_name'] = cardHolderName;
    data['card_number'] = cardNumber;
    data['expire_month'] = exMonth;
    data['expire_year'] = exYear;
    data['cvc'] = cvc;
    return data;
  }
}

class ThreeDsGelen {
  String? status;
  String? threeDSHTMLContent;

  ThreeDsGelen({
    this.status,
    this.threeDSHTMLContent,
  });

  ThreeDsGelen.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    threeDSHTMLContent = json['threeDSHtmlContent'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['threeDSHtmlContent'] = threeDSHTMLContent;
    return data;
  }
}
