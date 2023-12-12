import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yemek_siparis_uygulamasi/ui/cubit/anasayfa_cubit.dart';
import 'package:yemek_siparis_uygulamasi/ui/cubit/detay_sayfa_cubit.dart';
import 'package:yemek_siparis_uygulamasi/ui/cubit/favori_sayfa_cubit.dart';
import 'package:yemek_siparis_uygulamasi/ui/cubit/sepet_sayfa_cubit.dart';
import 'package:yemek_siparis_uygulamasi/ui/views/anasayfa.dart';
import 'package:yemek_siparis_uygulamasi/ui/views/login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) =>AnasayfaCubit()),
        BlocProvider(create: (context) =>DetaySayfaCubit()),
        BlocProvider(create: (context) =>SepetSayfaCubit()),
        BlocProvider(create: (context) =>FavoriSayfaCubit()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
        ),
        home: const LoginPage(),
      ),
    );
  }
}

