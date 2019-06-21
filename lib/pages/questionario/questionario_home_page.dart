import 'package:flutter/material.dart';

class QuestionarioHomePage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          "Questionarios Home",
          style: Theme.of(context).textTheme.display1,
        ),
      ),
    );
  }

}