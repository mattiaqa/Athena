import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ApiManager {
  static const String _baseUrl = 'http://localhost:8000/api';

  static Future<String?> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("access_token");
  }

  static Future<String?> fetchData(String endpoint) async {
    String access_token = await getToken() ?? "";

    final response = await http.get(
      Uri.parse('$_baseUrl/$endpoint'),
      headers: {'Authorization': 'Bearer $access_token'},
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      print('Errore nella richiesta API: ${response.statusCode}');
      return null;
    }
  }

  static Future<Map<String, dynamic>?> postData(
      String endpoint, Map<String, dynamic> data) async {
    String? token = await getToken();
    final response = await http.post(
      Uri.parse('$_baseUrl/$endpoint'),
      body: json.encode(data),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      // Se la risposta è 200 (OK), decodifica il JSON e restituisci i dati
      return json.decode(response.body);
    } else {
      // Se la risposta non è 200, gestisci l'errore come preferisci
      print('Errore nella richiesta API: ${response.statusCode}');
      return null;
    }
  }

  static Future<Map<String, dynamic>?> deleteData(
      String endpoint, Map<String, dynamic> data) async {
    String? token = await getToken();
    final response = await http.delete(
      Uri.parse('$_baseUrl/$endpoint'),
      body: json.encode(data),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      // Se la risposta è 200 (OK), decodifica il JSON e restituisci i dati
      return json.decode(response.body);
    } else {
      // Se la risposta non è 200, gestisci l'errore come preferisci
      print('Errore nella richiesta API: ${response.statusCode}');
      return null;
    }
  }
}

//----------------------------------------------------------------------------

Future<bool> deleteAppello(String idProva, String data) async {
  try {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String access_token = prefs.getString("access_token") ?? '';
    http.Response response = await http.delete(
        Uri.parse('http://localhost:8000/api/appelli/sprenota'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $access_token'
        },
        body: json.encode({'idprova': idProva, 'data': data}));
    if (response.statusCode == 200) return true;
  } catch (e) {}
  return false;
}
