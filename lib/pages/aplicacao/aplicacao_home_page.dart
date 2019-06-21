import 'package:flutter/material.dart';

class AplicacaoHomePage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          "Aplicações Home",
          style: Theme.of(context).textTheme.display1,
        ),
      ),
    );
  }

}