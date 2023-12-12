import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yemek_siparis_uygulamasi/colors.dart';
import 'package:yemek_siparis_uygulamasi/data/entity/yemekler.dart';
import 'package:yemek_siparis_uygulamasi/ui/cubit/anasayfa_cubit.dart';
import 'package:yemek_siparis_uygulamasi/ui/cubit/detay_sayfa_cubit.dart';
import 'package:yemek_siparis_uygulamasi/ui/cubit/favori_sayfa_cubit.dart';
import 'package:yemek_siparis_uygulamasi/ui/views/detay_sayfa.dart';
import 'package:yemek_siparis_uygulamasi/ui/views/favori_sayfa.dart';
import 'package:yemek_siparis_uygulamasi/ui/views/sepet_sayfa.dart';

class Anasayfa extends StatefulWidget{
  const Anasayfa({super.key});

  @override
  State<Anasayfa> createState() => _AnasayfaState();
}

class _AnasayfaState extends State<Anasayfa> {
  int _selectedIndex = 0;
  bool aramaYapiliyorMu = false;
  int adet = 1;
  String kullaniciAdi = "enes";
  bool isFavori = false;


  void initState() {
    super.initState();
    // AnasayfaCubit sınıfından bir nesne oluşturarak yemekleri getirme işlemini başlat
    context.read<AnasayfaCubit>().yemekleriGetir(); // bu çalıştığı anda arayüze veriler gelecek
  }

  // BottomNavigationBar için sayfa geçişlerini yöneten fonksiyon
  final List<Widget> _widgetOptions = [
    Anasayfa(),
    //FavoriSayfa(),
    //SepetSayfa(),
  ];

