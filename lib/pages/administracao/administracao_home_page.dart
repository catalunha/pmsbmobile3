import 'package:flutter/material.dart';
import 'package:pmsbmibile3/components/square_image.dart';
//import 'package:pmsbmibile3/models/usuario_model.dart';
import 'package:pmsbmibile3/models/usuario_model2.dart';
import 'administracao_home_page_bloc.dart';
import 'package:pmsbmibile3/bootstrap.dart';

class AdministracaoHomePage extends StatelessWidget {
  final bloc = AdministracaoHomePageBloc(Bootstrap.instance.firestore);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        centerTitle: true,
        title: Text("Administração"),
      ),
      body: Container(
        child: StreamBuilder<List<UsuarioModel>>(
            stream: bloc.usuarioModelListStream,
            initialData: [],
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text("Erro"),
                );
              }
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              return ListView(
                children: snapshot.data
                    .map((usuario) => ItemListView(usuario))
                    .toList(),
              );
            }),
      ),
    );
  }
}

class ItemListView extends StatelessWidget {
  final UsuarioModel usuario;

  ItemListView(this.usuario);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, "/administracao/perfil",
            arguments: usuario.id);
      },
      child: Card(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                  flex: 2,
                  child: SquareImage(
                    image: NetworkImage(usuario.usuarioArquivoID.url),
                  )),
              Expanded(
                flex: 5,
                child: Container(
                  padding: EdgeInsets.only(left: 6),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("ID: ${usuario.id.substring(0,5)}"),
                      Text("Nome: ${usuario.nome}"),
                      Text("Celular: ${usuario.celular}"),
                      Text("Email: ${usuario.email}"),
                      Text("Eixo: ${usuario.eixoIDAtual.nome}"),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
