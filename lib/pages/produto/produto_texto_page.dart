import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:pmsbmibile3/bootstrap.dart';
import 'package:pmsbmibile3/models/produto_model.dart';
import 'package:pmsbmibile3/pages/produto/produto_texto_page_bloc.dart';
import 'package:provider/provider.dart';

class ProdutoTextoPage extends StatefulWidget {
  final String produtoID;

  ProdutoTextoPage(this.produtoID);

  @override
  State<StatefulWidget> createState() {
    return _ProdutoTextoPageState();
  }
}

class _ProdutoTextoPageState extends State<ProdutoTextoPage> {
  String textoMarkdownLocal;
  final bloc = ProdutoTextoPageBloc(Bootstrap.instance.firestore);

  @override
  void initState() {
    super.initState();
    bloc.eventSink(UpdateProdutoIDEvent(widget.produtoID));
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Provider<ProdutoTextoPageBloc>.value(
            value: bloc,
            child: Scaffold(
              appBar: AppBar(
                title: Text("Editar texto do produto"),
                // backgroundColor: Colors.red,
                bottom: TabBar(
                  tabs: [
                    Tab(text: "Preview"),
                    Tab(text: "Texto"),
                  ],
                ),
              ),
              body: TabBarView(
                children: [
                  // Tab(text: "Dados"),
                  _bodyPreview(context),
                  UpDateProdutoIDTexto(),

                  // ViewProdutoIDTexto(),
                  // _bodyTexto(),
                  // _bodyPreview(context)
                ],
              ),
              floatingActionButton: FloatingActionButton(
                child: Icon(Icons.save_alt),
                onPressed: () {
                  Navigator.of(context).pop();
                  bloc.eventSink(SaveProdutoTextoIDTextoEvent());

                  // Navigator.pushNamed(context, '/produto/crud_texto');
                },
                // backgroundColor: Colors.blue,
              ),
            )));
  }

  _bodyPreview(context) {
    return StreamBuilder<ProdutoTextoPageState>(
        stream: bloc.stateStream,
        builder: (context, snapshot) {
          // if (snapshot.hasData) {
          //   myController.text = snapshot.data.produtoTextoIDTextoMarkdown;
          // }
          if (!snapshot.hasData) {
            return Text('Sem dados');
          }
          return Markdown(data: snapshot.data.produtoTextoIDTextoMarkdown);
        });
  }
}

class UpDateProdutoIDTexto extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return UpDateProdutoIDTextoState();
  }
}

class UpDateProdutoIDTextoState extends State<UpDateProdutoIDTexto> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<ProdutoTextoPageBloc>(context);
    return StreamBuilder<ProdutoTextoPageState>(
        stream: bloc.stateStream,
        builder: (BuildContext context,
            AsyncSnapshot<ProdutoTextoPageState> snapshot) {
          if (_controller.text == null || _controller.text.isEmpty) {
            _controller.text = snapshot.data?.produtoTextoIDTextoMarkdown;
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Text("Atualizar nome no produto"),
              TextField(
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
                controller: _controller,
                onChanged: (produtoTexto) {
                  bloc.eventSink(UpdateProdutoTextoIDTextoEvent(produtoTexto));
                },
              ),
            ],
          );
        });
  }
}

// class ViewProdutoIDTexto extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() {
//     return ViewProdutoIDTextoState();
//   }
// }

// class ViewProdutoIDTextoState extends State<ViewProdutoIDTexto> {
//   // final _controller = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     final bloc = Provider.of<ProdutoTextoPageBloc>(context);
//     return StreamBuilder<ProdutoTextoPageState>(
//         stream: bloc.stateStream,
//         builder: (BuildContext context,
//             AsyncSnapshot<ProdutoTextoPageState> snapshot) {
//           if (snapshot.hasError)
//             return Center(
//               child: Text("Erro. Informe ao administrador do aplicativo"),
//             );
//           if (!snapshot.hasData) {
//             return Center(
//               child: Text("Texto vazio."),
//             );
//           }
//           if (snapshot.data == null) {
//             return Center(
//               child: Text("snapshot.data == null"),
//             );
//           }
//           if (snapshot.data.produtoTextoIDTextoMarkdown == null) {
//             return Center(
//               child: Text("snapshot.data.texto == null."),
//             );
//           }
//           return Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: <Widget>[
//               // Text("teste"),
//               Text('${snapshot.data.produtoTextoIDTextoMarkdown}'),
//               // Markdown(data: snapshot.data.produtoTextoIDTextoMarkdown),

//               // snapshot.data.produtoTextoIDTexto != null ?
//               // Markdown(data: snapshot.data.produtoTextoIDTexto):Text("Erro. Informar a equipe de desenvolvimento."),
//             ],
//           );
//         });
//   }
// }
