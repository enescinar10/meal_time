import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yemek_siparis_uygulamasi/data/entity/yemekler.dart';
import 'package:yemek_siparis_uygulamasi/data/repo/sepet_yemekler_dao_repository.dart';
import 'package:yemek_siparis_uygulamasi/data/repo/yemekler_dao_repository.dart';

enum OrderBy {
  az,
  zA,
  ascendingPrice,
  descendingPrice,
}
class AnasayfaCubit extends Cubit<List<Yemekler>>{
  AnasayfaCubit():super(<Yemekler>[]);
  var yrepo = YemeklerDaoRepository();
  var srepo = SepetYemeklerDaoRepository();

  OrderBy orderBy = OrderBy.az;

 //Yemek listesini çekmek için kullanılır
  Future <void> yemekleriGetir() async {
    var liste = await yrepo.yemekleriGetir();
    emit(liste);
  }
  //Sepete yeni bir yemek eklemek için kullanılır. srepo adında bir SepetYemeklerDaoRepository örneği kullanılarak sepete yemek eklenir.
  Future<void> sepeteYemekEkleme(String yemek_adi , String yemek_resim_adi , int yemek_fiyat , int yemek_siparis_adet ,String kullanici_adi) async {
    await srepo.sepeteYemekEkle(yemek_adi, yemek_resim_adi, yemek_fiyat, yemek_siparis_adet, kullanici_adi);
  }

  //Yemekleri ismine göre aramak için kullanılır. yrepo kullanılarak asenkron bir şekilde arama yapılır ve durumu güncelleyerek yeniden çizim yapılmasını sağlar.
  Future<void> ara(String aramaKelimesi) async{
    var liste = await yrepo.ara(aramaKelimesi);
    emit(liste);
  }

 //Belirli bir yemek adına göre filtreleme yapar. Eğer arama kelimesi boşsa, tüm yemekleri getirir; doluysa yemek adına göre filtreleme yapar.
  void filtreleYemekAdina(String yemekAdi) {
    if (yemekAdi.isEmpty) {
      // Eğer arama kelimesi boşsa, tüm yemekleri getir
      emit(List.from(state));
    } else {
      // Eğer arama kelimesi doluysa, yemek adına göre filtrele
      emit(List.from(state.where((yemek) =>
          yemek.yemek_adi.toLowerCase().contains(yemekAdi.toLowerCase()))));
    }
  }

  //Verilen sıralama kriterine göre filtreleme yapar. OrderBy enum'u kullanılarak, yemek adına göre A-Z, Z-A, artan fiyat veya azalan fiyat sıralamalarını uygular.
  void filtrelemeYap(OrderBy orderBy) {
    switch (orderBy) {
      case OrderBy.az:
        emit(List.from(state)..sort((a, b) => a.yemek_adi.compareTo(b.yemek_adi)));
        break;
      case OrderBy.zA:
        emit(List.from(state)..sort((a, b) => b.yemek_adi.compareTo(a.yemek_adi)));
        break;
      case OrderBy.ascendingPrice:
        emit(List.from(state)..sort((a, b) => a.yemek_fiyat.compareTo(b.yemek_fiyat)));
        break;
      case OrderBy.descendingPrice:
        emit(List.from(state)..sort((a, b) => b.yemek_fiyat.compareTo(a.yemek_fiyat)));
        break;
    }
  }



}



