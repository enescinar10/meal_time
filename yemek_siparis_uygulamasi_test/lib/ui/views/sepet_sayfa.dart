import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yemek_siparis_uygulamasi/colors.dart';
import 'package:yemek_siparis_uygulamasi/data/entity/sepet_yemekler.dart';
import 'package:yemek_siparis_uygulamasi/ui/cubit/sepet_sayfa_cubit.dart';
import 'package:yemek_siparis_uygulamasi/ui/views/anasayfa.dart';
import 'package:lottie/lottie.dart';

class SepetSayfa extends StatefulWidget {
  const SepetSayfa({super.key});

  @override
  State<SepetSayfa> createState() => _SepetSayfaState();
}

class _SepetSayfaState extends State<SepetSayfa> {
  late SepetSayfaCubit sepetSayfaCubit;
  String kullaniciAdi = "enes";
  bool showOrderAnimation = false;

  void initState() {
    super.initState();
    sepetSayfaCubit = context.read<SepetSayfaCubit>();
    sepetSayfaCubit.sepetYemekleriGetir(kullaniciAdi);
    //sepetSayfaCubit.sepetYemekleriTopla(kullaniciAdi);
    //context.read<SepetSayfaCubit>().sepetYemekleriGetir(kullaniciAdi);
    //context.read<SepetSayfaCubit>().sepetYemekleriTopla(kullaniciAdi);// bu çalıştığı anda arayüze veriler gelecek
  }

  @override
  Widget build(BuildContext context) {
    // Sepet yemek listesini dinleyerek, güncel duruma göre arayüzü oluşturur.
    List<SepetYemekler> _sepetYemeklerListesi = context.watch<SepetSayfaCubit>().state;
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors:[Colors.black,Colors.black,Colors.black] ,begin: Alignment.topLeft,end: Alignment.topRight),
          ),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.red,
        title: const Text("Sepet",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),).animate().fade(duration: 500.ms).scale(delay: 200.ms),
        centerTitle: true,
        actions: [
          // Sepeti sıfırla butonu
          IconButton(onPressed: () async{
            await context.read<SepetSayfaCubit>().sepetiSifirla(kullaniciAdi);
            //Navigator.push(context, MaterialPageRoute(builder: (context) => const Anasayfa()));
          }, icon: Icon(Icons.restore_from_trash,color: Colors.white,),),
        ],
      ),
      body: BlocBuilder<SepetSayfaCubit,List<SepetYemekler>>(
        // BlocBuilder ile sepet yemek listesi dinlenir ve güncellendiğinde arayüz güncellenir.
        builder: (context,sepetYemeklerListesi){
          if(sepetYemeklerListesi.isNotEmpty){
            return ListView.builder(
              itemCount: sepetYemeklerListesi.length,
              itemBuilder: (context,indeks){
                var sepetYemek = sepetYemeklerListesi[indeks];
                return Padding(
                  padding: const EdgeInsets.only(left: 10.0,right: 10.0,top: 5),
                  child: Card(
                    elevation: 7,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: SizedBox(height: 100,
                      child: Container(decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Colors.white, Colors.white,Colors.white],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 4), // Sağa 0 birim, aşağı 4 birim
                          ),
                        ],
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(color: Colors.black12, width: 2.0),
                      ),
                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Image.network("http://kasimadalan.pe.hu/yemekler/resimler/${sepetYemek.yemek_resim_adi}"),
                            Expanded(
                              child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(sepetYemek.yemek_adi,textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                                  Text("Fiyat: ${sepetYemek.yemek_fiyat}",textAlign: TextAlign.center,),
                                  Text("Adet:  ${sepetYemek.yemek_siparis_adet}",textAlign: TextAlign.center,),
                                ],
                              ),
                            ),
                            //const Spacer(),
                             IconButton(onPressed: (){
                               // Sepetten ürünü silme işlemi
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(backgroundColor: renk2,
                                  content: Text("${sepetYemek.yemek_adi} silinsin mi ?",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),
                                  action: SnackBarAction(
                                    label: "Evet",
                                    backgroundColor: Colors.white,
                                    textColor: Colors.red,
                                    onPressed: (){
                                      context.read<SepetSayfaCubit>().sepetYemekSil(int.parse(sepetYemek.sepet_yemek_id), kullaniciAdi);
                                    },
                                  ),
                                ),
                              );
                            }, icon: const Icon(Icons.remove,color: Colors.red,)),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }else{
            return  Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset("resimler/sepet.jpeg",fit: BoxFit.cover,width: double.infinity,height: double.infinity,),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 508.0),
                    child: Text("Sepete Ürün Ekleyin",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 34,color: Colors.white),).animate().fade(duration: 500.ms).scale(delay: 200.ms),
                  ),
                ],
              ),
            );
          }
        },
      ),
      backgroundColor: renk3,
      bottomNavigationBar: _sepetYemeklerListesi.length > 0  ? BottomAppBar(
        color: Colors.white,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BlocBuilder<SepetSayfaCubit, List<SepetYemekler>>(
                builder: (context, sepetYemeklerListesi) {
                  double toplamFiyat = context.read<SepetSayfaCubit>().toplamAdetVeFiyat(sepetYemeklerListesi);

                  return Text(
                    "Toplam : ${toplamFiyat.toStringAsFixed(2)} ₺",
                    style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  );
                },
              ),
              Container(
                width: 120,
                child: ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      showOrderAnimation = true;
                    });
                    await context.read<SepetSayfaCubit>().sepetiSifirla(kullaniciAdi);
                    //Navigator.push(context, MaterialPageRoute(builder: (context) => const Anasayfa()));
                  },style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange,
                  //primary: Colors.orange, // Buton rengi
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0), // Kenar yuvarlaklığı
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 8.0), // Yükseklik ayarı
                  side: const BorderSide(width: 1.0, color: Colors.orange), // Kenar çizgisi
                ),
                  child: Text("Sipariş Ver",style: TextStyle(fontSize: 16,color: Colors.white,fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ) : null,
      floatingActionButton: showOrderAnimation
          ? Center(
        child: Lottie.asset(
          "assets/success.json",  // Animasyon dosyanızın adını doğru şekilde belirtin
          width: 500,
          height: 400,
          repeat: false,
          onLoaded: (composition) {
            // Animasyon yüklendiğinde yapılacaklar
            Future.delayed(Duration(seconds: 5), () {
              setState(() {
                showOrderAnimation = false;
              });
            });
          },
        ),
      )
          : null,

    );
  }
}




