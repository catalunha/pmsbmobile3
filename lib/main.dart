import 'package:flutter/material.dart';
import 'package:pmsbmibile3/pages/login.dart';
import 'package:pmsbmibile3/pages/home.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: "/login",
      routes: {
        "/login":(context) => LoginPage(),
        "/":(context) => HomePage(),
      },
    );
  }
}
