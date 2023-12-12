import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart';
import 'package:yemek_siparis_uygulamasi/data/entity/sepet_yemekler.dart';
import 'package:yemek_siparis_uygulamasi/data/repo/sepet_yemekler_dao_repository.dart';
import 'package:yemek_siparis_uygulamasi/ui/cubit/sepet_sayfa_cubit.dart';
class DetaySayfaCubit extends Cubit<void>{
  DetaySayfaCubit():super(0);

  var srepo = SepetYemeklerDaoRepository();

  Future<void> sepeteYemekEkle (String yemek_adi , String yemek_resim_adi , int yemek_fiyat , int yemek_siparis_adet ,String kullanici_adi) async{
    await srepo.sepeteYemekEkle(yemek_adi, yemek_resim_adi, yemek_fiyat, yemek_siparis_adet, kullanici_adi);
  }

}