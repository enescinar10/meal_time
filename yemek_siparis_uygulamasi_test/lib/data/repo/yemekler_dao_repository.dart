import 'dart:convert';

import 'package:yemek_siparis_uygulamasi/data/entity/sepet_yemekler.dart';
import 'package:yemek_siparis_uygulamasi/data/entity/sepet_yemekler_cevap.dart';
import 'package:yemek_siparis_uygulamasi/data/entity/yemekler.dart';
import 'package:dio/dio.dart';
import 'package:yemek_siparis_uygulamasi/data/entity/yemekler_cevap.dart';

class YemeklerDaoRepository{


  //parseYemeklerCevap(String cevap): JSON formatındaki bir yanıtı alır ve
  // YemeklerCevap sınıfına dönüştürerek içindeki yemekler listesini döndürür.
  // YemeklerCevap sınıfı, gelen JSON yanıtını işlemek için kullanılır.
  List<Yemekler> parseYemeklerCevap(String cevap){
    return YemeklerCevap.fromJson(json.decode(cevap)).yemekler; // veri okuma
  }

// Uzak bir API'den tüm yemekleri getirmek için bir HTTP GET isteği gönderir.
// Gelen cevabı işlemek için parseYemeklerCevap fonksiyonunu kullanarak bir liste döndürür.
  Future<List<Yemekler>> yemekleriGetir() async {
    var url = "http://kasimadalan.pe.hu/yemekler/tumYemekleriGetir.php";
    var cevap = await Dio().get(url);
    return parseYemeklerCevap(cevap.data.toString());
  }
//Belirtilen arama kelimesiyle birlikte uzak bir API'ye bir HTTP POST isteği gönderir.
// Bu istek, yemek_adi alanındaki yemekleri aramak için kullanılır.
// Gelen cevabı işlemek için parseYemeklerCevap fonksiyonunu kullanarak bir liste döndürür.
  Future<List<Yemekler>> ara(String aramaKelimesi) async {
    var url = "http://kasimadalan.pe.hu/yemekler/tumYemekleriGetir.php";
    var veri = {"yemek_adi": aramaKelimesi};
    var cevap = await Dio().post(url, data: FormData.fromMap(veri));
    return parseYemeklerCevap(cevap.data.toString());
  }


}