import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:aplikasisurvei/Page/User/ApiUrl.dart';

class TambahSurvey extends StatefulWidget {
  final int id;
  final String email;
  final String minggu;
  final String publish;
  final String akhir;

  const TambahSurvey({
    Key? key,
    required this.email,
    required this.id,
    required this.minggu,
    required this.publish,
    required this.akhir,
  }) : super(key: key);

  @override
  _TambahSurveyState createState() => _TambahSurveyState();
}

class _TambahSurveyState extends State<TambahSurvey> {
  late SharedPreferences save;
  List<Map<String, dynamic>> items = [];
  Map<int, String> selectedOptions = {};
  Map<int, String> jawaban = {};
  bool isLoading = false;

  void showSnackBar(String message) {
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
    soal();
    print(widget.id);
  }

  Future<void> soal() async {
    var url = Uri.parse(ApiUrl.baseUrl + '/soal');

    var headers = {'Content-type': 'application/json'};
    var body = jsonEncode({
      'id': widget.id,
    });

    try {
      var response = await http.post(url, headers: headers, body: body);

      print('Response from server:');
      print(response.body); // Output JSON response

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        if (jsonResponse['code'] == 200) {
          var data = jsonResponse['data'];
          if (data != null) {
            setState(() {
              items = List<Map<String, dynamic>>.from(data);
            });
          } else {
            showSnackBar('Data yang diterima kosong');
            print('Data yang diterima kosong');
          }
        } else {
          showSnackBar(jsonResponse['status'] ?? 'Gagal mengambil pertanyaan survei');
          print('Gagal mengambil pertanyaan survei: ${jsonResponse['status']}');
        }
      } else {
        showSnackBar('Gagal mengambil pertanyaan survei');
        print('Server response error: ${response.statusCode}');
      }
    } catch (e) {
      showSnackBar('Terjadi kesalahan saat mengambil data');
      print('Error: $e');
    }
  }


  Future<void> kirimData() async {
    var url = Uri.parse(ApiUrl.baseUrl + '/add_soal');

    var headers = {'Content-type': 'application/json'};
    var body = jsonEncode({
      'email': widget.email,
      'id_survei': widget.id,
      'jawaban': jawaban.entries.map((entry) => {
        'jawaban': entry.value,
      }).toList(),
    });

    try {
      var response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = jsonDecode(response.body);
        if (responseBody['code'] == 200) {
          showSnackBar('Jawaban berhasil dikirim');
        } else {
          showSnackBar(responseBody['status'] ?? 'Gagal mengirim jawaban');
          print('Server response error: ${responseBody['status'] ?? 'Unknown error'}');
        }
      } else {
        showSnackBar('Gagal mengirim jawaban');
        print('Server response error: ${response.statusCode}');
        print('Server response body: ${response.body}');
      }
    } catch (e) {
      showSnackBar('Terjadi kesalahan saat mengirim data');
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.minggu),
        backgroundColor: Colors.blue,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
        ),
      ),
      body: isLoading
          ? Center(
        child: CircularProgressIndicator(),
      )
          : items.isNotEmpty
          ? Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  var item = items[index];
                  return ListBoxJawaban(
                    idSoal: item['id_soal'],
                    soal: item['soal'],
                    a: item['a'],
                    b: item['b'],
                    c: item['c'],
                    d: item['d'],
                    selectedOption: selectedOptions[item['id_soal']] ?? '',
                    onOptionSelected: (String option) {
                      setState(() {
                        selectedOptions[item['id_soal']] = option;
                        jawaban[item['id_soal']] = option;
                      });
                    },
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (jawaban.length == items.length) {
                  kirimData();
                } else {
                  showSnackBar('Pilih semua jawaban terlebih dahulu');
                }
              },
              child: Text('Kirim'),
            ),
          ],
        ),
      )
          : Center(
        child: Text('Data tidak tersedia'),
      ),
    );
  }
}

class ListBoxJawaban extends StatelessWidget {
  final int idSoal;
  final String soal;
  final String a;
  final String b;
  final String c;
  final String d;
  final String selectedOption;
  final ValueChanged<String> onOptionSelected;

  const ListBoxJawaban({
    Key? key,
    required this.idSoal,
    required this.soal,
    required this.a,
    required this.b,
    required this.c,
    required this.d,
    required this.selectedOption,
    required this.onOptionSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          soal,
          style: TextStyle(fontSize: 18.0),
        ),
        SizedBox(height: 20),
        RadioListTile<String>(
          title: Text(a),
          value: a,
          groupValue: selectedOption,
          onChanged: (String? value) {
            if (value != null) {
              onOptionSelected(value);
            }
          },
        ),
        RadioListTile<String>(
          title: Text(b),
          value: b,
          groupValue: selectedOption,
          onChanged: (String? value) {
            if (value != null) {
              onOptionSelected(value);
            }
          },
        ),
        RadioListTile<String>(
          title: Text(c),
          value: c,
          groupValue: selectedOption,
          onChanged: (String? value) {
            if (value != null) {
              onOptionSelected(value);
            }
          },
        ),
        RadioListTile<String>(
          title: Text(d),
          value: d,
          groupValue: selectedOption,
          onChanged: (String? value) {
            if (value != null) {
              onOptionSelected(value);
            }
          },
        ),
      ],
    );
  }
}
