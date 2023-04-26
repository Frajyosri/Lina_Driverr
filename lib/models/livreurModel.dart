import 'ComandeModel.dart';

class livreurModel {
  late int id;
  late String nomliv;
  late String prenomliv;
  late String email;
  late String phoneliv;
  late String adress;
  late String image;
  late String mdp;
  late bool isdispo;

  livreurModel(
      {required this.id,
      required this.nomliv,
      required this.prenomliv,
      required this.email,
      required this.phoneliv,
      required this.adress,
      required this.image,
      required this.mdp,
      required this.isdispo});

  livreurModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nomliv = json['nomliv'];
    prenomliv = json['prenomliv'];
    email = json['email'];
    phoneliv = json['phoneliv'];
    adress = json['adress'];
    image = json['image'];
    mdp = json['mdp'];
    isdispo = json['isdispo'];
  }
}
