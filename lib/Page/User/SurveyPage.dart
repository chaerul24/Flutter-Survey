import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:aplikasisurvei/Page/User/ApiUrl.dart';
import 'package:aplikasisurvei/Page/User/TambahSurvey.dart';

class Surveypage extends StatefulWidget {
  final String email;

  const Surveypage({Key? key, required this.email}) : super(key: key);

  @override
  _SurveypageState createState() => _SurveypageState();
}

class _SurveypageState extends State<Surveypage> {
  List<dynamic> dataList = [];

  Future<void> listdata() async {
    var url = Uri.parse(ApiUrl.baseUrl + '/list_survei');

    var response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> body = jsonDecode(response.body);
      if (body['code'] == 200) {
        setState(() {
          dataList = body['data'];
        });
        print('Email: ' + widget.email);
        print('Loading selesai :)');

        // Iterate through survey data to check status and show appropriate message
        dataList.forEach((item) {
          String message = item['message'] ?? 'Survey belum dibuka';
          showSnackbar(message);
        });

      } else {
        print("Terjadi kesalahan");
        print("Pesan: " + body['status']);
      }
    } else {
      print('Server tidak merespons!');
    }
  }

  void showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    listdata();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Survey"),
        backgroundColor: Colors.blue,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
        ),
      ),
      body: Container(
        child: dataList.isEmpty
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
          itemCount: dataList.length,
          itemBuilder: (context, index) {
            var item = dataList[index];
            bool isClosed = item['check'] ?? false;
            String message = item['message'] ?? 'Survey belum dibuka';
            Color backgroundColor =
            message == 'Survey belum dibuka' || isClosed
                ? Colors.grey
                : Colors.white;

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  if (message == 'Survey belum dibuka') {
                    // Jika survei belum dibuka, tampilkan Snackbar
                    showSnackbar('Survey belum dibuka');
                  } else if (isClosed) {
                    // Jika survei sudah ditutup, tampilkan dialog
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text("Survei Ditutup"),
                        content: Text(
                          "Survei ini sudah ditutup.",
                        ),
                        actions: <Widget>[
                          TextButton(
                            child: Text('OK'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      ),
                    );
                  } else {
                    // Jika survei sedang berjalan, navigasikan ke TambahSurvey
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TambahSurvey(
                          id: item['id_survei'],
                          email: widget.email,
                          minggu: item['nama_survei'].toString(),
                          publish: item['tanggal_publish'].toString(),
                          akhir: item['tanggal_tutup'].toString(),
                        ),
                      ),
                    );
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: ListTile(
                    title: Text(
                      item['nama_survei'].toString(),
                      style: TextStyle(
                        color: message == 'Survey belum dibuka' ? Colors.white : Colors.black,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(message),
                        Text("Publish: " + item['tanggal_publish'].toString()),
                        Text("Tutup: " + item['tanggal_tutup'].toString()),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
