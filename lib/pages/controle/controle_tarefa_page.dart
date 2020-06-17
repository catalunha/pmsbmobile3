import 'package:flutter/material.dart';
import 'package:pmsbmibile3/components/default_scaffold.dart';
import 'package:pmsbmibile3/models/models_controle/feed_model.dart';
import 'package:pmsbmibile3/models/models_controle/tarefa_model.dart';
import 'package:pmsbmibile3/style/pmsb_colors.dart';
import 'package:pmsbmibile3/widgets/caixa_texto_feed_widget.dart';
import 'package:pmsbmibile3/widgets/comentario_feed_widget.dart';

class ControleTarefaPage extends StatefulWidget {
  final TarefaModel tarefa;

  ControleTarefaPage({Key key, @required this.tarefa}) : super(key: key);

  @override
  _ControleTarefaPageState createState() => _ControleTarefaPageState();
}

class _ControleTarefaPageState extends State<ControleTarefaPage> {

  @override
  Widget build(BuildContext context) {
    return DefaultScaffold(
      backgroundColor: PmsbColors.navbar,
      backToRootPage: false,
      title: Text("${widget.tarefa.tituloAtividade}"),
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
          Container(
            height: 300,
            color: Colors.greenAccent,
          ),
          Container(
            height: 400,
            color: Colors.red,
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
          Flexible(child: CaixaTextoFeedWidget(), flex: 2),
          Flexible(child: _listaComentario(), flex: 8),
        ],
      ),
    );
  }

  Widget _listaComentario() {
    return Container(
      // child: Text("${widget.tarefa.feed[0].corpoTexto}"),
      child: ListView(children: getListaComentarios()),
    );
  }

  List<Widget> getListaComentarios() {
    List<Widget> listaComentarios = List<Widget>();

    for (Feed feed in widget.tarefa.feed) {
      listaComentarios.add(ComentarioFeedWidget(feed: feed));
    }

    return listaComentarios;
  }
}
