import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserApi {
  Future<Map<String, dynamic>> getUserDetails() async {
    Map<String, dynamic> livreur = {};
    http.Response response =
        await http.get(Uri.parse('http://10.0.2.2:8000/api/livreurById/4'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      livreur.addAll(data);

      return livreur;
    }
    return {};
  }

  Future<void> updateStateDriver(bool isdispo) async {
    final url = Uri.parse('http://10.0.2.2:8000/api/livreurStat/4');
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'isdispo': isdispo}),
    );
    if (response.statusCode == 201) {
      debugPrint('Account updated successfully');
    } else {
      debugPrint('Failed to update account');
    }
  }

  Future<void> updateDriver(
      String email, String phone, String mdp, int id) async {
    final url = Uri.parse('http://10.0.2.2:8000/api/livreur/$id');
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email, 'mdp': mdp, 'phoneliv': phone}),
    );
    if (response.statusCode == 201) {
      debugPrint('Account updated successfully');
    } else {
      debugPrint('Failed to update account');
    }
  }

  Future<bool> loginDriver(String email, String mdp) async {
    int livreur = 0;
    final url = Uri.parse('http://10.0.2.2:8000/api/livreur/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email, 'mdp': mdp}),
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      livreur = data;
      SharedPreferences pref = await SharedPreferences.getInstance();
      pref.setInt("id", livreur);
      return true;
    }
    return false;
  }
}
