import 'package:flutter/material.dart';

class SinteseHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text("Sintese dos questionários"),
      ),
      body: Center(
        child: Text(
          "Em construção.",
          style: Theme.of(context).textTheme.display1,
        ),
      ),
    );
  }
}
