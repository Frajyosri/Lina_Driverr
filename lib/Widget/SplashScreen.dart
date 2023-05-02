// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:lina_driver/Pages/Home.dart';
import 'package:lina_driver/Pages/Login.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: camel_case_types
class Splash_Screen extends StatefulWidget {
  const Splash_Screen({super.key});

  @override
  State<Splash_Screen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<Splash_Screen> {
  late bool isActive = false;
  @override
  void initState() {
    super.initState();
    getcurentStat();

    late Widget _screen = const HomePage();
    if (isActive) {
      _screen = const HomePage();
    } else {
      _screen = const Login();
    }
    Future.delayed(const Duration(seconds: 5)).then((value) =>
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (context) => _screen)));
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ignore: sized_box_for_whitespace
            Container(
              height: size.height / 2,
              width: size.width,
              child: LottieBuilder.asset("assets/animation/delivary.json"),
            ),
            const SizedBox(),
            const Center(
              child: Text(
                "Lina Driver ",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: "DynaPuff",
                    color: Color.fromARGB(255, 11, 63, 251),
                    fontSize: 32),
              ),
            )
          ],
        ),
      ),
    );
  }

  void getcurentStat() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var islogin = pref.getBool("isLogin");
    setState(() {
      isActive = islogin!;
      debugPrint("$isActive");
    });
  }
}
