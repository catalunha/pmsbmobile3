import 'package:flutter/material.dart';
import 'package:pmsbmibile3/models/models_controle/feed_models.dart';
import 'package:pmsbmibile3/style/pmsb_colors.dart';
import 'package:pmsbmibile3/style/pmsb_styles.dart';

enum WhyFarther { harder, smarter, selfStarter, tradingCharter }

class ComentarioFeedWidget extends StatefulWidget {
  final FeedModel feed;

  ComentarioFeedWidget({Key key, this.feed}) : super(key: key);

  @override
  _ComentarioFeedWidgetState createState() => _ComentarioFeedWidgetState();
}

class _ComentarioFeedWidgetState extends State<ComentarioFeedWidget> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: width * 0.01, vertical: 5),
      child: Card(
        color: PmsbColors.card,
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Chip(
                    avatar: CircleAvatar(
                        backgroundColor: Colors.blue.shade300,
                        child: Text('LT')),
                    label: Text(
                      '${widget.feed.usuario.nome}',
                      style: PmsbStyles.textoSecundario,
                    ),
                  ),
                ),
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        '${widget.feed.dataPostagem}',
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    botaoMore()
                  ],
                )
              ],
            ),
            SizedBox(height: 5),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: _selecionarTipoFeed(),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget botaoMore() {
    return PopupMenuButton<Function>(
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
            print("Abrir tela de apagar");
          },
          child: Row(
            children: [
              SizedBox(width: 2),
              Icon(Icons.delete),
              SizedBox(width: 5),
              Text('Apagar'),
              SizedBox(width: 5),
            ],
          ),
        ),
      ],
    );
  }

  Widget _selecionarTipoFeed() {
    Widget widgetSelect;

    switch (widget.feed.feedType) {
      case FeedType.texto:
        widgetSelect = _feedTipoTexto();
        break;
      case FeedType.url:
        widgetSelect = _feedTipoLink();
        break;
      case FeedType.historico:
        widgetSelect = _feedTipoHistorico();
        break;
    }

    return widgetSelect;
  }

  Widget _feedTipoLink() {
    return Container(
      child: Padding(
        padding: EdgeInsets.all(5.0),
        child: InkWell(
          hoverColor: Colors.white12,
          onTap: () {
            // Abrir url
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(width: 10),
              Icon(Icons.link),
              SizedBox(width: 20),
              Text(
                "${widget.feed.valorFeed}",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.blue[100],
                  decoration: TextDecoration.underline,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _feedTipoTexto() {
    return Container(
      child: Text(widget.feed.valorFeed),
    );
  }

  Widget _feedTipoHistorico() {
    return Container(
      child: Padding(
        padding: EdgeInsets.all(5.0),
        child: Row(
          mainAxisAlignment:MainAxisAlignment.center   ,
          children: [
            Text(
              widget.feed.valorFeed,
              style: TextStyle(color: PmsbColors.texto_secundario, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
