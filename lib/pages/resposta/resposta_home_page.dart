import 'package:flutter/material.dart';

class RespostaHomePage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(  
          "Resposta Home",
          style: Theme.of(context).textTheme.display1,
        ),
      ),
    );
  }

}