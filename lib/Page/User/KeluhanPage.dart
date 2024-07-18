import 'package:aplikasisurvei/Page/User/ApiUrl.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Keluhanpage extends StatefulWidget {
  const Keluhanpage({Key? key}) : super(key: key);

  @override
  _KeluhanpageState createState() => _KeluhanpageState();
}

class _KeluhanpageState extends State<Keluhanpage> {
  List<Map<String, dynamic>> keluhanList = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    var url = Uri.parse(ApiUrl.baseUrl+'/keluhan'); // Ganti dengan URL endpoint PHP Anda

    try {
      var response = await http.get(url);

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);

        setState(() {
          keluhanList = List<Map<String, dynamic>>.from(jsonResponse['data']);
        });

        print('Data berhasil diambil: $keluhanList');
      } else {
        print('Gagal mengambil data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Keluhan"),
        backgroundColor: Colors.blue,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: keluhanList.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      // Implement action when tapping on a list item
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'ID Jawaban: ${keluhanList[index]['id_jawaban']}',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Jawaban: ${keluhanList[index]['jawab']}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'ID Account: ${keluhanList[index]['id_account']}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'ID Survei: ${keluhanList[index]['id_survei']}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
