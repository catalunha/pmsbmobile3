import 'package:flutter/material.dart';
import 'package:pmsbmibile3/models/models_controle/feed_models.dart';
import 'package:pmsbmibile3/style/pmsb_colors.dart';

class CaixaTextoFeedWidget extends StatefulWidget {
  @override
  _CaixaTextoFeedWidgetState createState() => _CaixaTextoFeedWidgetState();
}

class _CaixaTextoFeedWidgetState extends State<CaixaTextoFeedWidget> {
  FeedModel feedModel;
  TextEditingController textController;

  @override
  initState() {
    this.feedModel = new FeedModel();
    this.textController = new TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        child: Column(
          children: <Widget>[
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[botaoAdicionarLink(onTap: () {})],
            ),
            SizedBox(height: 10),
            caixaTexto(),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                RaisedButton(
                    child: Text("Salvar"),
                    color: PmsbColors.cor_destaque,
                    onPressed: () {}),
                SizedBox(width: 10),
              ],
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget caixaTexto() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: PmsbColors.card, width: 1),
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
      ),
      padding: EdgeInsets.all(10),
      child: Center(
        child: TextField(
          autofocus: false,
          style: TextStyle(color: Colors.black),
          controller: textController,
          keyboardType: TextInputType.multiline,
          maxLines: null,
          decoration: InputDecoration(
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }

  botaoAdicionarLink({Function onTap}) {
    return Container(
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          children: <Widget>[
            Text(
              "Adicionar link",
              style: TextStyle(color: PmsbColors.texto_secundario),
            ),
            SizedBox(width: 5),
            Icon(Icons.link),
            SizedBox(width: 5),
          ],
        ),
      ),
    );
  }
}
