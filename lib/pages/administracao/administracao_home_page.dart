import 'package:flutter/material.dart';
import 'package:pmsbmibile3/components/square_image.dart';
import 'package:pmsbmibile3/models/perfis_usuarios_model.dart';
import 'administracao_home_page_bloc.dart';

class AdministracaoHomePage extends StatelessWidget {
  final bloc = AdministracaoHomePageBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        centerTitle: true,
        title: Text("Administração"),
      ),
      body: Container(
        child: StreamBuilder<List<PerfilUsuarioModel>>(
            stream: bloc.usuarios,
            initialData: [],
            builder: (context, snapshot) {
              return ListView(
                children: snapshot.data.map((usuario)=>PerfilUsuarioItem(usuario)).toList(),
              );
            }),
      ),
    );
  }
}

class PerfilUsuarioItem extends StatelessWidget{
  final PerfilUsuarioModel usuario;

  PerfilUsuarioItem(this.usuario);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.pushNamed(context, "/administracao/perfil", arguments: usuario.id);
      },
      child: Card(
        child: Container(
          padding: EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 12
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                  flex: 3,
                  child: SquareImage(
                    image: NetworkImage(usuario.imagemPerfilUrl),
                  )),
              Expanded(
                flex: 5,
                child: Container(
                  padding: EdgeInsets.only(left: 6),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("Nome: ${usuario.nomeProjeto}"),
                      Text("Celular: ${usuario.celular}"),
                      Text("Email: ${usuario.email}"),
                      Text("Eixo: ${usuario.eixo != null ? usuario.eixo : "nada"}"),
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
