import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:pmsbmibile3/bootstrap.dart';
import 'package:pmsbmibile3/models/produto_model.dart';
// import 'package:pmsbmibile3/pages/produto/produto_bloc.dart';
import 'package:pmsbmibile3/pages/produto/produto_crud_page_bloc.dart';
import 'package:provider/provider.dart';

class ProdutoCRUDPage extends StatefulWidget {
  final String produtoID;
  final bloc = ProdutoCRUDPageBloc(Bootstrap.instance.firestore);

  ProdutoCRUDPage(this.produtoID);

  // @override
  // _ProdutoCRUDPageState createState() => _ProdutoCRUDPageState();
  @override
  State<StatefulWidget> createState() {
    return _ProdutoCRUDPageState();
  }
}

class _ProdutoCRUDPageState extends State<ProdutoCRUDPage> {
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    widget.bloc.eventSink(UpdateProdutoIDEvent(widget.produtoID));
  }

  @override
  void dispose() {
    widget.bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Provider<ProdutoCRUDPageBloc>.value(
        value: widget.bloc,
        child: Scaffold(
          appBar: AppBar(
            title: Text("Adicionar ou editar produto"),
            backgroundColor: Colors.red,
          ),
          body: Container(
            child: Column(
              children: <Widget>[
                // UpDateProdutoIDNome(),
                StreamBuilder<ProdutoCRUDPageState>(
                    stream: widget.bloc.stateStream,
                    builder: (BuildContext context,
                        AsyncSnapshot<ProdutoCRUDPageState> snapshot) {
                      if (_controller.text == null ||
                          _controller.text.isEmpty) {
                        _controller.text = snapshot.data?.produtoModel?.nome;
                      }
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text("Atualizar nome do produto"),
                          TextField(
                            maxLines: null,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                            controller: _controller,
                            onChanged: (nomeProduto) {
                              widget.bloc.eventSink(
                                  UpdateProdutoIDNomeEvent(nomeProduto));
                            },
                          ),
                        ],
                      );
                    }),
                _botaoDeletarDocumento(context),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.save_alt),
            onPressed: () {
              widget.bloc.eventSink(SaveProdutoIDEvent());
              Navigator.of(context).pop();

              // Navigator.pushNamed(context, '/produto/crud_texto');
            },
            // backgroundColor: Colors.blue,
          ),
        ));
  }

  Widget _botaoDeletarDocumento(BuildContext context) {
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
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text("CANCELAR EXCLUSÃO"),
                            ),
                            Container(
                              padding: EdgeInsets.all(20),
                            ),
                            Divider(),
                            SimpleDialogOption(
                              onPressed: () {
                                widget.bloc.eventSink(DeleteProdutoIDEvent());
                                Navigator.pushNamed(context, '/produto/home');
                              },
                              child: Text("sim"),
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
}

// class UpDateProdutoIDNome extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() {
//     return UpDateProdutoIDNomeState();
//   }
// }

// class UpDateProdutoIDNomeState extends State<UpDateProdutoIDNome> {
//   final _controller = TextEditingController();
//   @override
//   Widget build(BuildContext context) {
//     final bloc = Provider.of<ProdutoCRUDPageBloc>(context);
//     return StreamBuilder<ProdutoCRUDPageState>(
//         stream: bloc.produtoCRUDPageStateStream,
//         builder: (BuildContext context,
//             AsyncSnapshot<ProdutoCRUDPageState> snapshot) {
//           if (_controller.text == null || _controller.text.isEmpty) {
//             _controller.text = snapshot.data?.produtoModel?.nome;
//           }
//           return Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: <Widget>[
//               Text("Atualizar nome do produto"),
//               TextField(
//                 maxLines: null,
//                 decoration: InputDecoration(
//                   border: OutlineInputBorder(),
//                 ),
//                 controller: _controller,
//                 onChanged: (nomeProduto) {
//                   bloc.produtoCRUDPageEventSink(
//                       UpdateProdutoIDNomeEvent(nomeProduto));
//                 },
//               ),
//             ],
//           );
//         });
//   }
// }
