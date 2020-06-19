import 'package:flutter/material.dart';
import 'package:pmsbmibile3/models/models_controle/etiqueta_model.dart';

class EtiquetaCardWidget extends StatelessWidget {
  final Etiqueta etiqueta;

  EtiquetaCardWidget({Key key, @required this.etiqueta}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3),
      child: Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Text(
            etiqueta.titulo,
            style: TextStyle(fontSize: 14),
          ),
        ),
        color: Color(etiqueta.cor),
      ),
    );
  }
}
