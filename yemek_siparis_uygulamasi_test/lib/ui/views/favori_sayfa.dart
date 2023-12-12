import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yemek_siparis_uygulamasi/colors.dart';
import 'package:yemek_siparis_uygulamasi/data/entity/yemekler.dart';
import 'package:yemek_siparis_uygulamasi/ui/cubit/anasayfa_cubit.dart';
import 'package:yemek_siparis_uygulamasi/ui/cubit/favori_sayfa_cubit.dart';
import 'package:yemek_siparis_uygulamasi/ui/views/detay_sayfa.dart';

class FavoriSayfa extends StatefulWidget {
  const FavoriSayfa({super.key});

  @override
  State<FavoriSayfa> createState() => _FavoriSayfaState();
}

class _FavoriSayfaState extends State<FavoriSayfa> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors:[Colors.black,Colors.black,Colors.black] ,begin: Alignment.topLeft,end: Alignment.topRight),
          ),
        ),
        title: const Text("Favoriler",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold)).animate().fade(duration: 500.ms).scale(delay: 200.ms),
      ),
      body: BlocBuilder<FavoriSayfaCubit, List<Yemekler>>(
        builder: (context, favoriYemeklerListesi) {
          if (favoriYemeklerListesi.isNotEmpty) {
            return ListView.builder(
              itemCount: favoriYemeklerListesi.length,
              itemBuilder: (context, indeks) {
                var favoriYemek = favoriYemeklerListesi[indeks];
                return Padding(
                  padding: const EdgeInsets.only(left: 8.0,right: 8,top: 6),
                  child: Container(decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Colors.white, Colors.white,Colors.white],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(color: Colors.black12, width: 2.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5), // Gölge rengi
                        spreadRadius: 2, // Gölgenin yayılma yarıçapı
                        blurRadius: 5, // Gölge bulanıklık yarıçapı
                        offset: Offset(1, 2), // Gölge offseti
                      ),
                    ],
                  ),
                    child: SizedBox(height: 100,
                      child: Center(
                        child: ListTile(
                          leading: Image.network(
                            "http://kasimadalan.pe.hu/yemekler/resimler/${favoriYemek.yemek_resim_adi}",
                            width: 150, // İstenilen genişlik
                            height: 200, // İstenilen yükseklik
                            //fit: BoxFit.cover, // Resmin nasıl boyutlandırılacağını belirler
                          ),
                          title: Text(favoriYemek.yemek_adi,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => DetaySayfa(yemek: favoriYemek))).then((value){
                              context.read<AnasayfaCubit>().yemekleriGetir();
                            });
                          },
                          // Diğer bilgileri ekleyebilirsiniz
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            return Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset("resimler/like3.jpg",fit: BoxFit.cover,width: double.infinity,height: double.infinity,),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 408.0),
                    child: Text("Favoriye Eklenmiş Ürün Yoktur",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 26,color: Colors.white),).animate().fade(duration: 500.ms).scale(delay: 200.ms),
                  ),
                ],
              ),
            );
          }
        },
      ),
      backgroundColor: Colors.white,
    );
  }
  }
