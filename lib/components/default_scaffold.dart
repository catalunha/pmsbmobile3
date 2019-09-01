import 'package:flutter/material.dart';
import 'package:pmsbmibile3/bootstrap.dart';
import 'package:pmsbmibile3/models/usuario_model.dart';
import 'package:pmsbmibile3/services/cache_service.dart';
import 'package:pmsbmibile3/state/auth_bloc.dart';

class Rota {
  final String nome;
  final Icons;

  Rota(this.nome, this.Icons);
}

class DefaultDrawer extends StatefulWidget {
  // DefaultDrawer({Key key}) : super(key: key);

  _DefaultDrawerState createState() => _DefaultDrawerState();
}

class _DefaultDrawerState extends State<DefaultDrawer> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//        child: child,
//     );
//   }
// }

// class DefaultDrawer extends StatelessWidget {
  final AuthBloc authBloc;
  Map<String, Rota> rotas;

  _DefaultDrawerState() : authBloc = Bootstrap.instance.authBloc {
    // Map<String, Rota>
    rotas = Map<String, Rota>();
    rotas["/desenvolvimento"] = Rota("Desenvolvimento", Icons.build);
    rotas["/"] = Rota("Home", Icons.home);
    rotas["/upload"] = Rota("Upload de arquivos", Icons.file_upload);
    rotas["/questionario/home"] = Rota("Questionários", Icons.assignment);
    rotas["/aplicacao/home"] =
        Rota("Aplicar Questionário", Icons.directions_walk);
    rotas["/resposta/home"] = Rota("Resposta", Icons.playlist_add_check);
    rotas["/sintese/home"] = Rota("Síntese", Icons.equalizer);
    rotas["/produto/home"] = Rota("Produto", Icons.chrome_reader_mode);
    rotas["/comunicacao/home"] = Rota("Comunicação", Icons.contact_mail);
    rotas["/administracao/home"] = Rota("Administração", Icons.business_center);
    rotas["/controle/home"] = Rota("Controle", Icons.control_point);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: SafeArea(
      child: Column(
          // padding: EdgeInsets.zero,
          children: <Widget>[
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
                Widget imagem = Icon(Icons.people, size: 75);
                if (snap.data?.foto?.localPath != null) {
                  imagem = Container(
                      color: Colors.yellow,
                      child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: CircleAvatar(
                            backgroundImage:
                                ExactAssetImage(snap.data?.foto?.localPath),
                            minRadius: 50,
                            maxRadius: 50,
                          )));
                } else if (snap.data?.foto?.url != null) {
                  imagem = CircleAvatar(
                    backgroundImage: NetworkImage(snap.data?.foto?.url),
                    minRadius: 50,
                    maxRadius: 50,
                  );
                }
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
                            // Expanded(flex: 4, child: imagem),
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
                  // if (!snap.hasData) {
                  //   return Center(
                  //     child: CircularProgressIndicator(),
                  //   );
                  // }
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
                          trailing: Icon(v.Icons),
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
            // child: Icon(Icons.people, size: 75),
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
  DefaultEndDrawer({Key key}) : super(key: key);

  _DefaultEndDrawerState createState() => _DefaultEndDrawerState();
}

class _DefaultEndDrawerState extends State<DefaultEndDrawer> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//        child: child,
//     );
//   }
// }

// class DefaultEndDrawer extends StatelessWidget {
  final AuthBloc authBloc;

  _DefaultEndDrawerState() : authBloc = Bootstrap.instance.authBloc;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            ListTile(
              title: Text('Configurações'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, "/perfil/configuracao");
              },
              leading: Icon(Icons.settings),
            ),
            Divider(
              color: Colors.black45,
            ),
            ListTile(
              title: Text('Perfil'),
              onTap: () {
                //noticias perfil
                Navigator.pop(context);
                Navigator.pushNamed(context, "/perfil");
              },
              leading: Icon(Icons.person),
            ),
            Divider(
              color: Colors.black45,
            ),
            ListTile(
              title: Text('Noticias lidas'),
              onTap: () {
                //noticias arquivadas
                Navigator.pop(context);
                Navigator.pushNamed(context, "/noticias/noticias_visualizadas");
              },
              leading: Icon(Icons.event_available),
            ),
            Divider(
              color: Colors.black45,
            ),
            ListTile(
              title: Text('Trocar de usuário'),
              onTap: () {
                authBloc.dispatch(LogoutAuthBlocEvent());
                // Navigator.pushNamed(context, "/");
              },
              leading: Icon(Icons.exit_to_app),
            ),
            ListTile(
              title: Text("Habilitar modo offline"),
              onTap: () async {
                final cacheService = CacheService(Bootstrap.instance.firestore);
                await cacheService.load();
                Scaffold.of(context).showSnackBar(
                    SnackBar(content: Text("Modo offline completo.")));
                Navigator.pop(context);
              },
              leading: Icon(Icons.save),
            ),
          ],
        ),
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
      backgroundColor: backgroundColor,
      actions: <Widget>[
        if (actionsMore != null) ...actionsMore,
        MoreAppAction(),
      ],
      centerTitle: true,
      title: title,
      bottom: bottom,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DefaultDrawer(),
      endDrawer: DefaultEndDrawer(),
      appBar: _appBarBuild(context),
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      body: body,
    );
  }
}
