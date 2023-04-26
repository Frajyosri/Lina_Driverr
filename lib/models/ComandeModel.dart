class Commande {
  late String id;
  late String dateCmd;
  late String etat;
  late double lat;
  late double long;
  late bool ispayed;
  late int comId;
  late String idCard;
  late String cliId;
  late int idliv;

  Commande({
    required this.id,
    required this.dateCmd,
    required this.etat,
    required this.lat,
    required this.long,
    required this.ispayed,
    required this.comId,
    required this.idCard,
    required this.cliId,
    required this.idliv,
  });

  Commande.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    dateCmd = json['Date_cmd'];
    etat = json['etat'];
    lat = json['lat'];
    long = json['long'];
    ispayed = json['ispayed'];
    comId = json['ComId'];
    idCard = json['idCard'];
    cliId = json['CliId'];
    idliv = json['idliv'];
  }
}
