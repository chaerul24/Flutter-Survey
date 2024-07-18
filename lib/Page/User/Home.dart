import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:aplikasisurvei/Page/User/ApiUrl.dart';
import 'package:aplikasisurvei/Page/User/KeluhanPage.dart';
import 'package:aplikasisurvei/Page/User/SurveyPage.dart';

class HomeUser extends StatelessWidget {
  final String email;
  const HomeUser({Key? key, required this.email}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: HomePage(
        title: 'Home User',
        email: email,
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  final String title;
  final String email;

  const HomePage({Key? key, required this.title, required this.email}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late String name = 'Loading...';
  late String emailShared = '';

  @override
  void initState() {
    super.initState();
    username();
  }

  Future<void> username() async {
    var url = Uri.parse(ApiUrl.baseUrl + '/user');
    var header = {'Content-Type': 'application/json'};
    var parameter = jsonEncode({'email': widget.email});
    var response = await http.post(url, headers: header, body: parameter);

    if (response.statusCode == 200) {
      final Map<String, dynamic> body = jsonDecode(response.body);
      print('Name: '+body['data']['nama']);
      print(body['status']);
      if (body['code'] == 200) {
        setState(() {
          name = body['data']['nama'];
        });
        print('Name: '+body['data']['nama']);
      } else {
        print('Terjadi kesalahan');
        print('Pesan: ' + body['status']);
      }
    } else {
      print('Failed to fetch user data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              height: 1000,
              width: double.infinity,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.only(top: 50),
                  color: Colors.blue,
                  width: double.infinity,
                  height: 150,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 20),
                        child: Text(
                          name, // Menampilkan username yang sudah didapatkan
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 20),
                        child: Text(
                          'Selamat datang',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              top: 120,
              left: 0,
              right: 0,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(20),
                height: 500,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Surveypage(email: widget.email,)),
                        );
                      },
                      child: Container(
                        margin: EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: Colors.black,
                                  width: 1,
                                ),
                              ),
                              padding: EdgeInsets.all(10),
                              child: Image.asset('assets/survey.png'),
                            ),
                            SizedBox(height: 5,),
                            Text(
                              'Survey',
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Keluhanpage()),
                        );
                      },
                      child: Container(
                        margin: EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: Colors.black,
                                  width: 1,
                                ),
                              ),
                              padding: EdgeInsets.all(10),
                              child: Image.asset('assets/p.png'),
                            ),
                            SizedBox(height: 5,),
                            Text(
                              'Keluhan',
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: Colors.black,
                                width: 1,
                              ),
                            ),
                            padding: EdgeInsets.all(5),
                            child: Icon(Icons.logout),
                          ),
                          SizedBox(height: 5,),
                          Text(
                            'Keluar',
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
