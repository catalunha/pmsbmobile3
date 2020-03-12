import 'package:flutter/material.dart';
import 'package:pmsbmibile3/components/default_scaffold.dart';
import 'package:pmsbmibile3/components/preambulo.dart';
import 'package:pmsbmibile3/models/produto_model.dart';

import 'package:pmsbmibile3/bootstrap.dart';
import 'package:pmsbmibile3/pages/produto/produto_home_page_bloc.dart';
import 'package:pmsbmibile3/state/auth_bloc.dart';
import 'package:pmsbmibile3/naosuportato/url_launcher.dart'
    if (dart.library.io) 'package:url_launcher/url_launcher.dart';
import 'package:pmsbmibile3/style/pmsb_colors.dart';
import 'package:pmsbmibile3/style/pmsb_styles.dart';

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
      color: PmsbColors.card,
      elevation: 10,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            title: produto.titulo != null
                ? Text(
                    produto.titulo,
                    style: PmsbStyles.textoPrimario,
                  )
                : Text(
                    'Sem titulo',
                    style: PmsbStyles.textoPrimario,
                  ),
            subtitle: produto.usuarioID?.nome != null
                ? Text(
                    'Último editor: ${produto.usuarioID?.nome}\n${produto.modificado}',
                    style: PmsbStyles.textoSecundario,
                  )
                : Text(
                    'Sem editor',
                    style: PmsbStyles.textoSecundario,
                  ),
          ),
          Wrap(
            children: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.link,
                  color: Colors.red,
                ),
                tooltip: 'Editar texto',
                onPressed: produto?.googleDrive?.arquivoID != null
                    ? () {
                        launch(produto?.googleDrive?.url());
                      }
                    : null,
              ),
              IconButton(
                icon: Icon(
                  Icons.picture_as_pdf,
                  color: Colors.green,
                ),
                tooltip: 'PDF finalizado do produto.',
                onPressed: produto.pdf?.url != null
                    ? () {
                        launch(produto.pdf?.url);
                      }
                    : null,
              ),
              IconButton(
                icon: Icon(
                  Icons.edit,
                  color: Colors.blue,
                ),
                tooltip: 'Editar titulo ou apagar este produto',
                onPressed: () {
                  Navigator.pushNamed(context, '/produto/crud',
                      arguments: produto.id);
                },
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _body(BuildContext context) {
    return Container(
      color: PmsbColors.fundo,
      child: Column(
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
                  Preambulo(
                    eixo: true,
                    setor: true,
                  ),
                  // Padding(
                  //   padding: EdgeInsets.only(top: 10),
                  //   child: snapshot.data?.usuarioModel?.eixoIDAtual?.nome != null
                  //       ? Text(
                  //           "Eixo: ${snapshot.data.usuarioModel.eixoIDAtual.nome}",
                  //           style: TextStyle(fontSize: 16, color: Colors.blue),
                  //         )
                  //       : Text('...'),
                  // ),
                  // Padding(
                  //   padding: EdgeInsets.only(bottom: 10),
                  //   child: snapshot.data?.usuarioModel?.setorCensitarioID?.nome !=
                  //           null
                  //       ? Text(
                  //           "Setor: ${snapshot.data.usuarioModel.setorCensitarioID.nome}",
                  //           style: TextStyle(fontSize: 16, color: Colors.blue),
                  //         )
                  //       : Text('...'),
                  // ),
                ],
              );
            },
          ),
          Expanded(child: _listaProdutos(context))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultScaffold(
      title: Text("Produto"),
      body: _body(context),
      floatingActionButton: FloatingActionButton(
        backgroundColor: PmsbColors.cor_destaque,
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamed(context, '/produto/crud', arguments: null);
        },
      ),
    );
  }
}
