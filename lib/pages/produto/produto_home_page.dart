import 'package:flutter/material.dart';
import 'package:pmsbmibile3/components/default_scaffold.dart';
import 'package:pmsbmibile3/models/produto_model.dart';

import 'package:pmsbmibile3/bootstrap.dart';
import 'package:pmsbmibile3/pages/page_arguments.dart';
import 'package:pmsbmibile3/pages/produto/produto_arguments.dart';
import 'package:pmsbmibile3/pages/produto/produto_home_page_bloc.dart';
import 'package:pmsbmibile3/state/auth_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class ProdutoHomePage extends StatefulWidget {
AuthBloc authBloc;
  ProdutoHomePage(this.authBloc);

  _ProdutoHomePageState createState() => _ProdutoHomePageState(this.authBloc);
}

class _ProdutoHomePageState extends State<ProdutoHomePage> {
final ProdutoHomePageBloc bloc;
    _ProdutoHomePageState( AuthBloc authBloc): bloc = ProdutoHomePageBloc(Bootstrap.instance.firestore, authBloc);
  //   @override
//   Widget build(BuildContext context) {
//     return Container(
//        child: child,
//     );
//   }
// }

// class ProdutoHomePage extends StatelessWidget {
  // final ProdutoHomePageBloc bloc;

  // ProdutoHomePage(AuthBloc authBloc)
  //     : bloc = ProdutoHomePageBloc(Bootstrap.instance.firestore, authBloc) {
  //   // bloc.eventSink(UpdateUsuarioIDEvent());
  // }

  @override
  void initState() { 
    super.initState();
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
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
              title: produto.titulo != null
                  ? Text(produto.titulo)
                  : Text('Sem titulo'),
              subtitle: produto.usuarioID?.nome != null
                  ? Text(
                      'Último editor: ${produto.usuarioID?.nome}\n${produto.modificado}')
                  : Text('Sem editor'),
              trailing: IconButton(
                icon: Icon(Icons.edit),
                tooltip: 'Editar titulo ou apagar este produto',
                onPressed: () {
                  //Ir a pagina de Adicionar ou editar Produtos
                  Navigator.pushNamed(context, '/produto/crud',
                      arguments: produto.id);
                },
              ),
            ),
            // ButtonTheme.bar(
            //   child:
            Wrap(
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.text_fields),
                  tooltip: 'Editar texto do produto',
                  onPressed: () {
                    //Ir para a pagina visuais do produto
                    Navigator.pushNamed(context, '/produto/texto',
                        arguments: produto.id);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.image),
                  tooltip: 'Gerenciar imagens para este produto',
                  onPressed: () {
                    Navigator.pushNamed(context, '/produto/arquivo_list',
                        arguments: ProdutoArguments(
                            produtoID: produto.id, tipo: 'imagem'));
                  },
                ),
                IconButton(
                  icon: Icon(Icons.border_bottom),
                  tooltip: 'Gerenciar tabelas para este produto',
                  onPressed: () {
                    Navigator.pushNamed(context, '/produto/arquivo_list',
                        arguments: ProdutoArguments(
                            produtoID: produto.id, tipo: 'tabela'));
                  },
                ),
                IconButton(
                  icon: Icon(Icons.insert_chart),
                  tooltip: 'Gerenciar gráficos para este produto',
                  onPressed: () {
                    Navigator.pushNamed(context, '/produto/arquivo_list',
                        arguments: ProdutoArguments(
                            produtoID: produto.id, tipo: 'grafico'));
                  },
                ),
                IconButton(
                  icon: Icon(Icons.location_on),
                  tooltip: 'Gerenciar mapas para este produto',
                  onPressed: () {
                    Navigator.pushNamed(context, '/produto/arquivo_list',
                        arguments: ProdutoArguments(
                            produtoID: produto.id, tipo: 'mapa'));
                  },
                ),
                IconButton(
                  icon: Icon(Icons.message),
                  tooltip: 'chat para o produto',
                  onPressed: () {
                    Navigator.pushNamed(context, '/chat/home',
                        arguments: ChatPageArguments(
                            chatID: produto.id,
                            modulo:
                                'P: ${produto.eixoID.nome}. \nS: ${produto.setorCensitarioID.nome}',
                            titulo: 'T: ${produto.titulo}. '));
                  },
                ),
                IconButton(
                  icon: Icon(Icons.picture_as_pdf),
                  tooltip: 'PDF finalizado do produto.',
                  onPressed: produto.pdf?.url != null
                      ? () {
                          launch(produto.pdf?.url);
                        }
                      : null,
                ),
              ],
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
    return DefaultScaffold(
      title: Text("Produto"),
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
