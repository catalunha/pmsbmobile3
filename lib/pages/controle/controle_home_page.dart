import 'package:flutter/material.dart';
import 'package:pmsbmibile3/components/default_scaffold.dart';

class ControleHomePage extends StatelessWidget{
  @override

  @override
  Widget build(BuildContext context) {
    return DefaultScaffold(
      backgroundColor: Colors.red,
      body: _body(context),
      title: Text("Controle do projeto"),
    );
  }

  _body(context) {
    return Container(
      child: Center(
        child: Text(
          "Em construção",
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }

}