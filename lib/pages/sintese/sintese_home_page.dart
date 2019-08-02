import 'package:flutter/material.dart';
import 'package:pmsbmibile3/components/default_scaffold.dart';

class SinteseHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultScaffold(
      backgroundColor: Colors.red,
      title: Text("Síntese dos questionários"),
      body: Center(
        child: Text(
          "Em construção.",
          style: Theme.of(context).textTheme.display1,
        ),
      ),
    );
  }
}
