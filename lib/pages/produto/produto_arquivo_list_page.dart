import 'package:flutter/material.dart';
import 'package:pmsbmibile3/bootstrap.dart';
import 'package:pmsbmibile3/models/produto_model.dart';
import 'package:pmsbmibile3/models/propriedade_for_model.dart';
import 'package:pmsbmibile3/pages/produto/produto_arguments.dart';
import 'package:pmsbmibile3/pages/produto/produto_arquivo_list_page_bloc.dart';

class ProdutoArquivoListPage extends StatelessWidget {
  final String produtoID;
  final String tipo;
  final ProdutoArquivoListPageBloc bloc;

  ProdutoArquivoListPage({this.produtoID,this.tipo}): bloc = ProdutoArquivoListPageBloc(Bootstrap.instance.firestore) {
    bloc.eventSink(UpdateProdutoIDTipoEvent(this.produtoID,this.tipo));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Colors.red,
        centerTitle: true,
        title:  Text("Imagens para o Produto"),
      ),
      body: _body(context),
      // body: Text('${produtoID} | ${tipo}'),
      floatingActionButton: FloatingActionButton(

        child: Icon(Icons.add),
        
        onPressed: () {
          Navigator.pushNamed(context, '/produto/arquivo_crud',
              arguments:
                  ProdutoArguments(produtoID: this.produtoID, arquivoID: null,tipo: this.tipo));
        },
        // backgroundColor: Colors.blue,
      ),
    );
  }

  _body(BuildContext context) {
    return StreamBuilder<ProdutoArquivoListPageState>(
        stream: bloc.stateStream,
        builder: (BuildContext context,
            AsyncSnapshot<ProdutoArquivoListPageState> snapshot) {
          if (snapshot.hasError)
            return Center(
              child: Text("Erro. Informe ao administrador do aplicativo"),
            );
          if (snapshot.data?.arquivo == null) {
            return Center(
              child: Text("Sem arquivo do tipo ${tipo} na lista."),
            );
          }
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          var keys;
          var values;
          if (snapshot.data.arquivo != null) {
            keys = snapshot.data.arquivo.keys.toList();
            keys = snapshot.data.arquivo[keys[idx]];
          }

          return ListView(
            children: arquivos.map((k,v)=>_cardBuildImagem(context,v))),
          );
        });
  }

  Widget _cardBuildImagem(BuildContext context, Imagem imagem) {
    return Card(
        elevation: 10,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              title: Text(imagem.titulo),
            ),
            _imagemRow(
                'http://man.hubwiz.com/docset/Ionic.docset/Contents/Resources/Documents/ionicframework.com/img/docs/symbols/docs-components-symbol%402x.png',
                'http://man.hubwiz.com/docset/Ionic.docset/Contents/Resources/Documents/ionicframework.com/img/docs/symbols/docs-ionicons-symbol%402x.png'),
            ButtonTheme.bar(
              child: ButtonBar(
                alignment: MainAxisAlignment.center,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      //IR PRA PAGINA DE EDITAR VISUAL
                      Navigator.pushNamed(context, '/produto/imagem_crud',
                          arguments: ProdutoArguments(
                              produtoID: produtoID, arquivoID: imagem.id));
                    },
                  ),
                ],
              ),
            )
          ],
        ));
  }

  _imagem(String link) {
    return Image.network(
      link,
      // width: 300,
      // height: 400,
      // fit: BoxFit.scaleDown,
    );
  }

  _imagemRow(linkracunho, linkeditado) {
    return Row(
      children: <Widget>[
        Expanded(
          child: _imagem(linkracunho),
        ),
        Expanded(
          child: _imagem(linkeditado),
        ),
      ],
    );
  }


}
