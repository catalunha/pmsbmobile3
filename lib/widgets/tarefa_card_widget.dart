import 'package:flutter/material.dart';
import 'package:pmsbmibile3/models/models_controle/tarefa_model.dart';
import 'package:pmsbmibile3/models/models_controle/usuario_quadro_model.dart';
import 'package:pmsbmibile3/style/pmsb_colors.dart';

class TarefaCardWidget extends StatelessWidget {
  final Color cor;
  final double altura;
  final double largura;
  final TarefaModel tarefa;
  final bool arquivado;
  final Function() onTap;

  TarefaCardWidget(
      {Key key,
      @required this.cor,
      @required this.arquivado,
      this.altura,
      this.largura,
      this.tarefa,
      this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: PmsbColors.card,
        border: Border(),
      ),
      height: this.altura,
      width: this.largura,
      child: Column(
        children: [
          arquivado
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "PENDENTE",
                        style: TextStyle(color: Colors.grey[400], fontSize: 12),
                      ),
                    ),
                  ],
                )
              : Container(),
          ListTile(
            trailing: Tooltip(
              message: "Prioridade alta",
              child: Icon(Icons.brightness_1, color: Colors.redAccent),
            ),
            title: Text("${this.tarefa.tituloAtividade}"),
            subtitle: Text(
                "Ações:${tarefa.getQuantAcoesFeitas()}/${tarefa.acoes.length}"),
            onTap: onTap,
          ),
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.start,
            children: gerarListaUsuarios(),
          ),
          Container(
            height: 30,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 2),
                  child: Text(
                    " terça, 14 de julho",
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.archive,
                    size: 20,
                  ),
                  onPressed: () {},
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  List<Widget> gerarListaUsuarios() {
    List<Widget> listaEtiqueta = List<Widget>();
    for (UsuarioQuadroModel user in tarefa.usuarios) {
      listaEtiqueta.add(userCard(user));
    }
    return listaEtiqueta;
  }

  Widget userCard(UsuarioQuadroModel user) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Tooltip(
          message: user.nome,
          child: Container(
            padding: EdgeInsets.all(1),
            height: 30,
            width: 30,
            child: CircleAvatar(
              backgroundColor: Colors.grey,
              child:
                  Text(user.nome[0].toUpperCase() + user.nome[1].toUpperCase()),
            ),
          ),
        ),
        Positioned(
          top: 20,
          left: 20,
          child: Icon(Icons.brightness_1, color: Colors.redAccent, size: 10),
        )
      ],
    );
  }
}
