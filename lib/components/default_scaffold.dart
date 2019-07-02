import 'package:flutter/material.dart';
import 'package:pmsbmibile3/components/circle_image.dart';
import 'package:pmsbmibile3/models/perfis_usuarios_model.dart';
import 'package:pmsbmibile3/state/auth_bloc.dart';
import 'package:pmsbmibile3/state/services.dart';
import 'package:pmsbmibile3/state/user_repository.dart';
import 'package:provider/provider.dart';

var db = DatabaseService();

class DefaultDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var authBloc = Provider.of<AuthBloc>(context);
    return Drawer(
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            StreamBuilder<PerfilUsuarioModel>(
              stream: authBloc.perfil,
              builder: (context, snap) {
                if (snap.data == null)
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
                              child: snap.data.imagemPerfilUrl == null
                                  ? Icon(Icons.people, size: 75)
                                  : CircleImage(
                                      image: NetworkImage(
                                          snap.data.imagemPerfilUrl),
                                    ),
                            ),
                            Expanded(
                              flex: 8,
                              child: Container(
                                padding: EdgeInsets.only(left: 12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8),
                                      child: Text("${snap.data.nomeProjeto}"),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8),
                                      child: Text("${snap.data.celular}"),
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
            ListTile(
              title: Text('Home'),
              onTap: () {
                Navigator.pushReplacementNamed(context, "/");
              },
            ),
            ListTile(
              title: Text('Questionarios'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/questionario/home');
              },
            ),
            ListTile(
              title: Text('Perguntas'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/pergunta/home');
              },
            ),
            ListTile(
              title: Text('Aplicação'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/aplicacao/home');
              },
            ),
            ListTile(
              title: Text('Respostas'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/resposta/home');
              },
            ),
            ListTile(
              title: Text('Síntese'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/sintese/home');
              },
            ),
            ListTile(
              title: Text('Produto'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/produto');
              },
            ),
            ListTile(
              title: Text('Comunicação'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/comunicacao');
              },
            ),
            ListTile(
              title: Text('Administração'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/administracao/home');
              },
            ),
          ],
        ),
      ),
    );
  }
}

class DefaultEndDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    UserRepository userRepository = Provider.of<UserRepository>(context);

    return Drawer(
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            ListTile(
              title: Text('Perfil'),
              onTap: () {
                //noticias perfil
                Navigator.pop(context);
                Navigator.pushNamed(context, "/perfil");
              },
            ),
            ListTile(
              title: Text('Noticias Arquivadas'),
              onTap: () {
                //noticias arquivadas
                Navigator.pop(context);
                Navigator.pushNamed(context, "/noticias/noticias_visualizadas");
              },
            ),
            ListTile(
              title: Text('Configurações'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, "/perfil/configuracao");
              },
            ),
            ListTile(
              title: Text('Sair'),
              onTap: () {
                Navigator.pushNamedAndRemoveUntil(
                    context, "/", (Route<dynamic> route) => false);
                userRepository.signOut();
              },
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
  final Widget bottom;
  final Color backgroundColor;

  const DefaultScaffold(
      {Key key,
      this.body,
      this.floatingActionButton,
      this.title,
      this.actions,
      this.backgroundColor,
      this.bottom})
      : super(key: key);

  Widget _appBarBuild(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      actions: <Widget>[
        MoreAppAction(),
      ],
      //leading: Text("leading"),
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
      body: body,
    );
  }
}
