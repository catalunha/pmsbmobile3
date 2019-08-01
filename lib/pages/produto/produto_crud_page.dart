import 'package:flutter/material.dart';
import 'package:pmsbmibile3/bootstrap.dart';
import 'package:pmsbmibile3/pages/produto/produto_crud_page_bloc.dart';
import 'package:pmsbmibile3/state/auth_bloc.dart';
import 'package:provider/provider.dart';

class ProdutoCRUDPage extends StatefulWidget {
  final String produtoID;
  final AuthBloc authBloc;

  ProdutoCRUDPage(this.produtoID, this.authBloc);

  // @override
  @override
  State<StatefulWidget> createState() {
    return _ProdutoCRUDPageState(authBloc);
  }
}

class _ProdutoCRUDPageState extends State<ProdutoCRUDPage> {
  final ProdutoCRUDPageBloc bloc;

  _ProdutoCRUDPageState(AuthBloc authBloc)
      : bloc = ProdutoCRUDPageBloc(Bootstrap.instance.firestore, authBloc);

  @override
  void initState() {
    super.initState();
    bloc.eventSink(UpdateUsuarioIDEvent());
    bloc.eventSink(UpdateProdutoIDEvent(widget.produtoID));
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return
    //  Provider<ProdutoCRUDPageBloc>.value(
    //   value: bloc,
    //   child: 
      Scaffold(
        appBar: AppBar(
            leading: new IconButton(
              icon: new Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Text((widget.produtoID != null ? "Editar" : "Adicionar") +
                " Produto")),
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
              child: ProdutoTitulo(bloc),
            ),
            Divider(),
            Padding(
              padding: EdgeInsets.all(5.0),
              child: _DeleteDocumentOrField(bloc),
            ),
          ],
        ),
      // ),
    );
  }
}

class ProdutoTitulo extends StatefulWidget {
  final ProdutoCRUDPageBloc bloc;
  ProdutoTitulo(this.bloc);
  @override
  ProdutoTituloState createState() {
    return ProdutoTituloState(bloc);
  }
}

class ProdutoTituloState extends State<ProdutoTitulo> {
  final _textFieldController = TextEditingController();
final ProdutoCRUDPageBloc bloc;
ProdutoTituloState(this.bloc);
  @override
  Widget build(BuildContext context) {
    // final bloc = Provider.of<ProdutoCRUDPageBloc>(context);
    return StreamBuilder<ProdutoCRUDPageState>(
      stream: bloc.stateStream,
      builder:
          (BuildContext context, AsyncSnapshot<ProdutoCRUDPageState> snapshot) {
        if (_textFieldController.text.isEmpty) {
          _textFieldController.text = snapshot.data?.produtoModelIDTitulo;
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

class _DeleteDocumentOrField extends StatefulWidget {
  final ProdutoCRUDPageBloc bloc;
  _DeleteDocumentOrField(this.bloc);
  @override
  _DeleteDocumentOrFieldState createState() {
    return _DeleteDocumentOrFieldState(bloc);
  }
}

class _DeleteDocumentOrFieldState extends State<_DeleteDocumentOrField> {
  final _textFieldController = TextEditingController();
final ProdutoCRUDPageBloc bloc;
_DeleteDocumentOrFieldState(this.bloc);
  @override
  Widget build(BuildContext context) {
    // final bloc = Provider.of<ProdutoCRUDPageBloc>(context);
    return StreamBuilder<ProdutoCRUDPageState>(
      stream: bloc.stateStream,
      builder:
          (BuildContext context, AsyncSnapshot<ProdutoCRUDPageState> snapshot) {
        return Row(
          children: <Widget>[
            Divider(),
            Text('Para apagar digite CONCORDO e click:  '),
            Container(
              child: Flexible(
                child: TextField(
                  controller: _textFieldController,
                  // onChanged: (text) {
                  //   bloc.eventSink(DeleteProdutoIDEvent);
                  // },
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                //Ir para a pagina visuais do produto
                if (_textFieldController.text == 'CONCORDO') {
                bloc.eventSink(DeleteProdutoIDEvent());
                  Navigator.of(context).pop();
                }
              },
            )
          ],
        );
      },
    );
  }
}
