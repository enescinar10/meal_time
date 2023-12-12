import 'package:flutter/material.dart';
import 'package:yemek_siparis_uygulamasi/colors.dart';
import 'package:yemek_siparis_uygulamasi/ui/views/anasayfa.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late Color myColor;
  late Size mediaSize;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool rememberUser = false;

  @override
  Widget build(BuildContext context) {
    //Tema Rengi
    myColor = Theme.of(context).primaryColor;
    //Ekran Boyutu
    mediaSize = MediaQuery.of(context).size;

    //Arka plan resmi ve Container oluşturdum.
    return Container(
      decoration: BoxDecoration(
        color: renk2,
        image: DecorationImage(
          image: const AssetImage("resimler/bg.png"),
          fit: BoxFit.cover,
          colorFilter:
          ColorFilter.mode(myColor.withOpacity(0.2), BlendMode.dstATop),
        ),
      ),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        body: Stack(children: [
          Positioned(top: 80, child: _buildTop()),
          Positioned(bottom: 0, child: _buildBottom()),
        ]),
      ),
    );
  }

  //sayfanın üst kısmını oluşturan bir method
  Widget _buildTop() {
    return SizedBox(
      width: mediaSize.width,
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.home,
            size: 100,
            color: Colors.white,
          ),
          Text(
            "Anasayfaya Git",
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 40,
                letterSpacing: 2),
          )
        ],
      ),
    );
  }
//burası sayfanın alt kısmını oluşturuyor
  Widget _buildBottom() {
    return SizedBox(
      width: mediaSize.width,
      child: Card(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            )),
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: _buildForm(),
        ),
      ),
    );
  }
//formu burda oluşturuyoruz.
  Widget _buildForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Hoşgeldiniz",
          style: TextStyle(
              color: renk4, fontSize: 32, fontWeight: FontWeight.w500),
        ),
        _buildGreyText("Lütfen Giriş Bilgilerinizi Giriniz"),
        const SizedBox(height: 60),
        _buildGreyText("Kullanıcı Adı"),
        _buildInputField(emailController),
        const SizedBox(height: 40),
        _buildGreyText("Şifre"),
        _buildInputField(passwordController, isPassword: true),
        const SizedBox(height: 20),
        _buildRememberForgot(),
        const SizedBox(height: 20),
        _buildLoginButton(),
        const SizedBox(height: 20),
        _buildOtherLogin(),
      ],
    );
  }

  Widget _buildGreyText(String text) {
    return Text(
      text,
      style: const TextStyle(color: Colors.grey),
    );
  }
//Giriş bilgileri için input alanı
  Widget _buildInputField(TextEditingController controller,
      {isPassword = false}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        suffixIcon: isPassword ? Icon(Icons.remove_red_eye) : Icon(Icons.done),
      ),
      obscureText: isPassword,
    );
  }

  //beni hatırla ve şifre kısımları
  Widget _buildRememberForgot() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Checkbox(
                value: rememberUser,
                onChanged: (value) {
                  setState(() {
                    rememberUser = value!;
                  });
                }),
            _buildGreyText("Beni Hatırla"),
          ],
        ),
        TextButton(
            onPressed: () {}, child: _buildGreyText("Şifremi Unuttum"))
      ],
    );
  }

  //Giriş butonu bu fonksiyonda oluşuyor
  Widget _buildLoginButton() {
    return ElevatedButton(
      onPressed: () {
        String enteredEmail = emailController.text;
        String enteredPassword = passwordController.text;

        // Kullanıcı adı ve şifre kontrolü
        if (enteredEmail == "enes" && enteredPassword == "1234") {
          // Başarılı giriş
          debugPrint("Giriş başarılı");
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const Anasayfa()),
          );
        } else {
          // Hatalı giriş, Snackbar göster
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Hatalı kullanıcı adı veya şifre'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      style: ElevatedButton.styleFrom(
        shape: const StadiumBorder(),
        elevation: 20,
        shadowColor: myColor,
        minimumSize: const Size.fromHeight(60),
        backgroundColor: Colors.white,
      ),
      child: const Text("GİRİŞ YAP",style: TextStyle(color: renk4,fontWeight: FontWeight.bold,fontSize: 16),),
    );
  }
 // diğer giriş seçenekleri
  Widget _buildOtherLogin() {
    return Center(
      child: Column(
        children: [
          _buildGreyText("Giriş Yapma Seçenekleri"),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Tab(icon: Image.asset("resimler/facebook.png")),
              Tab(icon: Image.asset("resimler/twitter.png")),
              Tab(icon: Image.asset("resimler/github.png")),
            ],
          )
        ],
      ),
    );
  }
}