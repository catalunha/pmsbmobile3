import 'package:flutter/material.dart';

class ProdutoImagemCRUDPage extends StatefulWidget {
final String produtoID;

  // final bloc = ProdutoTextoPageBloc(Bootstrap.instance.firestore);

  ProdutoImagemCRUDPage(this.produtoID){
    // bloc.eventSink(UpdateProdutoIDEvent(this.produtoID));
  }

  @override
  _ProdutoImagemCRUDPageState createState() => _ProdutoImagemCRUDPageState();
}

class _ProdutoImagemCRUDPageState extends State<ProdutoImagemCRUDPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Center(
      child: Text(widget.produtoID),
    ));
  }
}
