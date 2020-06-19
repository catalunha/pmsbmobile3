import 'package:flutter/material.dart';
import 'package:pmsbmibile3/models/models_controle/feed_model.dart';
import 'package:pmsbmibile3/models/models_controle/tarefa_model.dart';
import 'package:pmsbmibile3/widgets/caixa_texto_feed_widget.dart';
import 'package:pmsbmibile3/widgets/comentario_feed_widget.dart';

class ControleFeedPage extends StatefulWidget {
  final TarefaModel tarefa;

  ControleFeedPage({Key key, this.tarefa}) : super(key: key);

  @override
  _ControleFeedPageState createState() => _ControleFeedPageState();
}

class _ControleFeedPageState extends State<ControleFeedPage>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        children: <Widget>[CaixaTextoFeedWidget(), _listaComentario()],
      ),
    );
  }

  Widget _listaComentario() {
    return Container(
      child: Column(children: getListaComentarios()),
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
