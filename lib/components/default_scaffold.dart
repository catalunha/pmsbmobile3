import 'package:flutter/material.dart';
import 'package:pmsbmibile3/bootstrap.dart';
import 'package:pmsbmibile3/models/usuario_model.dart';
import 'package:pmsbmibile3/services/cache_service.dart';
import 'package:pmsbmibile3/services/recursos.dart';
import 'package:pmsbmibile3/state/auth_bloc.dart';
import 'package:pmsbmibile3/style/pmsb_colors.dart';

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
      rotas["/administracao/home"] =
          Rota("Administração", Icons.business_center);
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
                        Expanded(
                            flex: 4,
                            child: _ImagemUnica(
                                fotoUrl: snap.data?.foto?.url,
                                fotoLocalPath: snap.data?.foto?.localPath)),
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

class _ImagemUnica extends StatelessWidget {
  final String fotoUrl;
  final String fotoLocalPath;

  const _ImagemUnica({this.fotoUrl, this.fotoLocalPath});

  @override
  Widget build(BuildContext context) {
    Widget foto;
    if (fotoUrl == null && fotoLocalPath == null) {
      foto = Center(child: Text('Sem imagem.'));
    } else if (fotoUrl != null) {
      foto = CircleAvatar(
        minRadius: 40,
        maxRadius: 50,
        backgroundImage: NetworkImage(fotoUrl),
      );
    } else {
      foto = Container(
          color: Colors.yellow,
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: Image.asset(fotoLocalPath),
          ));
    }

    return Row(
      children: <Widget>[
        Spacer(
          flex: 1,
        ),
        Expanded(
          flex: 8,
          child: foto,
        ),
        Spacer(
          flex: 1,
        ),
      ],
    );
  }
}

class DefaultEndDrawer extends StatefulWidget {
  _DefaultEndDrawerState createState() => _DefaultEndDrawerState();
}

class _DefaultEndDrawerState extends State<DefaultEndDrawer> {
  final AuthBloc authBloc;
  Map<String, Rota> rotas;

  _DefaultEndDrawerState() : authBloc = Bootstrap.instance.authBloc {
    rotas = Map<String, Rota>();
    if (Recursos.instance.plataforma == 'android') {
      rotas["/perfil/configuracao"] = Rota("Configurações", Icons.settings);
      rotas["/perfil"] = Rota("Itens do Perfil", Icons.person);
      rotas["/painel/home"] = Rota("Itens do Painel", Icons.table_chart);
      rotas["/versao"] = Rota("Versão & Sobre", Icons.device_unknown);
      // rotas["/noticias/noticias_visualizadas"] = Rota("Noticias lidas", Icons.event_available);
      rotas["/modooffline"] = Rota("Habilitar modo offline", Icons.save);
    } else if (Recursos.instance.plataforma == 'web') {
      rotas["/perfil/configuracao"] = Rota("Configurações", Icons.settings);
      rotas["/painel/home"] = Rota("Itens do Painel", Icons.table_chart);
      rotas["/versao"] = Rota("Versão & Sobre", Icons.device_unknown);
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
                List<Widget> list = List<Widget>();
                if (snap.data == null ||
                    snap.data.routes == null ||
                    snap.data.routes.isEmpty) {
                  list.add(Container());
                } else {
                  rotas.forEach((k, v) {
                    if (snap.data.routes.contains(k)) {
                      if (k == '/modooffline') {
                        // MODO OFFLINE -----------------------------------------------
                        list.add(ListTile(
                          title: Text("Habilitar modo offline"),
                          onTap: () async {
                            final cacheService =
                                CacheService(Bootstrap.instance.firestore);
                            await cacheService.load();
                            Scaffold.of(context).showSnackBar(SnackBar(
                                content: Text("Modo offline completo.")));
                            Navigator.pop(context);
                          },
                          leading: Icon(Icons.save),
                        ));
                      } else {
                        list.add(ListTile(
                          title: Text(v.nome),
                          leading: Icon(v.icone),
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.pushNamed(context, k);
                          },
                        ));
                      }
                    }
                  });
                }
                list.add(
                  // Sair do APP --------------------------------------------------
                  ListTile(
                    title: Text('Trocar de usuário'),
                    onTap: () {
                      authBloc.dispatch(LogoutAuthBlocEvent());
                      Navigator.pushReplacementNamed(context, "/");
                    },
                    leading: Icon(Icons.exit_to_app),
                  ),
                );
                return Expanded(child: ListView(children: list));
              })
        ]),
      ),
    );
  }
}

class MoreAppAction extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Icon(Icons.more_vert),
      onTap: () {
        Scaffold.of(context).openEndDrawer();
      },
    );
  }
}

class DefaultScaffold extends StatelessWidget {
  final Widget body;
  final Widget floatingActionButton;
  final Widget title;
  final Widget actions;
  final List<Widget> actionsMore;
  final Widget bottom;
  final Color backgroundColor;
  final FloatingActionButtonLocation floatingActionButtonLocation;

  const DefaultScaffold({
    Key key,
    this.body,
    this.floatingActionButton,
    this.title,
    this.actions,
    this.actionsMore,
    this.backgroundColor,
    this.bottom,
    this.floatingActionButtonLocation,
  }) : super(key: key);

  Widget _appBarBuild(BuildContext context) {
    return AppBar(
      leading: new IconButton(
        icon: new Icon(
          Icons.arrow_back,
          size: 25,
        ),
        onPressed: () {
          Navigator.popAndPushNamed(context, "/");
        },
      ),
      // backgroundColor: PmsbColors.fundo,
      backgroundColor: PmsbColors.fundo,
      bottomOpacity: 0.0,
      elevation: 0.0,
      // actions: <Widget>[
      //   if (actionsMore != null) ...actionsMore,
      //   MoreAppAction(),
      // ],
      centerTitle: true,
      title: title,
      bottom: bottom,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // drawer: DefaultDrawer(),
      // endDrawer: DefaultEndDrawer(),
      appBar: _appBarBuild(context),
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      body: Container(color: PmsbColors.fundo, child: body),
    );
  }
}
