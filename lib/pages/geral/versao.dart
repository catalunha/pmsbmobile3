import 'package:flutter/material.dart';

class Versao extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Versão & Sobre'),
      ),
      body: Center(
        child: Text("Versão 3.0.7"),
      ),
    );
  }
}