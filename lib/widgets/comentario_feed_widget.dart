import 'package:flutter/material.dart';
import 'package:pmsbmibile3/models/models_controle/anexos_model.dart';
import 'package:pmsbmibile3/models/models_controle/feed_model.dart';
import 'package:pmsbmibile3/style/pmsb_colors.dart';
import 'package:pmsbmibile3/style/pmsb_styles.dart';

class ComentarioFeedWidget extends StatefulWidget {
  final Feed feed;

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
                      '${widget.feed.usuario}',
                      style: PmsbStyles.textoSecundario,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    '${widget.feed.dataPostagem}',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                )
              ],
            ),
            SizedBox(height: 5),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: GestureDetector(child: Text('${widget.feed.corpoTexto}')),
            ),
            SizedBox(height: 5),
            _listaAnexos(),
            SizedBox(height: 5),
          ],
        ),
      ),
    );
  }

  Widget _listaAnexos() {
    List<Widget> lista = List<Widget>();

    for (Anexo anexo in widget.feed.anexos) {
      lista.add(
        Padding(
          padding: EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () {},
            child: Text(
              "${anexo.titulo}",
              style: TextStyle(
                color: Colors.blue[500],
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ),
      );
    }

    return widget.feed.anexos.length <= 0
        ? Container()
        : Container(
            child: Column(
              children: lista,
            ),
          );
  }
}
