import 'package:flutter/material.dart';
import 'package:pmsbmibile3/models/models_controle/quadro_model.dart';
import 'package:pmsbmibile3/models/models_controle/usuario_quadro_model.dart';
import 'package:pmsbmibile3/style/pmsb_colors.dart';

class QuadroCardWidget extends StatelessWidget {
  final Color cor;
  final double altura;
  final double largura;
  final QuadroModel quadro;
  final Function onTap;

  QuadroCardWidget(
      {Key key,
      @required this.cor,
      this.altura,
      this.largura,
      this.quadro,
      this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: this.cor,
      height: this.altura,
      width: this.largura,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: ListTile(
                  onTap: this.onTap,
                  trailing:
                      Icon(this.quadro.publico ? Icons.lock_open : Icons.lock),
                  title: Text("${this.quadro.titulo}"),
                  subtitle: Text("Descrição: ${this.quadro.descricao}"),
                ),
              ),
              botaoMore(),
            ],
          ),
          Container(
            alignment: Alignment.centerLeft,
            child: Wrap(
              children: gerarListaUsuarios(),
            ),
          ),
        ],
      ),
    );
  }

  Widget botaoMore() {
    return PopupMenuButton<Function>(
      tooltip: "Mostrar Menu",
      color: PmsbColors.fundo,
      onSelected: (Function result) {
        result();
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<Function>>[
        PopupMenuItem<Function>(
          value: () {
            print("Abrir tela de edição");
          },
          child: Row(
            children: [
              SizedBox(width: 2),
              Icon(Icons.edit),
              SizedBox(width: 5),
              Text('Editar'),
              SizedBox(width: 5),
            ],
          ),
        ),
        PopupMenuItem<Function>(
          value: () {
            print("Abrir tela de quadros arquivados");
          },
          child: Row(
            children: [
              SizedBox(width: 2),
              Icon(Icons.move_to_inbox),
              SizedBox(width: 5),
              Text('Arquivar'),
              SizedBox(width: 5),
            ],
          ),
        ),
      ],
    );
  }

  List<Widget> gerarListaUsuarios() {
    List<Widget> usuariosWidget = List<Widget>();
    for (UsuarioQuadroModel usuario in this.quadro.usuarios) {
      usuariosWidget.add(Padding(
        padding: const EdgeInsets.all(5),
        child: Tooltip(
          message: usuario.nome,
          child: CircleAvatar(
            backgroundColor: Colors.lightBlue[50],
            child: Text(
                usuario.nome[0].toUpperCase() + usuario.nome[1].toUpperCase()),
            backgroundImage: NetworkImage(''),
          ),
        ),
      ));
    }
    return usuariosWidget;
  }
}
