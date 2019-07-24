import 'package:flutter/material.dart';
import 'package:pmsbmibile3/models/produto_model.dart';

import 'package:pmsbmibile3/bootstrap.dart';
import 'package:pmsbmibile3/pages/produto/produto_arguments.dart';
import 'package:pmsbmibile3/pages/produto/produto_home_page_bloc.dart';
import 'package:pmsbmibile3/state/auth_bloc.dart';

class ProdutoHomePage extends StatelessWidget {
  final ProdutoHomePageBloc bloc;

  ProdutoHomePage(AuthBloc authBloc)
      : bloc = ProdutoHomePageBloc(Bootstrap.instance.firestore, authBloc) {
    // bloc.eventSink(UpdateUsuarioIDEvent());
  }
 void dispose() {
    bloc.dispose();
  }
  
  _listaProdutos(BuildContext context) {
    return StreamBuilder<List<ProdutoModel>>(
        stream: bloc.produtoModelListStream,
        builder:
            (BuildContext context, AsyncSnapshot<List<ProdutoModel>> snapshot) {
          if (snapshot.hasError)
            return Center(
              child: Text("Erro. Informe ao administrador do aplicativo"),
            );
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.data.isEmpty) {
            return Center(
              child: Text("Nenhum produto criado."),
            );
          }

          return ListView(
            children: snapshot.data
                .map((produto) => _cardBuildProduto(context, produto))
                .toList(),
          );
        });
  }

  Widget _cardBuildProduto(BuildContext context, ProdutoModel produto) {
    return Card(
        elevation: 10,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              title: Text(produto.nome),
              trailing: IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  //Ir a pagina de Adicionar ou editar Produtos
                  Navigator.pushNamed(context, '/produto/crud',
                      arguments: produto.id);
                },
              ),
            ),
            ButtonTheme.bar(
              child: ButtonBar(
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.text_fields),
                    onPressed: () {
                      //Ir para a pagina visuais do produto
                      Navigator.pushNamed(context, '/produto/texto',
                          arguments: produto.id);
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.note_add),
                    onPressed: () {
                      // Navigator.pushNamed(context, '/produto/imagem',
                      //     arguments: produto.id);
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.image),
                    onPressed: () {
                      Navigator.pushNamed(context, '/produto/arquivo_list',
                          arguments: ProdutoArguments(
                              produtoID: produto.id, tipo: 'imagem'));
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.border_bottom),
                    onPressed: () {
                      // Navigator.pushNamed(context, '/produto/tabela',
                      //     arguments: produto.id);
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.insert_chart),
                    onPressed: () {
                      // Navigator.pushNamed(context, '/produto/grafico',
                      //     arguments: produto.id);
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.zoom_out_map),
                    onPressed: () {
                      // Navigator.pushNamed(context, '/produto/mapa',
                      //     arguments: produto.id);
                    },
                  ),
                ],
              ),
            )
          ],
        ));
  }

  Widget _body(BuildContext context) {
    return Column(
      children: <Widget>[
        StreamBuilder<ProdutoHomePageState>(
          stream: bloc.stateStream,
          builder: (BuildContext context,
              AsyncSnapshot<ProdutoHomePageState> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: snapshot.data?.usuarioModel?.eixoIDAtual?.nome != null
                      ? Text(
                          "Eixo: ${snapshot.data.usuarioModel.eixoIDAtual.nome}",
                          style: TextStyle(fontSize: 16, color: Colors.blue),
                        )
                      : Text('...'),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: snapshot.data?.usuarioModel?.setorCensitarioID?.nome !=
                          null
                      ? Text(
                          "Setor: ${snapshot.data.usuarioModel.setorCensitarioID.nome}",
                          style: TextStyle(fontSize: 16, color: Colors.blue),
                        )
                      : Text('...'),
                ),
              ],
            );
          },
        ),
        Expanded(child: _listaProdutos(context))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Colors.red,
        centerTitle: true,
        title: Text("Produto"),
      ),
      body: _body(context),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamed(context, '/produto/crud', arguments: null);
        },
        // backgroundColor: Colors.blue,
      ),
    );
  }
}

// return Builder(
//     builder: (BuildContext context) => new Container(
//           child: _produtos.length >= 0
//               ? new ListView.builder(
//                   itemCount: _produtos.length,
//                   itemBuilder: (BuildContext context, int index) {
//                     return Card(
//                         elevation: 10,
//                         child: Column(
//                           mainAxisSize: MainAxisSize.min,
//                           children: <Widget>[
//                             ListTile(
//                               title: Text(_produtos[index]),
//                             ),
//                             ButtonTheme.bar(
//                               child: ButtonBar(
//                                 children: <Widget>[
//                                   IconButton(
//                                     icon: Icon(Icons.print),
//                                     onPressed: () {
//                                       // Gerar pdf do produto e imprimir
//                                     },
//                                   ),
//                                   IconButton(
//                                     icon: Icon(Icons.attach_file),
//                                      onPressed: () {
//                                        //Ir para a pagina visuais do produto
//                                        Navigator.pushNamed(context, '/produto/visual');
//                                      },
//                                   ),
//                                   IconButton(
//                                     icon: Icon(Icons.edit),
//                                      onPressed: () {
//                                        //Ir a pagina de Adicionar ou editar Produtos
//                                        Navigator.pushNamed(context, '/produto/adicionar_editar');
//                                      },
//                                   ),
//                                 ],
//                               ),
//                             )
//                           ],
//                         ));
//                   })
//               : Container(),
//         ));
