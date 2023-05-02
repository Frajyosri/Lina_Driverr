import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lina_driver/Pages/Login.dart';
import 'package:lina_driver/bloc/user_bloc_bloc.dart';
import 'package:lina_driver/services/UserApi.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final _formkey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _mdpController = TextEditingController();
  final _newMdpController = TextEditingController();
  String email = "";
  String mdp = "";
  String newMdp = "";
  String phone = "";
  bool isEnabel = false;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => UserBlocBloc(), child: builderUserBloc());
  }

  Widget builderUserBloc() {
    return BlocBuilder<UserBlocBloc, UserBlocState>(
      builder: (context, state) {
        if (state is SuccessUserListe) {
          Map<String, dynamic> livreur = state.UserListe;
          return formUpdate(livreur);
        }
        return SafeArea(
          child: Scaffold(
            appBar: AppBar(
              title: const Text(
                "information Personell",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontFamily: "PlayfairDisplay"),
              ),
              centerTitle: true,
              leading: IconButton(
                onPressed: () => {Navigator.pop(context)},
                icon: const Icon(Icons.arrow_back,
                    size: 30, weight: BorderSide.strokeAlignOutside),
              ),
            ),
            body: Column(
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Column(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width / 2,
                          height: MediaQuery.of(context).size.height / 4,
                          decoration: BoxDecoration(
                              border: Border.all(
                                width: 4,
                                color: Colors.white,
                              ),
                              boxShadow: [
                                BoxShadow(
                                    spreadRadius: 2,
                                    blurRadius: 10,
                                    color: Colors.black.withOpacity(0.1)),
                              ],
                              shape: BoxShape.circle,
                              image: const DecorationImage(
                                  fit: BoxFit.cover,
                                  image: AssetImage(
                                      "assets/animation/man-delivery.png"))),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Text(
                          "Service de livrison",
                          style: TextStyle(
                              fontSize: 20,
                              fontFamily: AutofillHints.addressCity,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 10,
                  child: Container(
                    decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 255, 255, 255)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            context.read<UserBlocBloc>().add(GetUserEvent());
                          },
                          child: Row(
                            children: const [
                              Icon(Icons.account_circle_outlined, size: 30),
                              SizedBox(
                                width: 15,
                              ),
                              Text(
                                "Paraméter de Compte ",
                                style: TextStyle(fontSize: 20),
                              )
                            ],
                          ),
                        ),
                        const Icon((Icons.arrow_forward_ios))
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 10,
                  child: Container(
                    decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 255, 255, 255)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Login()));
                            SharedPreferences pref =
                                await SharedPreferences.getInstance();
                            var islogin = pref.getBool("isLogin");
                            setState(() {
                              islogin = false;
                            });
                          },
                          child: Row(
                            children: const [
                              Icon(
                                Icons.logout_rounded,
                                size: 30,
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Text(
                                "Deconnexion ",
                                style: TextStyle(fontSize: 20),
                              )
                            ],
                          ),
                        ),
                        const Icon((Icons.arrow_forward_ios))
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget formUpdate(Map<String, dynamic> livreur) {
    return SafeArea(
      child: Center(
        child: Scaffold(
          appBar: AppBar(
            title: const Text("Modifier Profile"),
            centerTitle: true,
          ),
          body: Stack(children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Form(
                key: _formkey,
                child: ListView(scrollDirection: Axis.vertical, children: [
                  Column(children: [
                    TextField(
                      enabled: false,
                      decoration: InputDecoration(
                        label: Text(livreur["nomliv"].toString()),
                        border: const OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.black,
                              strokeAlign: 2,
                              style: BorderStyle.solid),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    TextField(
                        enabled: false,
                        decoration: InputDecoration(
                            label: Text(livreur["prenomliv"].toString()),
                            border: const OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 1,
                                    strokeAlign: BorderSide.strokeAlignOutside,
                                    color: Colors.black12)))),
                    const SizedBox(
                      height: 25,
                    ),
                    TextFormField(
                      onChanged: (value) {
                        setState(() {
                          email = value;
                        });
                      },
                      validator: (val) =>
                          val!.isEmpty ? "Merci de saisir votre Email " : null,
                      controller: _emailController,
                      enabled: true,
                      autofillHints: Characters.empty,
                      decoration: InputDecoration(
                        label: const Text("Email"),
                        hintText: livreur["email"].toString(),
                        border: const OutlineInputBorder(
                          borderSide: BorderSide(
                              width: 1,
                              strokeAlign: BorderSide.strokeAlignOutside,
                              color: Colors.black12),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    TextFormField(
                      onChanged: (value) {
                        setState(() {
                          phone = value;
                        });
                      },
                      validator: (val) => val!.isEmpty
                          ? "Merci de saisir votre Telephone"
                          : null,
                      controller: _phoneController,
                      enabled: true,
                      autofillHints: Characters.empty,
                      decoration: InputDecoration(
                        label: const Text("Num° Telephone "),
                        hintText: "+216 ${livreur["phoneliv"].toString()}",
                        border: const OutlineInputBorder(
                          borderSide: BorderSide(
                              width: 1,
                              strokeAlign: BorderSide.strokeAlignOutside,
                              color: Colors.black12),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    TextFormField(
                      onChanged: (value) {
                        setState(() {
                          mdp = value;
                        });
                      },
                      validator: (val) => val!.isEmpty && val.length < 6
                          ? "Merci de saisir Une Mot de passe"
                          : val != livreur["mdp"]
                              ? "Mot de passe ne pas Correct ! "
                              : null,
                      controller: _mdpController,
                      obscureText: true,
                      enabled: true,
                      decoration: const InputDecoration(
                        label: Text("Ancien Mot de passe "),
                        hintText: "********",
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                              width: 1,
                              strokeAlign: BorderSide.strokeAlignOutside,
                              color: Colors.black12),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    TextFormField(
                      onChanged: (value) {
                        setState(() {
                          newMdp = value;
                        });
                      },
                      obscureText: true,
                      validator: (val) => val!.isEmpty && val.length < 6
                          ? "Merci de saisir Un Nouveaux Mot de passe"
                          : null,
                      controller: _newMdpController,
                      enabled: true,
                      decoration: const InputDecoration(
                        label: Text("Nouveau Mot de passe "),
                        hintText: "*******",
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                              width: 1,
                              strokeAlign: BorderSide.strokeAlignOutside,
                              color: Colors.black12),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width - 50,
                            child: ElevatedButton(
                              onPressed: () {
                                if (_formkey.currentState!.validate()) {
                                  UserApi().updateDriver(
                                      email, phone, newMdp, livreur["id"]);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const Profile()));
                                }
                              },
                              child: const Text(
                                "Save",
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    letterSpacing: 2),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ]),
                ]),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
