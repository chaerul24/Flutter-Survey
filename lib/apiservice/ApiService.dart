import 'dart:convert';
import 'package:http/http.dart' as http;
import 'Soal.dart';
import 'SurveyData.dart';

class ApiService {
  final String apiUrl = "http://192.168.1.2/"; // Ganti dengan URL API Anda

  Future<Map<String, dynamic>> home(Map<String, String> e) async {
    final response = await http.post(
      Uri.parse(apiUrl + "home"),
      headers: <String, String> {
        'Content-Type' : 'application/json; chartset=UTF-8'
      },
      body: jsonEncode(e),
    );

    if(response.statusCode == 200){
      final Map<String, dynamic> body = jsonDecode(response.body);
      if (body['code'] == 200) {
        // Login berhasil
        return {
          'id_account': body['data']['id_account'],
          'nama': body['data']['nama'],
          'email': body['data']['email'],
        };
      } else {
        throw Exception(body['status']); // Melemparkan exception dengan pesan status dari server
      }
    }else{
      print(response.body);
      throw Exception('Failed to email');
    }
  }

  Future<Map<String, dynamic>> loginUser(Map<String, String> credentials) async {
    final response = await http.post(
      Uri.parse(apiUrl + "login"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(credentials),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> body = jsonDecode(response.body);
      if (body['code'] == 200) {
        // Login berhasil
        return {
          'status': body['status'],
          'message': body['data']['message'],
          'id_account': body['data']['id_account'],
        };
        print("Login berhasil");
      } else {
        throw Exception(body['status']); // Melemparkan exception dengan pesan status dari server
      }
    } else {
      print(response.body);
      throw Exception('Failed to login'); // Melemparkan exception jika status code bukan 200
    }
  }

  Future<Map<String, dynamic>> setRegistration(Map<String, String> c) async {
    final response = await http.post(
      Uri.parse(apiUrl + "signup"),
      headers: <String, String> {
        'Content-Type' : 'application/json; charset=UTF-8'
      },
      body: jsonEncode(c),
    );

    if(response.statusCode == 200){
      final Map<String, dynamic> body = jsonDecode(response.body);
      if(body['code'] ==  200){
        return {
          'status': body['status'],
          'message': body['data']['message'],
          'email': body['data']['email'],
        };
      }else{
        throw Exception(body['status']);
      }
    }else{
      print(response.body);
      throw Exception('Failed to registration');
    }
  }

  Future<List<Survey>> getSurveys() async {
    final response = await http.get(Uri.parse(apiUrl + 'survey'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body); // Mengubah respons JSON menjadi dynamic

      if (responseData['code'] == 200) {
        final List<dynamic> surveysData = responseData['data']; // Ambil data survei dari dalam objek 'data'
        List<Survey> surveys = surveysData.map((item) => Survey.fromJson(item)).toList();
        return surveys;
      } else {
        throw Exception(responseData['status'] ?? 'Failed to load surveys'); // Jika ada pesan error dari API
      }
    } else {
      throw Exception('Failed to load surveys');
    }
  }

  Future<void> getSoal(String id_account, String soal, String id_survey, String a, String b, String c, String d) async {
    final response = await http.post(
      Uri.parse(apiUrl + 'add_soal'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'id_account': id_account,
        'soal': soal,
        'id_survey': id_survey,
        'a': a,
        'b': b,
        'c': c,
        'd': d,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create soal');
    }
  }

}

