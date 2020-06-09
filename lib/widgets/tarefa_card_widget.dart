import 'package:flutter/material.dart';
import 'package:pmsbmibile3/models/models_controle/etiqueta_model.dart';
import 'package:pmsbmibile3/models/models_controle/tarefa_model.dart';
import 'package:pmsbmibile3/style/pmsb_colors.dart';
import 'package:pmsbmibile3/widgets/etiqueta_card_widget.dart';

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
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: PmsbColors.card,
        border: Border(),
      ),
      //color: this.cor,
      height: this.altura,
      width: this.largura,
      child: Column(
        children: [
          ListTile(
            //trailing: Icon(this.tarefa.publico ? Icons.lock_open : Icons.lock),
            title: Text("${this.tarefa.tituloAtividade}"),
            subtitle: Text(
                "Ações:${tarefa.getQuantAcoesFeitas()}/${tarefa.acoes.length}"),
            //subtitle: Text("Descrição: ${this.tarefa.descricaoAtividade}"),
          ),
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.start,
            children: gerarListaEtiquetas(),
          )
        ],
      ),
    );
  }

  List<Widget> gerarListaEtiquetas() {
    List<Widget> listaEtiqueta = List<Widget>();
    for (Etiqueta etq in tarefa.etiquetas) {
      listaEtiqueta.add(EtiquetaCardWidget(
        etiqueta: etq,
      ));
    }
    return listaEtiqueta;
  }
}
