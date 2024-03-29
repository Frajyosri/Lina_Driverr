class CommandDetails {
  late String nomCom;
  late String prenomCom;
  late String nomCli;
  late String prenomCli;
  late String phoneCom;
  late String phoneCli;
  late String nomProduit;
  var prixProduit;
  late int qteProduit;
  var montant;
  late String dateFact;
  late String etat;
  late String code_cmd;

  CommandDetails(
      {required this.nomCom,
      required this.prenomCom,
      required this.nomCli,
      required this.prenomCli,
      required this.phoneCom,
      required this.phoneCli,
      required this.nomProduit,
      required this.prixProduit,
      required this.qteProduit,
      required this.montant,
      required this.dateFact,
      required this.etat,
      required this.code_cmd});

  CommandDetails.fromJson(Map<String, dynamic> json) {
    nomCom = json['NomCom'];
    prenomCom = json['prenomCom'];
    nomCli = json['nomCli'];
    prenomCli = json['prenomCli'];
    phoneCom = json['phoneCom'];
    phoneCli = json['phoneCli'];
    nomProduit = json['nom_Produit'];
    prixProduit = json['prix_produit'];
    qteProduit = json['qte_produit'];
    montant = json['montant'];
    dateFact = json['dateFact'];
    etat = json['etat'];
    code_cmd = json['code_cmd'];
  }
}
