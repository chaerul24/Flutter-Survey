import 'package:aplikasisurvei/Page/User/ApiUrl.dart';
import 'package:flutter/material.dart';
import 'package:aplikasisurvei/Page/User/Home.dart'; // Sesuaikan dengan lokasi HomeUser.dart
import 'package:aplikasisurvei/DaftarPage.dart'; // Sesuaikan dengan lokasi DaftarPage.dart
import 'package:aplikasisurvei/apiservice/ApiService.dart'; // Sesuaikan dengan lokasi ApiService.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final ApiService apiService = ApiService();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  late String emailShared;


  Future<void> setLogin() async {
    ApiUrl apiUrl = new ApiUrl();
    var url = Uri.parse(ApiUrl.baseUrl+'/login');

    var header = {'Content-Type' : 'application/json'};
    var json = jsonEncode({
      'email' : emailController.text,
      'password' : passwordController.text
    });

    var response = await http.post(
      url,
      headers: header,
      body: json,
    );

    if(response.statusCode == 200){
      final Map<String, dynamic> body = jsonDecode(response.body);
      if(body['code'] == 200){
        print('Login berhasil');
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomeUser(email: emailController.text))
        );
      }else{
        print('Login gagal');
        print('Pesan: '+body['status']);
      }
    }else{
      print('Server not response');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: double.infinity,
              margin: EdgeInsets.only(left: 20, right: 20, top: 120),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 80,
                          height: 80,
                          child: Image.asset('assets/user.png'),
                        ),
                        Text(
                          'Masuk',
                          style: TextStyle(fontSize: 20.0),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 20, right: 20),
                    child: TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          icon: Icon(Icons.person),
                          hintText: 'Username Or Email'),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 20, right: 20),
                    child: TextField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        icon: Icon(Icons.lock),
                        hintText: 'Password',
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(left: 20, right: 20),
                    child: ElevatedButton(
                        onPressed: () {
                          setLogin();
                        },
                        child: Text('Masuk')),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Daftarpage()));
                          },
                          child: Text('Belum memiliki akun? Daftar segera.'),
                        )
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
