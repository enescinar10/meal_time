import 'package:yemek_siparis_uygulamasi/data/entity/yemekler.dart';

class YemeklerCevap{
  List<Yemekler> yemekler;
  int success;

  YemeklerCevap({required this.yemekler, required this.success});

  factory YemeklerCevap.fromJson(Map<String,dynamic>json){
    int success = json["success"] as int;
    var jsonArray = json["yemekler"] as List;
    List<Yemekler> yemekler = jsonArray.map((jsonArrayNesnesi) => Yemekler.fromJson(jsonArrayNesnesi)).toList();
    return YemeklerCevap(yemekler: yemekler, success: success);
  }

  // Bu dosya, bir liste şeklinde gelen yemek verilerini ve bir başarı durumunu temsil eden YemeklerCevap sınıfını içerir.
}