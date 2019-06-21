import 'package:flutter/material.dart';

class SinteseHomePage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          "Sintese Home",
          style: Theme.of(context).textTheme.display1,
        ),
      ),
    );
  }

}