import 'package:flutter/material.dart';
import 'package:lina_driver/Pages/Home.dart';
import 'package:lina_driver/services/UserApi.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      body: SafeArea(
          child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 5,
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20)),
                image: DecorationImage(
                    image: AssetImage("images/loginanimation.png"))),
          ),
          Form(
            key: _formkey,
            child: Column(
              children: [
                TextFormField(
                  autocorrect: true,
                  controller: _emailcontroller,
                  validator: (val) =>
                      val!.isEmpty ? "Merci de saisir votre Email " : null,
                  decoration: const InputDecoration(
                      label: Text("Email "),
                      hintText: "Exemple@gmail.com",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                          borderSide:
                              BorderSide(color: Colors.black, width: 1))),
                ),
                Stack(
                  children: [
                    Row(
                      children: [
                        TextFormField(
                          onChanged: (value) {
                            setState(() {
                              mdp = value;
                            });
                          },
                          autocorrect: true,
                          obscureText: isPasswordValid,
                          controller: _passwordcontroller,
                          validator: (val) => val!.isEmpty
                              ? "Merci de saisir votre Email "
                              : null,
                          decoration: const InputDecoration(
                              label: Text("Password"),
                              hintText: "*********",
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12)),
                                  borderSide: BorderSide(
                                      color: Colors.black, width: 1))),
                        ),
                        IconButton(
                            onPressed: () {
                              setState(() {
                                isPasswordValid = !isPasswordValid;
                              });
                            },
                            icon: const Icon(Icons.visibility))
                      ],
                    ),
                  ],
                ),
                SizedBox(
                    width: MediaQuery.of(context).size.width / 2,
                    child: Row(
                      children: [
                        TextButton(
                            onPressed: () {}, child: const Text("Conexion")),
                        const Icon(Icons.lock_open)
                      ],
                    ))
              ],
            ),
          ),
        ],
      )),
    );
  }
}
