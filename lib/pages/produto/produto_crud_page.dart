import 'package:flutter/material.dart';
import 'package:pmsbmibile3/bootstrap.dart';
import 'package:pmsbmibile3/models/produto_model.dart';
import 'package:pmsbmibile3/pages/produto/produto_crud_page_bloc.dart';
import 'package:pmsbmibile3/state/auth_bloc.dart';
import 'package:provider/provider.dart';

class ProdutoCRUDPage extends StatelessWidget {
  final String produtoID;
  final ProdutoCRUDPageBloc bloc;
  ProdutoCRUDPage(this.produtoID, AuthBloc authBloc)
      : bloc = ProdutoCRUDPageBloc(Bootstrap.instance.firestore, authBloc) {
    bloc.eventSink(UpdateUsuarioIDEvent());
    bloc.eventSink(UpdateProdutoIDEvent(produtoID));
  }

  _botaoDeletarDocumento(BuildContext context) {
    return SafeArea(
        child: Row(
      children: <Widget>[
        Padding(
            padding: EdgeInsets.all(5.0),
            child: RaisedButton(
                // color: Colors.red,
                onPressed: () {
                  showDialog(
                      context: context,
                      barrierDismissible: true,
                      builder: (context) {
                        return SimpleDialog(
                          children: <Widget>[
                            SimpleDialogOption(
                              child: Text("CANCELAR EXCLUSÃO"),
                              onPressed: () {
                                // Navigator.pop(context);
                                Navigator.of(context).pop();
                              },
                            ),
                            Container(
                              padding: EdgeInsets.all(20),
                            ),
                            Divider(),
                            SimpleDialogOption(
                              child: Text("sim"),
                              onPressed: () {
                                bloc.eventSink(DeleteProdutoIDEvent());
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      });
                },
                child: Row(
                  children: <Widget>[
                    // Text('Apagar notícia', style: TextStyle(fontSize: 20)),
                    Icon(Icons.delete)
                  ],
                ))),
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Provider<ProdutoCRUDPageBloc>.value(
      value: bloc,
      child: Scaffold(
        appBar: AppBar(
            leading: new IconButton(
              icon: new Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Text(
                (produtoID != null ? "Editar" : "Adicionar") + " Produto")),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.thumb_up),
          onPressed: () {
            // salvar e voltar
            bloc.eventSink(SaveProdutoIDEvent());
            Navigator.pop(context);
          },
        ),
        body: ListView(
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Text(
                    "Titulo do questionario:",
                    style: TextStyle(fontSize: 15, color: Colors.blue),
                  )),
              Padding(
                padding: EdgeInsets.all(5.0),
                child: ProdutoTitulo(),
              ),
              _botaoDeletarDocumento(context),
            ],
          ),
      ),
    );
  }
}

class ProdutoTitulo extends StatefulWidget {
  @override
  ProdutoTituloState createState() {
    return ProdutoTituloState();
  }
}

class ProdutoTituloState extends State<ProdutoTitulo> {
  final _textFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<ProdutoCRUDPageBloc>(context);
    return StreamBuilder<ProdutoCRUDPageState>(
      stream: bloc.stateStream,
      builder: (BuildContext context,
            AsyncSnapshot<ProdutoCRUDPageState> snapshot) {
        if (_textFieldController.text.isEmpty) {
          _textFieldController.text = snapshot.data?.produtoModelIDNome;
        }
        return TextField(
          keyboardType: TextInputType.multiline,
          maxLines: null,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
          ),
          controller: _textFieldController,
          onChanged: (text) {
            bloc.eventSink(UpdateProdutoIDNomeEvent(text));
          },
        );
      },
    );
  }
}
