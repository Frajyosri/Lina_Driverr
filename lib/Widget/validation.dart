import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Validation extends StatefulWidget {
  const Validation({super.key});

  @override
  State<Validation> createState() => _ValidationState();
}

class _ValidationState extends State<Validation> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 5));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: LottieBuilder.asset("assets/animation/Order.json"),
        ),
        Positioned(
          bottom: MediaQuery.of(context).size.height / 5,
          left: MediaQuery.of(context).size.width / 8.5,
          child: Row(
            children: const [
              Text(
                "Commande Livrer avec sucsses ",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.teal, fontSize: 20),
              ),
              Icon(
                Icons.check,
                size: 25,
                color: Colors.teal,
              )
            ],
          ),
        )
      ]),
    );
  }
}
