import 'package:flutter/material.dart';

import 'package:pmsbmibile3/services/recursos.dart';
class Versao extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Versão & Sobre'),
      ),
      body: Center(
        child: Recursos.instance.plataforma == 'android' ? Text("Versão 3.1.0"):Text("Build: 201910222020"),
      ),
    );
  }
}