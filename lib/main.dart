import 'package:flutter/material.dart';
import 'package:pmsbmibile3/pages/communication.dart';
import 'package:provider/provider.dart';
import 'package:pmsbmibile3/state/user_repository.dart';
import 'package:pmsbmibile3/pages/home.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
    
  @override
  Widget build(BuildContext context) {  
    return ChangeNotifierProvider(
      builder: (_) => UserRepository.instance(),
      child: MaterialApp(
        title: 'PMSB',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: "/",
        routes: {
          "/": (context) => HomePage(),
          '/comunicacao':(context)=> CommunicationPage()
        },
      ),
    );
  }
}
