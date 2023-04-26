class CommandDetails {
  late String nomCom;
  late String prenomCom;
  late String nomCli;
  late String prenomCli;
  late String phoneCom;
  late String phoneCli;
  late String nomProduit;
  late int prixProduit;
  late int qteProduit;
  late int prixCard;
  late int montant;
  late String dateFact;

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
      required this.prixCard,
      required this.montant,
      required this.dateFact});

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
    prixCard = json['Prix_card'];
    montant = json['montant'];
    dateFact = json['dateFact'];
  }
}
