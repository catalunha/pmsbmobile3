import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pmsbmibile3/bootstrap.dart';
import 'package:pmsbmibile3/models/produto_model.dart';
import 'package:pmsbmibile3/models/propriedade_for_model.dart';
import 'package:pmsbmibile3/pages/produto/produto_arguments.dart';
import 'package:pmsbmibile3/pages/produto/produto_arquivo_list_page_bloc.dart';

class ProdutoArquivoListPage extends StatelessWidget {
  final String produtoID;
  final String tipo;
  final ProdutoArquivoListPageBloc bloc;

  ProdutoArquivoListPage({this.produtoID, this.tipo})
      : bloc = ProdutoArquivoListPageBloc(Bootstrap.instance.firestore) {
    bloc.eventSink(UpdateProdutoIDTipoEvent(this.produtoID, this.tipo));
  }

  void dispose() {
    bloc.dispose();
  }

  var _tituloPag = Map<String, String>();

  @override
  Widget build(BuildContext context) {
    _tituloPag['imagem'] = 'Imagens';
    _tituloPag['tabela'] = 'Tabelas';
    _tituloPag['grafico'] = 'Gráficos';
    _tituloPag['mapa'] = 'Mapas';

    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Colors.red,
        centerTitle: true,
        title: Text("${_tituloPag[tipo]} para o Produto"),
      ),
      body: _body(context),
      // body: Text('${produtoID} | ${tipo}'),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),

        onPressed: () {
          Navigator.pushNamed(context, '/produto/arquivo_crud',
              arguments: ProdutoArguments(
                  produtoID: this.produtoID, arquivoID: null, tipo: this.tipo));
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
          var arquivo = Map<String, ArquivoProduto>();

          arquivo = snapshot.data?.arquivo;
          var lista = List<Widget>();
          arquivo.forEach((k, v) {
            lista.add(_cardBuildImagem(context, k, v));
          });
          return ListView(
            children: lista,
          );
        });
  }

  Widget _cardBuildImagem(
      BuildContext context, String key, ArquivoProduto arquivo) {
    return Card(
        elevation: 10,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              title: arquivo.titulo == null
                  ? Text('Sem titulo')
                  : Text(arquivo.titulo),
                  //TODO: Comentar esta informação após testes.
              subtitle: produtoID == null
                  ? Text('Sem id')
                  : Text(produtoID+'\n'+key),
            ),
            _imagemRow(arquivo.rascunhoUrl, arquivo.rascunhoLocalPath,
                arquivo.editadoUrl, arquivo.editadoLocalPath),
            ButtonTheme.bar(
              child: ButtonBar(
                alignment: MainAxisAlignment.center,
                children: <Widget>[
                  arquivo?.rascunhoUrl != null ?
                  IconButton(
                    icon: Icon(Icons.content_copy),
                    onPressed: () {
                      String txt = '!()[${arquivo.rascunhoUrl}]';
                      Clipboard.setData(new ClipboardData(text: txt));
                    },
                  ):Container(),
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      //IR PRA PAGINA DE EDITAR VISUAL
                      Navigator.pushNamed(context, '/produto/arquivo_crud',
                          arguments: ProdutoArguments(
                              produtoID: produtoID,
                              arquivoID: key,
                              tipo: arquivo.tipo));
                    },
                  ),
                  arquivo?.editadoUrl != null ?
                  IconButton(
                    icon: Icon(Icons.content_copy),
                    onPressed: () {
                      String txt = '!()[${arquivo.editadoUrl}]';
                      Clipboard.setData(new ClipboardData(text: txt));
                    },
                  ):Container(),
                ],
              ),
            )
          ],
        ));
  }

  _imagemRow(rascunhoUrl, rascunhoLocalPath, editadoUrl, editadoLocalPath) {
    Widget rascunho;
    if (rascunhoUrl == null && rascunhoLocalPath == null) {
      rascunho = Center(child: Text('Sem imagem.'));
    } else if (rascunhoUrl != null) {
      rascunho = Image.network(rascunhoUrl);
    } else {
      rascunho = Image.asset(rascunhoLocalPath);
    }

    Widget editado;
    if (editadoUrl == null && editadoLocalPath == null) {
      editado = Center(child: Text('Sem imagem.'));
    } else if (editadoUrl != null) {
      editado = Image.network(editadoUrl);
    } else {
      editado = Image.asset(editadoLocalPath);
    }
    return Row(
      children: <Widget>[
        Expanded(
          child: rascunho,
        ),
        Expanded(
          child: editado,
        ),
      ],
    );
  }
}
