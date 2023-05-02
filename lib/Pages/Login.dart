import 'package:flutter/material.dart';
import 'package:lina_driver/Pages/Home.dart';
import 'package:lina_driver/services/UserApi.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:quickalert/quickalert.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _emailcontroller = TextEditingController();
  final _passwordcontroller = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  bool isPasswordValid = true;
  String email = "";
  String mdp = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(children: [
          SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 2,
              child: Image.asset("assets/images/3339154.jpg")),
          SizedBox(
            height: MediaQuery.of(context).size.height / 20,
          ),
          const Text("Lina Driver Login ",
              textAlign: TextAlign.start,
              style: TextStyle(
                  fontSize: 27, fontFamily: "Oswald", letterSpacing: 1.5)),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Form(
              key: _formkey,
              child: Column(children: [
                TextFormField(
                  onChanged: (value) {
                    setState(() {
                      email = value;
                    });
                  },
                  autocorrect: true,
                  controller: _emailcontroller,
                  validator: (val) =>
                      val!.isEmpty ? "Merci de saisir votre Email " : null,
                  decoration: const InputDecoration(
                    label: Text("Email "),
                    hintText: "Exemple@gmail.com",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 30,
                ),
                GestureDetector(
                  onDoubleTap: () {
                    setState(() {
                      isPasswordValid = !isPasswordValid;
                    });
                  },
                  child: TextFormField(
                    onChanged: (value) {
                      setState(() {
                        mdp = value;
                      });
                    },
                    autocorrect: true,
                    obscureText: isPasswordValid,
                    controller: _passwordcontroller,
                    validator: (val) =>
                        val!.isEmpty ? "Merci de saisir votre Password " : null,
                    decoration: const InputDecoration(
                      label: Text("Password"),
                      hintText: "*********",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 30,
                ),
                GestureDetector(
                  onTap: () async {
                    if (_formkey.currentState!.validate()) {
                      var user = await UserApi().loginDriver(email, mdp);
                      debugPrint(email);
                      debugPrint(mdp);
                      if (user == false) {
                        showAleart();
                      } else {
                        SharedPreferences pref =
                            await SharedPreferences.getInstance();
                        pref.setBool("isLogin", user);

                        // ignore: use_build_context_synchronously
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const HomePage()));
                      }
                    }
                  },
                  child: Container(
                    height: MediaQuery.of(context).size.height / 15,
                    width: MediaQuery.of(context).size.width - 60,
                    decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 17, 64, 255),
                        borderRadius: BorderRadius.all(Radius.circular(12))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.lock,
                          color: Colors.white,
                          size: 20,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Connexion",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        )
                      ],
                    ),
                  ),
                )
              ]),
            ),
          ),
        ]),
      ),
    );
  }

  void showAleart() {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.error,
      text: "Invalide email or Mot de passe !",
    );
  }
}
