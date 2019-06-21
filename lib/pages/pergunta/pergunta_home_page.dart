import 'package:flutter/material.dart';

class PerguntaHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          "Pergunta Home",
          style: Theme.of(context).textTheme.display1,
        ),
      ),
    );
  }
}
