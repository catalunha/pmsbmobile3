import 'package:flutter/material.dart';
import 'package:pmsbmibile3/components/default_scaffold.dart';
import 'package:pmsbmibile3/style/pmsb_styles.dart';

class SinteseHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultScaffold(
      backToRootPage:true ,
      backgroundColor: Colors.red,
      title: Text("Síntese dos Questionários"),
      body: Center(
        child: Text(
          "Em construção.",
          style: PmsbStyles.textoPrimario,
          //style: Theme.of(context).textTheme.display1,
        ),
      ),
    );
  }
}
