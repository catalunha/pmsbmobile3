import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:pmsbmibile3/bootstrap.dart';
import 'package:pmsbmibile3/pages/produto/produto_texto_page_bloc.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:url_launcher/url_launcher.dart';

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
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text("Editar texto do produto"),
            bottom: TabBar(
              tabs: [
                Tab(text: "Preview"),
                Tab(text: "Texto"),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              _bodyPreview(context),
              UpDateProdutoIDTexto(bloc),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.save_alt),
            onPressed: () {
              Navigator.of(context).pop();
              bloc.eventSink(SaveProdutoTextoIDTextoEvent());
            },
          ),
        ));
  }

  _bodyPreview(context) {
    return StreamBuilder<ProdutoTextoPageState>(
        stream: bloc.stateStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Text('Sem dados');
          }
          // return Text(md.markdownToHtml(snapshot.data.produtoTextoIDTextoMarkdown));
          return Markdown(data:snapshot.data.produtoTextoIDTextoMarkdown);
        });
  }
}

class UpDateProdutoIDTexto extends StatefulWidget {
  final ProdutoTextoPageBloc bloc;
  UpDateProdutoIDTexto(this.bloc);
  @override
  State<StatefulWidget> createState() {
    return UpDateProdutoIDTextoState(bloc);
  }
}

class UpDateProdutoIDTextoState extends State<UpDateProdutoIDTexto> {
  final _controller = TextEditingController();
  final ProdutoTextoPageBloc bloc;
  UpDateProdutoIDTextoState(this.bloc);
  @override
  Widget build(BuildContext context) {
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
              Expanded(
                child: TextField(
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  controller: _controller,
                  onChanged: (produtoTexto) {
                    bloc.eventSink(
                        UpdateProdutoTextoIDTextoEvent(produtoTexto));
                  },
                ),
              )
            ],
          );
        });
  }
}
