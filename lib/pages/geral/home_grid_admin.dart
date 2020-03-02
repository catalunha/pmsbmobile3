import 'package:flutter/material.dart';
import 'package:pmsbmibile3/bootstrap.dart';
import 'package:pmsbmibile3/models/usuario_model.dart';
import 'package:pmsbmibile3/services/recursos.dart';
import 'package:pmsbmibile3/state/auth_bloc.dart';

class Rota {
  final String nome;
  final IconData icone;

  Rota(this.nome, this.icone);
}

class DefaultDrawer extends StatefulWidget {
  _DefaultDrawerState createState() => _DefaultDrawerState();
}

class _DefaultDrawerState extends State<DefaultDrawer> {
  final AuthBloc authBloc;
  Map<String, Rota> rotas;

  _DefaultDrawerState() : authBloc = Bootstrap.instance.authBloc {
    rotas = Map<String, Rota>();
    if (Recursos.instance.plataforma == 'android') {
      rotas["/"] = Rota("Home", Icons.home);
      rotas["/desenvolvimento"] = Rota("Desenvolvimento", Icons.build);
      rotas["/upload"] = Rota("Upload de arquivos", Icons.file_upload);
      rotas["/questionario/home"] = Rota("Questionários", Icons.assignment);
      rotas["/aplicacao/home"] =
          Rota("Aplicar Questionário", Icons.directions_walk);
      rotas["/resposta/home"] = Rota("Resposta", Icons.playlist_add_check);
      rotas["/sintese/home"] = Rota("Síntese", Icons.equalizer);
      rotas["/produto/home"] = Rota("Produto", Icons.chrome_reader_mode);
      rotas["/controle/home"] = Rota("Controle", Icons.control_point);
      rotas["/setor_painel/home"] = Rota("Painel", Icons.compare);
      // rotas["/comunicacao/home"] = Rota("Comunicação", Icons.contact_mail);
      rotas["/administracao/home"] =
          Rota("Administração", Icons.business_center);
    } else if (Recursos.instance.plataforma == 'web') {
      rotas["/"] = Rota("Home", Icons.home);
      rotas["/questionario/home"] = Rota("Questionários", Icons.assignment);
      rotas["/resposta/home"] = Rota("Resposta", Icons.playlist_add_check);
      rotas["/sintese/home"] = Rota("Síntese", Icons.equalizer);
      rotas["/produto/home"] = Rota("Produto", Icons.chrome_reader_mode);
      rotas["/controle/home"] = Rota("Controle", Icons.control_point);
      rotas["/setor_painel/home"] = Rota("Painel", Icons.compare);
      rotas["/administracao/home"] = Rota("Administração", Icons.business_center);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: SafeArea(
      child: Column(children: <Widget>[
        StreamBuilder<UsuarioModel>(
          stream: authBloc.perfil,
          builder: (context, snap) {
            if (snap.hasError) {
              return Center(
                child: Text("Erro"),
              );
            }
            if (!snap.hasData)
              return Center(
                child: CircularProgressIndicator(),
              );

            return DrawerHeader(
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                        color: Theme.of(context).textTheme.title.color),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        // Expanded(
                        //     flex: 4,
                        //     child: _ImagemUnica(
                        //         fotoUrl: snap.data?.foto?.url,
                        //         fotoLocalPath: snap.data?.foto?.localPath)
                                
                        //         ),
                        Expanded(
                          flex: 8,
                          child: Container(
                            padding: EdgeInsets.only(left: 12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Text("${snap.data.nome}"),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Text("${snap.data.celular}"),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Text(
                                      "Eixo: ${snap.data.eixoIDAtual.nome}"),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Text(
                                      "Setor: ${snap.data.setorCensitarioID.nome}"),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text("${snap.data.email}"),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        StreamBuilder<UsuarioModel>(
            stream: authBloc.perfil,
            builder: (context, snap) {
              if (snap.hasError) {
                return Center(
                  child: Text("Erro"),
                );
              }

              List<Widget> list = List<Widget>();
              if (snap.data == null ||
                  snap.data.routes == null ||
                  snap.data.routes.isEmpty) {
                list.add(Container());
              } else {
                rotas.forEach((k, v) {
                  if (snap.data.routes.contains(k)) {
                    list.add(ListTile(
                      title: Text(v.nome),
                      trailing: Icon(v.icone),
                      onTap: () {
                        Navigator.pushReplacementNamed(context, k);
                      },
                    ));
                  }
                });
              }
              if (list.isEmpty || list == null) {
                list.add(Container());
              }
              return Expanded(child: ListView(children: list));
            })
      ]),
    ));
  }
}