  void _onItemTapped(int index) {
    if (index != _selectedIndex) {
      switch (index) {
        case 1:
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => FavoriSayfa()),
          ).then((value) {
            // Geri dönüldüğünde yapılacak işlemler
          });
          break;
        case 2:
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SepetSayfa()),
          ).then((value) {
            // Geri dönüldüğünde yapılacak işlemler
          });
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 55,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors:[Colors.black,Colors.black,Colors.black] ,begin: Alignment.topLeft,end: Alignment.topRight),
          ),
        ),
        //backgroundColor: Colors.red,
        title: AnimatedSwitcher(
          duration: Duration(milliseconds: 1500),
          child: aramaYapiliyorMu ?
          TextField(
            style: TextStyle(color: Colors.white),
            decoration: const InputDecoration(hintText: "Ara",hintStyle: TextStyle(color: Colors.white)),
            onChanged: (aramaKelimesi){
              // Arama kutusundaki değer değiştikçe filtreleme yap
              context.read<AnasayfaCubit>().filtreleYemekAdina(aramaKelimesi);
            },
          ) :
              //Arama yapılmıyorsa logo göster
           Padding(
            padding:  EdgeInsets.only(left: 60.0,bottom: 0),
            child:  SizedBox(width:350,height:200,child: Image.asset("resimler/logo3.png",alignment: Alignment.center,)),
          ),
        ),
        actions: [
          aramaYapiliyorMu ?
          IconButton(onPressed: (){
            setState(() {
              aramaYapiliyorMu = false;
            });
            context.read<AnasayfaCubit>().yemekleriGetir();
          }, icon: Icon(Icons.clear),color: Colors.white,):
          IconButton(onPressed: (){
            setState(() {
              aramaYapiliyorMu = true;
            });
            // Arama tamamlandığında tüm yemekleri getir
          }, icon: Icon(Icons.search),color: Colors.white),
          PopupMenuButton<OrderBy>(
            icon: Icon(Icons.filter_alt_outlined,color: Colors.white,),
            onSelected: (OrderBy result) {
              // Seçilen filtreleme özelliğine göre cubit sınıfındaki fonksiyonu çağır
              context.read<AnasayfaCubit>().filtrelemeYap(result);
            },
            color: renk3,

            itemBuilder: (BuildContext context) => <PopupMenuEntry<OrderBy>>[
              const PopupMenuItem<OrderBy>(
                value: OrderBy.az,
                child: Text('A-Z',style: TextStyle(color: Colors.white),),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem<OrderBy>(
                value: OrderBy.zA,
                child: Text('Z-A',style: TextStyle(color: Colors.white),),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem<OrderBy>(
                value: OrderBy.ascendingPrice,
                child: Text('Artan Fiyat',style: TextStyle(color: Colors.white),),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem<OrderBy>(
                value: OrderBy.descendingPrice,
                child: Text('Azalan Fiyat',style: TextStyle(color: Colors.white),),
              ),
            ],
          ),
        ],
      ),
      body: BlocBuilder<AnasayfaCubit,List<Yemekler>>(
        builder: (context,yemeklerListesi){
          if(yemeklerListesi.isNotEmpty){
            // Yemek listesi boş değilse GridView ile yemekleri listeleyin
            return GridView.builder(
              itemCount: yemeklerListesi!.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1 / 1.5,
              ),
              itemBuilder: (context,indeks){
                var yemek = yemeklerListesi[indeks];
                return GestureDetector(
                  onTap: (){
                    // Yemeğe tıklandığında DetaySayfa'ya git ve geri dönüldüğünde yemekleri güncelle
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> DetaySayfa(yemek: yemek))).then((value) {
                      context.read<AnasayfaCubit>().yemekleriGetir();
                    });
                  },
                  child: Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Colors.white, Colors.white,Colors.white],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(color: Colors.black12, width: 2.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Image.network(
                                  "http://kasimadalan.pe.hu/yemekler/resimler/${yemek.yemek_resim_adi}"),
                              Text(yemek.yemek_adi,style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0,right: 8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(
                                        decoration: BoxDecoration(
                                          color: beyaz, //
                                          borderRadius: BorderRadius.circular(8.0),
                                          border: Border.all(color: Colors.black, width: 1.0),// Kenar yuvarlaklığı
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey.withOpacity(0.5),
                                              spreadRadius: 5,
                                              blurRadius: 7,
                                              offset: const Offset(0, 1),
                                            ),
                                          ],
                                        ),
                                        width: 45,
                                        height: 38,
                                        padding: const EdgeInsets.all(8.0),
                                        margin: const EdgeInsets.all(8.0),
                                        child: Text("₺${yemek.yemek_fiyat}",style: TextStyle(fontSize: 13,color: Colors.black,fontWeight: FontWeight.bold),textAlign: TextAlign.center,)
                                    ),
                                    Spacer(),
                                    Container(decoration: BoxDecoration(
                                      color: Colors.green, // Sarı arka plan rengi
                                      borderRadius: BorderRadius.circular(8.0), // Kenar yuvarlaklığı
                                    ),
                                      height: 38,
                                      width: 45,
                                      child: IconButton(onPressed: (){
                                        // Sepete yemek eklemek için Cubit sınıfındaki fonksiyonu çağır
                                        context.read<AnasayfaCubit>().sepeteYemekEkleme(yemek.yemek_adi, yemek.yemek_resim_adi, int.parse(yemek.yemek_fiyat), adet, kullaniciAdi);
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text('${yemek.yemek_adi} sepete eklendi.'),
                                            duration: Duration(seconds: 1),
                                          ),
                                        );
                                      }, icon: Icon(Icons.add),color: Colors.white,),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Positioned(
                            top: 5,
                            right: 5,
                            child: IconButton(
                              icon: Icon(
                                // Favori durumuna göre kalp ikonunu değiştir
                                context.read<FavoriSayfaCubit>().isFavori(yemek)
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: context.read<FavoriSayfaCubit>().isFavori(yemek)
                                    ? Colors.red
                                    : Colors.black,
                              ),
                              onPressed: () {
                                setState(() {
                                  // Favoriye ekleme veya çıkarma işlemleri
                                  if (context.read<FavoriSayfaCubit>().isFavori(yemek)) {
                                    context.read<FavoriSayfaCubit>().favoridenCikar(yemek);
                                    // Favoriden çıkarma bildirimi
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('${yemek.yemek_adi} favorilerden çıkarıldı.'),
                                        duration: Duration(seconds: 2),
                                      ),
                                    );
                                  } else {
                                    context.read<FavoriSayfaCubit>().favoriyeEkle(yemek);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('${yemek.yemek_adi} favorilere eklendi.'),
                                        duration: Duration(seconds: 2),
                                      ),
                                    );
                                  }
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }else{
            return const Center();
          }
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Ana Sayfa',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favoriler',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Sepet',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: renk4,
        onTap: _onItemTapped,
        backgroundColor: Colors.black,
        unselectedItemColor: Colors.white,
        unselectedIconTheme: IconThemeData(color: Colors.white),
      ),
    );
  }
}


