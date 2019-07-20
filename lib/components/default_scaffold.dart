import 'package:flutter/material.dart';
import 'package:pmsbmibile3/components/circle_image.dart';
import 'package:pmsbmibile3/models/usuario_model.dart';
import 'package:pmsbmibile3/state/auth_bloc.dart';
import 'package:pmsbmibile3/state/services.dart';
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
                              child: snap.data.usuarioArquivoID.url == null
                                  ? Icon(Icons.people, size: 75)
                                  : CircleImage(
                                      image: NetworkImage(
                                          snap.data.usuarioArquivoID.url),
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
                                      child: Text("${snap.data.nome}"),
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
              title: Text('Desenvolvimento'),
              trailing: Icon(Icons.hourglass_empty),
              onTap: () {
                Navigator.pushReplacementNamed(context, "/desenvolvimento");
              },
            ),
            ListTile(
              title: Text('Home'),
              trailing: Icon(Icons.home),
              onTap: () {
                Navigator.pushReplacementNamed(context, "/");
              },
            ),
            Divider(
              color: Colors.black45,
            ),
            ListTile(
              title: Text('Questionarios'),
              trailing: Icon(Icons.assignment),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/questionario/home');
              },
            ),
            /**
            Divider(color: Colors.black45,),
            ListTile(
              title: Text('Perguntas'),
              trailing: Icon(Icons.chat_bubble),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/pergunta/home');
              },
            ),
            */
            Divider(
              color: Colors.black45,
            ),
            ListTile(
              title: Text('Aplicação'),
              trailing: Icon(
                Icons.directions_walk,
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/aplicacao/home');
              },
            ),
            Divider(
              color: Colors.black45,
            ),
            ListTile(
              title: Text('Respostas'),
              trailing: Icon(Icons.chat),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/resposta/home');
              },
            ),
            Divider(
              color: Colors.black45,
            ),
            ListTile(
              title: Text('Síntese'),
              trailing: Icon(Icons.equalizer),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/sintese/home');
              },
            ),
            Divider(
              color: Colors.black45,
            ),
            ListTile(
              title: Text('Produto'),
              trailing: Icon(Icons.chrome_reader_mode),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/produto');
              },
            ),
            Divider(
              color: Colors.black45,
            ),
            ListTile(
              title: Text('Comunicação'),
              trailing: Icon(Icons.contact_mail),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/comunicacao/home_page');
              },
            ),
            Divider(
              color: Colors.black45,
            ),
            ListTile(
                title: Text('Administração'),
                trailing: Icon(Icons.business_center),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/administracao/home');
                }),
            Divider(
              color: Colors.black45,
            ),
            ListTile(
              title: Text('Controle'),
              trailing: Icon(Icons.control_point),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/controle/home');
              },
            )
          ],
        ),
      ),
    );
  }
}

class DefaultEndDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var authBloc = Provider.of<AuthBloc>(context);
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
              leading: Icon(Icons.close),
            ),
            Divider(color: Colors.black45,),
            ListTile(
              title: Text('Perfil'),
              trailing: Icon(Icons.person),
              onTap: () {
                //noticias perfil
                Navigator.pop(context);
                Navigator.pushNamed(context, "/perfil");
              },
              leading: Icon(Icons.close),
            ),
            Divider(color: Colors.black45,),
            ListTile(
              title: Text('Noticias lidas'),
              onTap: () {
                //noticias arquivadas
                Navigator.pop(context);
                Navigator.pushNamed(context, "/noticias/noticias_visualizadas");
              },
              leading: Icon(Icons.close),
            ),
            Divider(color: Colors.black45,),
            ListTile(
              title: Text('Sair'),
              trailing: Icon(Icons.exit_to_app),
              onTap: () {
                authBloc.dispatch(LogoutAuthBlocEvent());
              },
              leading: Icon(Icons.close),
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
