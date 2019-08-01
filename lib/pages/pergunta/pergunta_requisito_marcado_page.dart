import 'package:flutter/material.dart';

class PerguntaRequisitoMarcadoPage extends StatelessWidget {
  final String perguntaID;

  PerguntaRequisitoMarcadoPage({this.perguntaID});


  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(perguntaID),
    );
  }
}