import 'package:flutter/material.dart';

class AdministracaoHomePage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          "Administracao Home",
          style: Theme.of(context).textTheme.display1,
        ),
      ),
    );
  }

}