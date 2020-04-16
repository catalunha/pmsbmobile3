import 'package:flutter/material.dart';

import 'package:pmsbmibile3/services/recursos.dart';
import 'package:pmsbmibile3/style/pmsb_colors.dart';
import 'package:pmsbmibile3/style/pmsb_styles.dart';

class Versao extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PmsbColors.fundo,
      appBar: AppBar(
        backgroundColor: PmsbColors.fundo,
        bottomOpacity: 0.0,
        elevation: 0.0,
        centerTitle: true,
        title: Text('Versão & Sobre'),
      ),
      body: Center(
        child: Recursos.instance.plataforma == 'android'
            ? Text("Versão 3.1.0", style: PmsbStyles.textoPrimario,)
            : Text("Build: 201910222020"),
      ),
    );
  }
}
