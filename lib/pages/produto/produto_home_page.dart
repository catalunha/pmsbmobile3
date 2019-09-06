import 'package:flutter/material.dart';
import 'package:pmsbmibile3/components/default_scaffold.dart';
import 'package:pmsbmibile3/models/produto_model.dart';

import 'package:pmsbmibile3/bootstrap.dart';
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
  _ProdutoHomePageState(AuthBloc authBloc)
      : bloc = ProdutoHomePageBloc(Bootstrap.instance.firestore, authBloc);

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
                  : Text('Sem título'),
              subtitle: produto.usuarioID?.nome != null
                  ? Text(
                      'Último editor: ${produto.usuarioID?.nome}\n${produto.modificado}')
                  : Text('Sem editor'),
              trailing: IconButton(
                icon: Icon(Icons.edit),
                tooltip: 'Editar título ou apagar este produto',
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
                  icon: Icon(Icons.wrap_text),
                  tooltip: 'Editar texto',
                  onPressed: produto?.googleDocsUrl != null
                      ? () {
                          //Ir para a edição do produto,
                          launch(produto.googleDocsUrl);
                        }
                      : null,
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
      // floatingActionButton: FloatingActionButton(
      //   child: Icon(Icons.add),
      //   onPressed: () {
      //     Navigator.pushNamed(context, '/produto/crud', arguments: null);
      //   },
      //   // backgroundColor: Colors.blue,
      // ),
    );
  }
}
