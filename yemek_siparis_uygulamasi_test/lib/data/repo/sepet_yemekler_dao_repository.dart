import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:yemek_siparis_uygulamasi/data/entity/sepet_yemekler.dart';
import 'package:yemek_siparis_uygulamasi/data/entity/sepet_yemekler_cevap.dart';

class SepetYemeklerDaoRepository{

  //JSON formatındaki bir yanıtı alır, bu yanıtı işleyerek SepetYemeklerCevap sınıfına dönüştürür
  // ve içindeki sepetYemekler listesini döndürür. Bu işlemde hata oluşması durumunda boş bir liste döndürülür.
  List<SepetYemekler> parseSepetYemeklerCevap(String cevap){
    //return SepetYemeklerCevap.fromJson(json.decode(cevap)).sepetYemekler;
    try {
      var decodedJson = json.decode(cevap);
      return SepetYemeklerCevap.fromJson(decodedJson).sepetYemekler;
    } catch (e) {
      print("JSON Ayrıştırma Hatası: $e");
      return [];
    }
  }

  //Belirtilen kullanıcı adına ait sepet içindeki yemekleri getirmek için bir
  // HTTP POST isteği gönderir. Gelen cevabı işlemek için parseSepetYemeklerCevap fonksiyonunu kullanarak bir liste döndürür.
  Future<List<SepetYemekler>> sepetYemekleriGetir(String kullanici_adi) async {
    var url = "http://kasimadalan.pe.hu/yemekler/sepettekiYemekleriGetir.php";
    var veri = {"kullanici_adi" : kullanici_adi};
    var cevap = await Dio().post(url,data: FormData.fromMap(veri));
    return parseSepetYemeklerCevap(cevap.data.toString());
  }

  //Belirtilen bilgilerle bir yemeği sepete eklemek için bir HTTP POST isteği gönderir.
  Future<void> sepeteYemekEkle(String yemek_adi , String yemek_resim_adi , int yemek_fiyat , int yemek_siparis_adet ,String kullanici_adi) async{
    var url = "http://kasimadalan.pe.hu/yemekler/sepeteYemekEkle.php";
    var veri = {"yemek_adi" : yemek_adi ,
      "yemek_resim_adi" :yemek_resim_adi,
      "yemek_fiyat" : yemek_fiyat,
      "yemek_siparis_adet" : yemek_siparis_adet,
      "kullanici_adi" : kullanici_adi
    };
    var cevap = await Dio().post(url,data: FormData.fromMap(veri));
    print("Sepete Yemek Ekle : ${cevap.data.toString()}");
  }

  //Belirtilen kullanıcıya ait sepeti sıfırlamak için sepet içindeki tüm ürünleri sırayla siler.
  Future<void> sepetiSifirla(String kullanici_adi) async {
    var sepetUrunleri = await sepetYemekleriGetir(kullanici_adi);

    for (var sepetUrun in sepetUrunleri) {
      await sepetYemekSil(int.parse(sepetUrun.sepet_yemek_id), kullanici_adi);
    }
  }

  //Belirtilen sepet yemek ID'sine sahip yemeği, belirtilen kullanıcı adına ait sepetten silmek için bir HTTP POST isteği gönderir.
  Future<void> sepetYemekSil(int sepet_yemek_id , String kullanici_adi) async{
    var url = "http://kasimadalan.pe.hu/yemekler/sepettenYemekSil.php";
    var veri = {"sepet_yemek_id" : sepet_yemek_id , "kullanici_adi" : kullanici_adi};
    var cevap = await Dio().post(url,data: FormData.fromMap(veri));
    print("Sepette Silinen Yemek : ${cevap.data.toString()}");
  }
}