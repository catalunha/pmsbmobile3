import 'package:flutter/material.dart';
import 'package:pmsbmibile3/components/default_scaffold.dart';
import 'package:pmsbmibile3/models/models_controle/tarefa_model.dart';
import 'package:pmsbmibile3/style/pmsb_colors.dart';
import 'package:pmsbmibile3/widgets/acao_list_widget.dart';
import 'package:pmsbmibile3/widgets/equipe_wrap_widget.dart';
import 'package:pmsbmibile3/widgets/etiqueta_wrap_widget.dart';

class ControleTarefaPage extends StatefulWidget {
  final TarefaModel tarefa;

  const ControleTarefaPage({Key key, @required this.tarefa}) : super(key: key);

  @override
  _ControleTarefaPageState createState() => _ControleTarefaPageState();
}

class _ControleTarefaPageState extends State<ControleTarefaPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultScaffold(
      backgroundColor: PmsbColors.navbar,
      backToRootPage: false,
      title: Text("Tarefa 01"),
      body: body(),
    );
  }

  Widget body() {
    double width = MediaQuery.of(context).size.width;
    // double height = MediaQuery.of(context).size.height;
    return Center(
      child: Container(
        width: width * 0.7,
        color: Colors.black26,
        child: Column(
          children: <Widget>[
            Flexible(
              flex: 2,
              child: _descricao(),
            ),
            Flexible(
              flex: 10,
              child: _painel(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _descricao() {
    return Container(color: Colors.black38);
  }

  Widget _painel() {
    return Container(
      color: Colors.black54,
      child: Row(
        children: <Widget>[
          Flexible(child: _colunaOpcoes(), flex: 2),
          Flexible(child: _feedComentarios(), flex: 8),
        ],
      ),
    );
  }

  Widget _colunaOpcoes() {
    return Container(
      color: Colors.deepOrangeAccent[50],
      child: ListView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(5),
            child: EquipeWrapWidget(),
          ),
          Padding(
            padding: EdgeInsets.all(5),
            child: EtiquetaWrapWidget(etiquetas: widget.tarefa.etiquetas),
          ),
          Padding(
            padding: EdgeInsets.only(top:2),
            child: AcaoListWidget(acoes: widget.tarefa.acoes),
          ),
          Container(
            height: 500,
            color: Colors.yellowAccent,
          ),
          Container(
            height: 300,
            color: Colors.purple,
          )
        ],
      ),
    );
  }

  Widget _feedComentarios() {
    return Container(
      color: Colors.purple[50],
      child: Column(
        children: <Widget>[
          Flexible(child: _caixaComemtario(), flex: 2),
          Flexible(child: _listaComentario(), flex: 8),
        ],
      ),
    );
  }

  Widget _caixaComemtario() {
    return Container(
      color: Colors.black,
      //height: 100,
    );
  }

  Widget _listaComentario() {
    return Container(
      child: ListView(
        children: <Widget>[
          Container(
            height: 300,
            color: Colors.white,
          ),
          Container(
            height: 400,
            color: Colors.grey[100],
          ),
          Container(
            height: 500,
            color: Colors.white,
          ),
          Container(
            height: 300,
            color: Colors.grey[100],
          )
        ],
      ),
    );
  }
}
