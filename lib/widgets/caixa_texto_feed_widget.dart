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
  Widget caixaDeEntrada;
  bool entrada;

  @override
  initState() {
    this.entrada = true;
    this.caixaDeEntrada = caixaTexto();
    this.textController = new TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[botaoAdicionarLink()],
            ),
            SizedBox(height: 10),
            this.caixaDeEntrada,
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

  Widget caixaTextoLink() {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 5),
          Text("Descrição link:"),
          SizedBox(height: 5),
          Container(
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: PmsbColors.card, width: 1),
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
            ),
            padding: EdgeInsets.all(10),
            child: TextField(
              style: TextStyle(color: Colors.black),
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
                border: InputBorder.none,
              ),
            ),
          ),
          SizedBox(height: 5),
          Text("Link:"),
          SizedBox(height: 5),
          Container(
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: PmsbColors.card, width: 1),
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
            ),
            padding: EdgeInsets.all(10),
            child: TextField(
              style: TextStyle(color: Colors.black),
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
                border: InputBorder.none,
              ),
            ),
          ),
          SizedBox(height: 5),
        ],
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

  botaoAdicionarLink() {
    return Container(
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: InkWell(
          onTap: () {
            setState(() {
              this.entrada = !this.entrada;
              this.caixaDeEntrada = this.entrada ? this.caixaTexto() : this.caixaTextoLink();
            });
          },
          child: Row(
            children: <Widget>[
              SizedBox(width: 5),
              Text(
                this.entrada ? "Adicionar Link" : "Adicionar Comentario",
                style: TextStyle(color: PmsbColors.texto_secundario),
              ),
              SizedBox(width: 5),
              Icon( this.entrada ? Icons.link : Icons.text_fields),
              SizedBox(width: 5),
            ],
          ),
        ),
      ),
    );
  }
}
