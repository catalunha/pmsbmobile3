import 'package:flutter/material.dart';
import 'package:pmsbmibile3/models/models_controle/feed_models.dart';
import 'package:pmsbmibile3/models/models_controle/tarefa_model.dart';
import 'package:pmsbmibile3/models/models_controle/usuario_quadro_model.dart';
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
  
  List<FeedModel> listaFeed = [
    FeedModel(
        dataPostagem: "15 de julho de 2020",
        feedType: FeedType.texto,
        usuario: UsuarioQuadroModel(nome: "Usuario teste"),
        valorFeed:
            "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. "),
    FeedModel(
        dataPostagem: "15 de julho de 2020",
        feedType: FeedType.url,
        usuario: UsuarioQuadroModel(nome: "Usuario teste"),
        valorFeed: "https://github.com/"),
    FeedModel(
        dataPostagem: "15 de julho de 2020",
        feedType: FeedType.historico,
        usuario: UsuarioQuadroModel(nome: "Usuario teste"),
        valorFeed: "Moveu essa tarefa de Em avaliação para Concluido"),
    FeedModel(
        dataPostagem: "15 de julho de 2020",
        feedType: FeedType.texto,
        usuario: UsuarioQuadroModel(nome: "Usuario teste"),
        valorFeed:
            "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. "),
  ];

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
    for (FeedModel feed in listaFeed) {
      listaComentarios.add(ComentarioFeedWidget(feed: feed));
    }
    return listaComentarios;
  }
}
