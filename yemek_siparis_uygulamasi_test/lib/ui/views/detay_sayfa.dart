import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yemek_siparis_uygulamasi/colors.dart';
import 'package:yemek_siparis_uygulamasi/data/entity/yemekler.dart';
import 'package:yemek_siparis_uygulamasi/ui/cubit/detay_sayfa_cubit.dart';
import 'package:yemek_siparis_uygulamasi/ui/views/sepet_sayfa.dart';
class DetaySayfa extends StatefulWidget {
  Yemekler yemek;

  DetaySayfa({required this.yemek});

  @override
  State<DetaySayfa> createState() => _DetaySayfaState();
}

class _DetaySayfaState extends State<DetaySayfa> {
  int adet = 1; // Adeti buradan almalısınız
  String kullaniciAdi = "enes";


  @override
  void initState() {
    super.initState();
    var yemek = widget.yemek;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.white),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors:[Colors.black,Colors.black,Colors.black] ,begin: Alignment.topLeft,end: Alignment.topRight),
          ),
        ),
        title: const Text("Ürün Detayları",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.white),).animate().fade(duration: 500.ms).scale(delay: 200.ms),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 50.0 , right: 50.0),
          child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container( decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Colors.white, Colors.white,Colors.white],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(color: Colors.black12, width: 2.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 4), // Sağa 0 birim, aşağı 4 birim
                  ),
                ],
              ),
                  child: Image.network("http://kasimadalan.pe.hu/yemekler/resimler/${widget.yemek.yemek_resim_adi}")),
              Text(widget.yemek.yemek_adi,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),).animate().fade(duration: 700.ms).scale(delay: 100.ms),
              Text("₺${widget.yemek.yemek_fiyat}",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 22),).animate().fade(duration: 700.ms).scale(delay: 100.ms),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  Container(decoration: BoxDecoration(
                    color: Colors.red, // Sarı arka plan rengi
                    borderRadius: BorderRadius.circular(8.0), // Kenar yuvarlaklığı
                  ),
                    height: 38,
                    width: 45,
                    child: IconButton(
                      onPressed: () {
                        setState(() {
                          if (adet > 1) {
                            adet = adet - 1;
                          }
                        });
                      },
                      icon: Icon(Icons.remove,color: Colors.white,),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5,bottom: 5,left: 5,right: 5),
                    child: Container(decoration: BoxDecoration(
                      color: Colors.black, // Sarı arka plan rengi
                      borderRadius: BorderRadius.circular(8.0), // Kenar yuvarlaklığı
                    ),
                        height: 38,
                        width: 45,
                        alignment: Alignment.center,
                        child: Text(adet.toString(),style: TextStyle(color: Colors.white),)),
                  ),
                  Container(decoration: BoxDecoration(
                    color: Colors.green, // Sarı arka plan rengi
                    borderRadius: BorderRadius.circular(8.0), // Kenar yuvarlaklığı
                  ),
                    height: 38,
                    width: 45,
                    child: IconButton(
                      onPressed: () {
                        setState(() {
                          adet = adet + 1;
                        });
                      },
                      icon: Icon(Icons.add,color: Colors.white,),
                    ),
                  ),
                ],
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(width: 200,
                    child:  ElevatedButton(
                      onPressed: () {
                        context.read<DetaySayfaCubit>().sepeteYemekEkle(
                          widget.yemek.yemek_adi,
                          widget.yemek.yemek_resim_adi,
                          int.parse(widget.yemek.yemek_fiyat),
                          adet,
                          kullaniciAdi,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Sepete ${adet} Adet ${widget.yemek.yemek_adi} Eklendi.'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                        //Navigator.push(context, MaterialPageRoute(builder: (context) => const SepetSayfa()));
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.shopping_cart,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 8), // İkon ile metin arasında bir boşluk
                          Text(
                            "Sepete Ekle",
                            style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepOrange,
                        //primary: Colors.orange, // Buton rengi
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0), // Kenar yuvarlaklığı
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12.0), // Yükseklik ayarı
                        side: const BorderSide(width: 1.0, color: Colors.orange), // Kenar çizgisi
                      ),
                    ),
                  ),
                  Spacer(),
                  Container(
                      width: 70,
                      height: 50,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        color: Colors.white,
                      ),
                      child: Text("${adet * double.parse(widget.yemek.yemek_fiyat)} TL",style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 20,),)),
                ],
              ),
            ],
          ),
        ),
      ),
      backgroundColor: renk5,
    );
  }
}
