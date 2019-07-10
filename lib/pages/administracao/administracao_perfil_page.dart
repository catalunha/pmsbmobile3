import 'package:flutter/material.dart';
import 'package:pmsbmibile3/components/square_image.dart';
import 'package:pmsbmibile3/models/perfis_usuarios_model.dart';
import 'package:pmsbmibile3/models/variaveis_usuarios_model.dart';
import 'administracao_perfil_page_bloc.dart';

class AdministracaoPerfilPage extends StatelessWidget {
  final bloc = AdministracaoPerfilPageBloc();

  @override
  Widget build(BuildContext context) {
    var usuarioId = ModalRoute.of(context).settings.arguments;
    if (usuarioId != null) {
      bloc.dispatch(UpdateUsuarioIdEvent(usuarioId));
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        centerTitle: true,
        title: Text("Visualizar dados e perfil"),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 12),
        child: _body(),
      ),
    );
  }

  Widget _body() {
    return StreamBuilder<PerfilUsuarioModel>(
        stream: bloc.perfil,
        builder: (context, snapshot) {
          print(snapshot.data);
          if (snapshot.hasError) {
            return Center(
              child: Text("Error"),
            );
          }
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return Container(
            child: Column(
              children: <Widget>[
                Padding(padding: EdgeInsets.all(10)),
                Expanded(
                    flex: 3,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                            flex: 3,
                            child: SquareImage(
                              image: NetworkImage(
                                  snapshot.data.safeImagePerfilUrl),
                            )),
                        Expanded(
                          flex: 5,
                          child: Container(
                            padding: EdgeInsets.only(left: 6),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text("Nome: ${snapshot.data.nomeProjeto}"),
                                Text("Celular: ${snapshot.data.celular}"),
                                Text("Email: ${snapshot.data.email}"),
                                Text("Eixo: ${snapshot.data.eixo}"),
                              ],
                            ),
                          ),
                        ),
                      ],
                    )),
                Padding(
                    padding: EdgeInsets.all(5),
                    child: Text(
                      "Perfil do usuario:",
                      style: TextStyle(fontSize: 16),
                    )),
                Padding(padding: EdgeInsets.all(10)),
                Expanded(
                  flex: 6,
                  child: StreamBuilder<List<VariavelUsuarioModel>>(
                      stream: bloc.variaveis,
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
                          children: <Widget>[
                            ...snapshot.data.map((variavel) {
                              return Card(
                                  child: ListTile(
                                title: Text(
                                  "${variavel.nome}:",
                                  style: TextStyle(fontSize: 14),
                                ),
                                subtitle: Text(
                                  "${variavel.conteudo}",
                                  style: TextStyle(fontSize: 16),
                                ),
                              ));
                            }).toList()
                          ],
                        );
                      }),
                ),
              ],
            ),
          );
        });
  }
}
