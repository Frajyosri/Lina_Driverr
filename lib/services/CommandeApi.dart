import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lina_driver/models/CommandeDtails.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/ComandeModel.dart';

class CommandeApi {
  Future<List<Commande>> getCommandeApi() async {
    await Future.delayed(const Duration(seconds: 2));
    SharedPreferences pref = await SharedPreferences.getInstance();
    final id = pref.getInt("id");
    List<Commande> comande = [];
    http.Response response =
        await http.get(Uri.parse('http://10.0.2.2:8000/api/livreur/$id'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      data.forEach((element) {
        comande.add(Commande.fromJson(element));
      });

      return comande;
    }
    return [];
  }

  Future<List<CommandDetails>> getCommandeDetails(String code) async {
    await Future.delayed(const Duration(seconds: 1));
    List<CommandDetails> comande = [];
    http.Response response = await http
        .get(Uri.parse("http://10.0.2.2:8000/api/livreur/commande/$code"));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      data.forEach((element) {
        comande.add(CommandDetails.fromJson(element));
      });
      debugPrint("$comande");
      return comande;
    }
    return [];
  }

  Future<void> updateCommandeStat(String code) async {
    http.Response response = await http
        .put(Uri.parse('http://10.0.2.2:8000/api/livreur/CommandState/$code'));
    debugPrint(response.body);
    if (response.statusCode == 200) {
      debugPrint("Updated With success");
    } else {
      debugPrint("Faild to Updated ");
    }
  }

  Future<void> updateCommandeLivrer(String code) async {
    http.Response response = await http
        .put(Uri.parse('http://10.0.2.2:8000/api//livreur/Comande/$code'));
    if (response.statusCode == 201) {
      debugPrint("livrer With success");
    } else {
      debugPrint("Faild to Updated ");
    }
  }

  Future<void> updateCommande(String code) async {
    http.Response response = await http
        .put(Uri.parse('http://10.0.2.2:8000/api/livreur/Comande/$code'));
    if (response.statusCode == 201) {
      debugPrint("Updated With success");
    } else {
      debugPrint("Faild to Updated ");
    }
  }
}
