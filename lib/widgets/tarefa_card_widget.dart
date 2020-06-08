import 'package:flutter/material.dart';
import 'package:pmsbmibile3/models/models_controle/tarefa_model.dart';

class TarefaCardWidget extends StatelessWidget {
  final Color cor;
  final double altura;
  final double largura;
  final TarefaModel tarefa;

  TarefaCardWidget(
      {Key key, @required this.cor, this.altura, this.largura, this.tarefa})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: this.cor,
      height: this.altura,
      width: this.largura,
      child: ListTile(
        //trailing: Icon(this.tarefa.publico ? Icons.lock_open : Icons.lock),
        title: Text("${this.tarefa.tituloAtividade}"),
        subtitle: Text("Descrição: ${this.tarefa.descricaoAtividade}"),
      ),
    );
  }
}
