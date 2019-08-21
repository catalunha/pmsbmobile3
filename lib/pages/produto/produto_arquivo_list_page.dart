import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pmsbmibile3/bootstrap.dart';
import 'package:pmsbmibile3/models/propriedade_for_model.dart';
import 'package:pmsbmibile3/pages/produto/produto_arguments.dart';
import 'package:pmsbmibile3/pages/produto/produto_arquivo_list_page_bloc.dart';


class ProdutoArquivoListPage extends StatefulWidget {
  final String produtoID;
  final String tipo;
  ProdutoArquivoListPage({this.produtoID, this.tipo});

  _ProdutoArquivoListPageState createState() => _ProdutoArquivoListPageState();
}

class _ProdutoArquivoListPageState extends State<ProdutoArquivoListPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//        child: child,
//     );
//   }
// }


// class ProdutoArquivoListPage extends StatelessWidget {
  // final String produtoID;
  // final String tipo;
  final ProdutoArquivoListPageBloc bloc = ProdutoArquivoListPageBloc(Bootstrap.instance.firestore);

  // ProdutoArquivoListPage({this.produtoID, this.tipo})
  //     : bloc = ProdutoArquivoListPageBloc(Bootstrap.instance.firestore) {
  //   bloc.eventSink(UpdateProdutoIDTipoEvent(this.produtoID, this.tipo));
  // }

@override
void initState() { 
  super.initState();
      bloc.eventSink(UpdateProdutoIDTipoEvent(widget.produtoID, widget.tipo));

}

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
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
        title: Text("${_tituloPag[widget.tipo]} para o produto"),
      ),
      body: _body(context),
      // body: Text('${produtoID} | ${tipo}'),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),

        onPressed: () {
          Navigator.pushNamed(context, '/produto/arquivo_crud',
              arguments: ProdutoArguments(
                  produtoID: widget.produtoID, arquivoID: null, tipo: widget.tipo));
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
              child: Text("Sem arquivo do tipo ${widget.tipo} na lista."),
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
              subtitle: widget.produtoID == null
                  ? Text('Sem id')
                  : Text(widget.produtoID + '\n' + key),
            ),
            ParDeImagens(
                rascunhoUrl: arquivo.rascunhoUrl,
                rascunhoLocalPath: arquivo.rascunhoLocalPath,
                editadoUrl: arquivo.editadoUrl,
                editadoLocalPath: arquivo.editadoLocalPath),
            ButtonTheme.bar(
              child: ButtonBar(
                alignment: MainAxisAlignment.center,
                children: <Widget>[
                  arquivo?.rascunhoUrl != null
                      ? IconButton(
                          icon: Icon(Icons.content_copy),
                          tooltip:
                              'Click para copiar e colar o caminho desta imagem no produto',
                          onPressed: () {
                            String txt = '![](${arquivo.rascunhoUrl})';
                            Clipboard.setData(new ClipboardData(text: txt));
                          },
                        )
                      : Container(),
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      //IR PRA PAGINA DE EDITAR VISUAL
                      Navigator.pushNamed(context, '/produto/arquivo_crud',
                          arguments: ProdutoArguments(
                              produtoID: widget.produtoID,
                              arquivoID: key,
                              tipo: arquivo.tipo));
                    },
                  ),
                  arquivo?.editadoUrl != null
                      ? IconButton(
                          icon: Icon(Icons.content_copy),
                          tooltip:
                              'Click para copiar e colar o caminho desta imagem no produto',
                          onPressed: () {
                            String txt = '![](${arquivo.editadoUrl})';
                            Clipboard.setData(new ClipboardData(text: txt));
                          },
                        )
                      : Container(),
                ],
              ),
            )
          ],
        ));
  }
}

class ParDeImagens extends StatelessWidget {
  final String rascunhoUrl;
  final String rascunhoLocalPath;
  final String editadoUrl;
  final String editadoLocalPath;

  const ParDeImagens(
      {this.rascunhoUrl,
      this.rascunhoLocalPath,
      this.editadoUrl,
      this.editadoLocalPath});

  @override
  Widget build(BuildContext context) {
    Widget rascunho;
    if (rascunhoUrl == null && rascunhoLocalPath == null) {
      rascunho = Center(child: Text('Sem imagem.'));
    } else if (rascunhoUrl != null) {
      rascunho = Container(
          child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Image.network(rascunhoUrl),
      ));
    } else {
      bool rascunhoLocalPathExiste = File(rascunhoLocalPath).existsSync();
      if (rascunhoLocalPathExiste) {
        rascunho = Container(
            color: Colors.yellow,
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: Image.asset(rascunhoLocalPath),
            ));
      } else {
        rascunho = Container(
            color: Colors.yellow,
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: Text('Editor nao fez upload'),
            ));
      }
    }

    Widget editado;
    if (editadoUrl == null && editadoLocalPath == null) {
      editado = Center(child: Text('Sem imagem.'));
    } else if (editadoUrl != null) {
      editado = Container(
          child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Image.network(editadoUrl),
      ));
    } else {
      bool editadoLocalPathExiste = File(editadoLocalPath).existsSync();
      if (editadoLocalPathExiste) {
        editado = Container(
            color: Colors.yellow,
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: Image.asset(editadoLocalPath),
            ));
      } else {
        editado = Container(
            color: Colors.yellow,
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: Text('Editor nao fez upload'),
            ));
      }
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
