import 'package:yemek_siparis_uygulamasi/data/entity/sepet_yemekler.dart';

class SepetYemeklerCevap{
  List<SepetYemekler> sepetYemekler;
  int success;

  // Kurucu metod (constructor), sınıfın örneklerini oluştururken kullanılacak başlangıç değerlerini alır
  SepetYemeklerCevap({required this.sepetYemekler, required this.success});

  factory SepetYemeklerCevap.fromJson(Map<String,dynamic>json){
    int success = json["success"] as int;
    var jsonArray = json["sepet_yemekler"] as List;
    //JSON array'deki her öğeyi SepetYemekler sınıfına dönüştürüp listeye ekler
    List<SepetYemekler> sepetYemekler = jsonArray.map((jsonArrayNesnesi) => SepetYemekler.fromJson(jsonArrayNesnesi)).toList();
    // SepetYemeklerCevap sınıfının örneğini oluşturup geri döndürür
    return SepetYemeklerCevap(sepetYemekler: sepetYemekler, success: success);
  }
}