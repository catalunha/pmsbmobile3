import 'package:flutter/material.dart';
import 'package:pmsbmibile3/models/models_controle/quadro_model.dart';

class QuadroCardWidget extends StatelessWidget {
  final Color cor;
  final double altura;
  final double largura;
  final QuadroModel quadro;
  final Function onTap;

  QuadroCardWidget(
      {Key key, @required this.cor, this.altura, this.largura, this.quadro, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: this.cor,
      height: this.altura,
      width: this.largura,
      child: ListTile(
        onTap: this.onTap,
        trailing: Icon(this.quadro.publico ? Icons.lock_open : Icons.lock),
        title: Text("${this.quadro.titulo}"),
        subtitle: Text("Descrição: ${this.quadro.descricao}"),
      ),
    );
  }
}
