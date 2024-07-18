import 'package:aplikasisurvei/Page/User/Home.dart';
import 'package:aplikasisurvei/apiservice/ApiService.dart';
import 'package:aplikasisurvei/main.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const Daftarpage());
}

class Daftarpage extends StatelessWidget {
  const Daftarpage({super.key});

  // This widget is the root of your application.
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
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final ApiService apiService = ApiService();

  Future<void> register() async {
    Map<String, String> credentials = {
      "username" : usernameController.text,
      "email": emailController.text,
      "password": passwordController.text
    };

    try {
      var result = await apiService.setRegistration(credentials);

      Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomeUser(email: emailController.text,))
      );
    } catch (e) {
      print('Login failed: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$e'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: double.infinity,
              margin: EdgeInsets.only(left: 20, right: 20),
              height: 500,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10)
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
                          'Daftar',
                          style: TextStyle(
                              fontSize: 20.0
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 20,),
                  Container(
                    margin: EdgeInsets.only(left: 20, right: 20),
                    child: TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          icon: Icon(Icons.email),
                          hintText: 'Email'
                      ),
                    ),
                  ),
                  SizedBox(height: 20,),
                  Container(
                    margin: EdgeInsets.only(left: 20, right: 20),
                    child: TextField(
                      controller: usernameController,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          icon: Icon(Icons.person),
                          hintText: 'Username'
                      ),
                    ),
                  ),
                  SizedBox(height: 20,),
                  Container(
                    margin: EdgeInsets.only(left: 20, right: 20),
                    child: TextField(
                      controller: passwordController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        icon: Icon(Icons.lock),
                        hintText: 'Password',
                      ),
                    ),
                  ),
                  SizedBox(height: 20,),
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(left: 20, right: 20),
                    child: ElevatedButton(onPressed: () {
                      register();
                    },
                        child: Text('Daftar')
                    ),
                  ),
                  SizedBox(height: 20,),

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
                                MaterialPageRoute(builder: (context) => MyApp())
                            );
                          },
                          child: Text('Sudah punya akun? login'),
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
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
