import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lina_driver/Pages/Home.dart';
import 'package:lina_driver/Pages/Profile.dart';
import 'package:lina_driver/Widget/validation.dart';
import 'package:lina_driver/bloc/commande_bloc.dart';
import 'package:lina_driver/models/CommandeDtails.dart';
import 'package:lina_driver/services/CommandeApi.dart';
import 'package:lina_driver/services/UserApi.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import '../bloc/commande_state.dart';
import '../models/ComandeModel.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:geolocator/geolocator.dart';

class CommandPage extends StatefulWidget {
  const CommandPage({super.key});

  @override
  State<CommandPage> createState() => _CommandPageState();
}

class _CommandPageState extends State<CommandPage> {
  bool _isDispo = true;
  String codeCmd = "";
  String code = "";
  String codecommandelivrer = "";
  @override
  void initState() {
    super.initState();
    getSelectedValue();
    createCodeCommande();
  }

  Future<void> createCodeCommande() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString("code", code);
  }

  late Position p;
  List<Commande> commandeListe = [];
  List<CommandDetails> commandeDetails = [];
  List<Commande> newcommandeListe = [];
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CommandeBloc, CommandeState>(
      builder: (context, state) {
        if (state is Loading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is SuccessCommandeListe) {
          commandeListe = state.commandeListe;
          return comandCard(commandeListe);
        }
        if (state is SuccessCommandeDetails) {
          commandeDetails = state.detailsCommande;
          return commandeDetailsUI(commandeDetails);
        }
        if (state is VerfierCommande) {
          return const Validation();
        }
        if (state is SuccessCommandeUpdate) {
          return comandCard(commandeListe);
        }
        if (state is SuccessCommandeRefrech) {
          newcommandeListe = state.newcommandeListe;
          return comandCard(newcommandeListe);
        }
        return SafeArea(
          child: Scaffold(
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                    children: [
                      Positioned(
                        top: 100,
                        left: 0,
                        child: AnimatedTextKit(
                          animatedTexts: [
                            TyperAnimatedText(
                              "Bonjour, et Bienvenu Dans Lina Driver ",
                              textStyle: const TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TyperAnimatedText(
                              "Tu es prêt !! , ",
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
                        height: MediaQuery.of(context).size.height - 50,
                        child: Image.asset(
                          "assets/images/3724832.jpg",
                        ),
                      ),
                      Positioned(
                        bottom: MediaQuery.of(context).size.height / 8,
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
                        child: Padding(
                          padding: const EdgeInsets.only(left: 25, bottom: 20),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width - 50,
                            height: MediaQuery.of(context).size.height / 20,
                            child: ElevatedButton(
                              onPressed: () {
                                context
                                    .read<CommandeBloc>()
                                    .add(GetCommandeEvent());
                              },
                              child: const Text(
                                "Livrer Commande",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: AutofillHints.location,
                                    fontWeight: FontWeight.w500),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget header() {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 12),
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
                  const Divider(
                    thickness: 1.5,
                    endIndent: 10,
                    indent: 10,
                    height: 1,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                ],
              ),
            ),
          ]),
        ));
  }

  Widget comandCard(List<Commande> cmd) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBody: true,
      body: Column(children: [
        Expanded(child: header()),
        const Padding(
          padding: EdgeInsets.only(bottom: 3),
          child: Text(
            "Les Commande A livrer ",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18),
          ),
        ),
        Expanded(
          flex: 3,
          child: RefreshIndicator(
            onRefresh: () async {
              Future.delayed(const Duration(seconds: 3));
              context.read<CommandeBloc>().add((RefrechCommandeStatEvent()));
            },
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: cmd.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () async {
                    SharedPreferences pref =
                        await SharedPreferences.getInstance();
                    pref.setString("code", cmd[index].id);
                    setState(() {
                      codeCmd = cmd[index].id;
                    });

                    // ignore: use_build_context_synchronously
                    context.read<CommandeBloc>().add(GetCommandeDetailsEvent());
                  },
                  child: GestureDetector(
                    onDoubleTap: () async {
                      await CommandeApi().updateCommandeStat(cmd[index].id);
                      goRooting(cmd[index].lat, cmd[index].long);
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
                                        color: Color.fromARGB(255, 39, 28, 255),
                                        size: 16,
                                      ),
                                      label: const Text(
                                        "Livré avec Success",
                                        style: TextStyle(
                                            color: Color.fromARGB(
                                                255, 39, 28, 255),
                                            fontSize: 16),
                                      ),
                                      style: const ButtonStyle(
                                          backgroundColor:
                                              MaterialStatePropertyAll(
                                                  Colors.white)),
                                    )
                                  : cmd[index].etat == "en_route"
                                      ? ElevatedButton(
                                          onPressed: () async {
                                            SharedPreferences pref =
                                                await SharedPreferences
                                                    .getInstance();
                                            pref.setString("codecommandelivrer",
                                                cmd[index].id);
                                            setState(() {
                                              codecommandelivrer =
                                                  cmd[index].id;
                                            });
                                            // ignore: use_build_context_synchronously
                                            context
                                                .read<CommandeBloc>()
                                                .add((UpdateCommandeEvent()));
                                          },
                                          style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateColor
                                                      .resolveWith((states) =>
                                                          Colors.redAccent)),
                                          child: const Text("Done"))
                                      : const Text(
                                          "Confirmer",
                                          style: TextStyle(
                                              color: Colors.teal, fontSize: 18),
                                        ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        )
      ]),
    );
  }

  Widget commandeDetailsUI(List<CommandDetails> details) {
    var prixC = details[0].montant;
    var result = prixC.toDouble();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Details Commande"),
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (contex) => const HomePage()));
            },
            icon: const Icon(Icons.arrow_back)),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.only(top: 30),
        child: Column(
          children: [
            Column(
              children: [
                Column(
                  children: [
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Row(
                              children: [
                                const Text(
                                  "Facturé a : ",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: Colors.blue),
                                ),
                                Text(
                                  "${details[0].nomCli}${details[0].prenomCli}",
                                  style: const TextStyle(fontSize: 18),
                                )
                              ],
                            ),
                            Row(
                              children: [
                                const Text(
                                  "tel °: ",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: Colors.blue),
                                ),
                                Text(
                                  details[0].phoneCli,
                                  style: const TextStyle(fontSize: 18),
                                  textAlign: TextAlign.center,
                                )
                              ],
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const Text(
                                  "Facturé par : ",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: Colors.blue),
                                ),
                                Text(
                                  "${details[0].nomCom}${details[0].prenomCom}",
                                  style: const TextStyle(fontSize: 20),
                                )
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const Text(
                                  "tel °: ",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: Colors.blue),
                                ),
                                Text(
                                  details[0].phoneCom,
                                  style: const TextStyle(fontSize: 18),
                                  textAlign: TextAlign.center,
                                )
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 15,
                      child: Center(
                        child: Text(
                          "Date Facture :${details[0].dateFact}",
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Text("Les Produit a Commandé ",
                      style: TextStyle(fontSize: 17),
                      textAlign: TextAlign.center),
                ),
                const Divider(
                  color: Colors.blue,
                  indent: 10,
                  endIndent: 10,
                  thickness: 1.75,
                  height: 1.5,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        "Qte",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text("Produit ",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text("Prix",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
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
                                  height:
                                      MediaQuery.of(context).size.height / 10,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("${details[item].qteProduit} ",
                                              style: const TextStyle(
                                                  fontSize: 15)),
                                          Text(
                                            details[item].nomProduit,
                                            style:
                                                const TextStyle(fontSize: 15),
                                          ),
                                          Text(" ${details[item].prixProduit}",
                                              style:
                                                  const TextStyle(fontSize: 15))
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
                            child: Divider(
                              thickness: 2,
                            ),
                          ),
                        ],
                      );
                    }),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Text(
                  "Montant Total : ",
                  style: TextStyle(color: Colors.blue, fontSize: 20),
                ),
                Text(
                  "${result}DT ",
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                )
              ],
            ),
            details[0].etat != "livrer"
                ? Padding(
                    padding: const EdgeInsets.all(9.5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const HomePage()));
                          },
                          child: const Text(
                            "Pas Maintenant",
                            style: TextStyle(
                                color: Colors.redAccent, fontSize: 16),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 3.25,
                          child: TextButton(
                            onPressed: () {},
                            style: const ButtonStyle(
                                backgroundColor:
                                    MaterialStatePropertyAll(Colors.redAccent)),
                            child: const Text(
                              "Livrer ",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                : const Text("")
          ],
        ),
      ),
    );
  }

  getSelectedValue() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      _isDispo = pref.getBool("isDispo") != false;
      codeCmd = pref.getString("code")!;
    });
  }

  Future<List<Commande>> Refrech() async {
    List<Commande> com = await CommandeApi().getCommandeApi();
    return com;
  }

  void goRooting(double lat, double long) async {
    Position position = await getCurrentLocation();
    double latitude = position.latitude;
    double longitude = position.longitude;
    debugPrint('Latitude: $latitude');
    debugPrint('Longitude: $longitude');
    final url = Uri.parse(
        "https://maps.googleapis.com/maps/api/directions/json?avoid=highways&destination=$lat,$long&mode=car&origin=$latitude,$longitude&key=AIzaSyCQ14IIfjYKGlE79DJwUN36IaofJpeCKZA");
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch directions';
    }
  }

  Future<Position> getCurrentLocation() async {
    bool isLocationServiceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!isLocationServiceEnabled) {
      throw 'Location services are disabled.';
    }

    // Request location permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw 'Location permission is denied.';
      }
    }

    // Get current position
    return await Geolocator.getCurrentPosition();
  }
}
