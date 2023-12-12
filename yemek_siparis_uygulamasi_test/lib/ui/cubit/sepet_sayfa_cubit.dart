import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yemek_siparis_uygulamasi/data/entity/sepet_yemekler.dart';
import 'package:yemek_siparis_uygulamasi/data/repo/sepet_yemekler_dao_repository.dart';

class SepetSayfaCubit extends Cubit<List<SepetYemekler>>{
  SepetSayfaCubit():super(<SepetYemekler>[]);
  var srepo = SepetYemeklerDaoRepository();
  List<SepetYemekler> _toplamSepet = [];

  //Belirtilen kullanıcı adına ait sepet yemeklerini getirir ve durumu güncelleyerek yeniden çizim yapılmasını sağlar.
  Future<void> sepetYemekleriGetir(String kullanici_adi) async{
    //var liste = await srepo.sepetYemekleriGetir(kullanici_adi);
    //emit(liste);
    _toplamSepet = await sepetYemekleriTopla(kullanici_adi);
    emit(_toplamSepet);
  }


  //Kullanıcıya ait sepet yemeklerini toplar. Eğer aynı isimde bir yemek birden fazla
  // kez eklenmişse, bu yemeklerin adetlerini toplayarak bir listede gösterir. Ayrıca, sepetten silinen yemekleri listeye dahil etmez.
  Future<List<SepetYemekler>> sepetYemekleriTopla(String kullanici_adi) async {
    var liste = await srepo.sepetYemekleriGetir(kullanici_adi);

    // Aynı isimdeki ürünleri topla
    Map<String, SepetYemekler> toplamSepet = {};
    for (var yemek in liste) {
      if (toplamSepet.containsKey(yemek.yemek_adi)) {
        // Aynı isimde ürün varsa adetini topla
        toplamSepet[yemek.yemek_adi]!.yemek_siparis_adet += yemek.yemek_siparis_adet;
      } else {
        // Aynı isimde ürün yoksa ekle
        toplamSepet[yemek.yemek_adi] = yemek;
      }
    }

    // Silinen ürünü listeden çıkar
    toplamSepet.removeWhere((key, value) => value.yemek_siparis_adet == 0);

    return toplamSepet.values.toList();
  }

  // Belirtilen kullanıcı adına ait sepeti sıfırlar, yani tüm sepet yemeklerini kaldırır.
  Future<void> sepetiSifirla(String kullaniciAdi) async {
    await srepo.sepetiSifirla(kullaniciAdi);
    sepetYemekleriGetir(kullaniciAdi);
    emit(<SepetYemekler>[]);
  }

  //Belirtilen sepet yemek ID'sine sahip yemekleri, belirtilen kullanıcı adına ait sepette siler.
  Future<void> sepetYemekSil(int sepet_yemek_id , String kullanici_adi) async {
    await srepo.sepetYemekSil(sepet_yemek_id, kullanici_adi);
    sepetYemekleriGetir(kullanici_adi); // sepeti güncelleyip tekrar sepet verilerini almam lazım
  }

  //Belirtilen sepet yemekleri listesinin toplam adet ve fiyatını hesaplar ve bu değerleri geri döndürür.
  double toplamAdetVeFiyat(List<SepetYemekler> sepetListesi) {
    double toplamFiyat = 0;
    int toplamAdet = 0;

    for (var yemek in sepetListesi) {
      toplamFiyat += yemek.yemek_siparis_adet * double.parse(yemek.yemek_fiyat);
      toplamAdet += yemek.yemek_siparis_adet;
    }
    return toplamFiyat;
  }

}