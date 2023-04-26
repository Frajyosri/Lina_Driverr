import 'dart:convert';
import 'package:http/http.dart' as http;

class UserApi {
  Future<Map<String, dynamic>> GetUserDetails() async {
    Map<String, dynamic> Livreur = {};
    http.Response response =
        await http.get(Uri.parse('http://10.0.2.2:8000/api/livreurById/4'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      Livreur.addAll(data);

      return Livreur;
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
      print('Account updated successfully');
    } else {
      print('Failed to update account');
    }
  }

  Future<void> updateDriver(String email, String phone, String mdp) async {
    final url = Uri.parse('http://10.0.2.2:8000/api/livreur/4');
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email, 'mdp': mdp, 'phoneliv': phone}),
    );
    if (response.statusCode == 201) {
      print('Account updated successfully');
    } else {
      print('Failed to update account');
    }
  }
}
