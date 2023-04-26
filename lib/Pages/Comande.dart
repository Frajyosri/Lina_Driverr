import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lina_driver/Pages/Profile.dart';
import 'package:lina_driver/bloc/commande_bloc.dart';
import 'package:lina_driver/models/CommandeDtails.dart';
import 'package:lina_driver/services/CommandeApi.dart';
import 'package:lina_driver/services/UserApi.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import '../bloc/commande_state.dart';
import '../models/ComandeModel.dart';

class CommandPage extends StatefulWidget {
  const CommandPage({super.key});

  @override
  State<CommandPage> createState() => _CommandPageState();
}

class _CommandPageState extends State<CommandPage> {
  bool _isDispo = true;
  String Code = "";
  String code_cmd = "";
  @override
  void initState() {
    super.initState();
    getSelectedValue();
    SetCodeCommande();
  }

  List<Commande> CommandeListe = [];
  List<CommandDetails> CommandeDetails = [];
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CommandeBloc, CommandeState>(
      builder: (context, state) {
        if (state is Loading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is SuccessCommandeListe) {
          CommandeListe = state.commandeListe;
          return ComandCard(CommandeListe);
        }
        if (state is SuccessCommandeDetails) {
          CommandeDetails = state.DetailsCommande;
          return CommandeDetailsUI(CommandeDetails);
        }
        if (state is SuccessCommandeUpdate) {}
        return SafeArea(
          child: Scaffold(
            backgroundColor: Colors.white,
            body: Column(
              children: [
                Stack(
                  children: [
                    Positioned(
                      top: 150,
                      left: 0,
                      child: AnimatedTextKit(
                        animatedTexts: [
                          TyperAnimatedText(
                            "Bonjour",
                            textStyle: const TextStyle(
                              fontSize: 28.0,
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TyperAnimatedText(
                            "Tu es prêt!! , ",
                            textStyle: const TextStyle(
                              fontSize: 28.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                        totalRepeatCount: 1,
                        repeatForever: false,
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height - 62.2,
                      child: Image.asset(
                        "assets/images/3724832.jpg",
                      ),
                    ),
                    Positioned(
                      bottom: 60,
                      left: 80,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width / 1.5,
                        child: Column(
                          children: const [
                            Text(
                              " Lina Driver ,",
                              style: TextStyle(
                                  fontFamily: "Lobster",
                                  letterSpacing: 2,
                                  overflow: TextOverflow.fade,
                                  fontSize: 32),
                            ),
                            Text(
                              " is always The One ",
                              style: TextStyle(
                                  fontFamily: "Lobster",
                                  letterSpacing: 2,
                                  overflow: TextOverflow.fade,
                                  fontSize: 32),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height / 18,
                        child: ElevatedButton(
                          onPressed: () {
                            context
                                .read<CommandeBloc>()
                                .add(GetCommandeEvent());
                          },
                          child: const Text(
                            "Livrer Commande",
                            style: TextStyle(
                                fontSize: 14,
                                fontFamily: AutofillHints.location),
                          ),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget Header() {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 25),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.transparent,
                        child: GestureDetector(
                          onTap: () => {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Profile()))
                          },
                          child: const Image(
                            image:
                                AssetImage("assets/animation/man-delivery.png"),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Vous-éte Disponible  !"),
                          Switch(
                              value: _isDispo,
                              activeColor: Colors.teal,
                              onChanged: (dispo) async {
                                SharedPreferences pref =
                                    await SharedPreferences.getInstance();
                                pref.setBool("isDispo", dispo);
                                setState(() {
                                  _isDispo = dispo;
                                });
                                UserApi().updateStateDriver(_isDispo);
                              }),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 16.5,
                  ),
                  const Divider(
                    thickness: 1.5,
                    endIndent: 10,
                    indent: 10,
                    height: 1,
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.3),
                    child: Text(
                      "Les Commande A livrer ",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18),
                    ),
                  )
                ],
              ),
            ),
          ]),
        ));
  }

  Widget ComandCard(List<Commande> cmd) {
    return Scaffold(
        backgroundColor: Colors.white,
        extendBody: true,
        body: Column(children: [
          Expanded(child: Header()),
          Expanded(
            flex: 3,
            child: RefreshIndicator(
              onRefresh: () async {
                Future.delayed(const Duration(seconds: 3));
              },
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: cmd.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () async {
                      SharedPreferences pref =
                          await SharedPreferences.getInstance();
                      var code_Cmd = pref.getString("code_cmd");
                      setState(() {
                        code_Cmd = cmd[index].id;
                        print(code_Cmd);
                      });
                      context
                          .read<CommandeBloc>()
                          .add(GetCommandeDetailsEvent());
                    },
                    onDoubleTap: () async {
                      context
                          .read<CommandeBloc>()
                          .add(UpdateCommandeStatEvent());
                    },
                    child: Card(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(
                                  top: 20.0,
                                  left: 20.0,
                                ),
                                child: Image(
                                    image: AssetImage(
                                        "assets/animation/cash-on-delivery.png"),
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Column(
                                children: [
                                  Text(
                                    "Commande Num °:${cmd[index].id}",
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                  Text(
                                    "Date Commande: ${cmd[index].dateCmd}",
                                    style: const TextStyle(
                                        decorationThickness:
                                            BorderSide.strokeAlignInside,
                                        fontSize: 18),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          /* const SizedBox(
                            width: 150,
                          ),*/
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              cmd[index].ispayed == true
                                  ? TextButton(
                                      onPressed: () {},
                                      child: const Text(
                                        "Commande Payer",
                                        style: TextStyle(
                                            color: Colors.teal, fontSize: 16),
                                      ),
                                    )
                                  : TextButton(
                                      onPressed: () {},
                                      child: const Text(
                                        "Commande Non Payer",
                                        style: TextStyle(
                                            color: Colors.redAccent,
                                            fontSize: 16),
                                      ),
                                    ),
                              cmd[index].etat == "livrer"
                                  ? TextButton.icon(
                                      onPressed: () {},
                                      icon: const Icon(
                                        Icons.check,
                                        color: Colors.teal,
                                        size: 14,
                                      ),
                                      label: const Text(
                                        "Livré avec Success",
                                        style: TextStyle(color: Colors.teal),
                                      ),
                                      style: const ButtonStyle(
                                          backgroundColor:
                                              MaterialStatePropertyAll(
                                                  Colors.white)),
                                    )
                                  : ElevatedButton(
                                      onPressed: () async {
                                        SharedPreferences pref =
                                            await SharedPreferences
                                                .getInstance();
                                        var code = pref.getString("code");
                                        setState(() {
                                          code = cmd[index].id;
                                        });
                                        print(code);
                                        await CommandeApi()
                                            .UpdateCommandeStat(code!);
                                      },
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateColor.resolveWith(
                                                  (states) =>
                                                      Colors.redAccent)),
                                      child: const Text("Livrer")),
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          )
        ]));
  }

  Widget CommandeDetailsUI(List<CommandDetails> details) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Details Commande"),
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (contex) => ComandCard(CommandeListe)));
            },
            icon: const Icon(Icons.arrow_back)),
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Column(
            children: const [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("Les Produit a Commandé ",
                    style: TextStyle(textBaseline: TextBaseline.alphabetic),
                    textAlign: TextAlign.center),
              ),
              Divider(
                color: Colors.blue,
                indent: 10,
                endIndent: 10,
                thickness: 3,
                height: 1.5,
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 3,
              child: ListView.builder(
                  itemCount: details.length,
                  itemBuilder: (context, item) {
                    return Column(
                      children: [
                        Row(children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width - 50,
                                height: MediaQuery.of(context).size.height / 10,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("${details[item].qteProduit} "),
                                        Text(details[item].nomProduit),
                                        Text("${details[item].prixProduit}")
                                      ],
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ]),
                        const SizedBox(
                          height: 30,
                          child: Divider(),
                        ),
                      ],
                    );
                  }),
            ),
          ),
        ],
      ),
    );
  }

  getSelectedValue() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      _isDispo = pref.getBool("isDispo") != false;
    });
  }

  SetCodeCommande() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString("code", Code);
    SharedPreferences pref2 = await SharedPreferences.getInstance();
    pref.setString("Code_cmd", code_cmd);
  }

  void UpdateState(bool isDispo) async {}
}
