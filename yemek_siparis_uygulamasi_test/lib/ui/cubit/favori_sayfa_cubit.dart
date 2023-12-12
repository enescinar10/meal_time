import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yemek_siparis_uygulamasi/data/entity/yemekler.dart';

class FavoriSayfaCubit extends Cubit<List<Yemekler>> {
  FavoriSayfaCubit() : super([]);

  /*List<Yemekler> favoriYemekler = [];

  void favoriyeEkle(Yemekler yemek) {
    if (!favoriYemekler.contains(yemek)) {
      favoriYemekler.add(yemek);
      emit(List.from(favoriYemekler));
    }
  }

  void favoridenCikar(Yemekler yemek) {
    if (favoriYemekler.contains(yemek)) {
      favoriYemekler.remove(yemek);
      emit(List.from(favoriYemekler));
    }
  }*/

  //Verilen Yemekler öğesini favorilere ekler. Eğer öğe zaten favorilerde değilse, state listesine ekler ve durumu güncelleyerek yeniden çizim yapılmasını sağlar.
  void favoriyeEkle(Yemekler yemek) {
    if (!state.contains(yemek)) {
      emit(List.from(state)..add(yemek));
    }
  }

  // Verilen Yemekler öğesini favorilerden çıkarır. Eğer öğe favorilerde ise, state listesinden kaldırır ve durumu güncelleyerek yeniden çizim yapılmasını sağlar.
  void favoridenCikar(Yemekler yemek) {
    if (state.contains(yemek)) {
      emit(List.from(state)..remove(yemek));
    }
  }

  //Verilen Yemekler öğesinin favori olup olmadığını kontrol eder. Eğer state listesinde bulunuyorsa true, aksi takdirde false döndürür.
  bool isFavori(Yemekler yemek) {
    return state.contains(yemek);
  }


}