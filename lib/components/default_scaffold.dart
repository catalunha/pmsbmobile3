import 'package:flutter/material.dart';
import 'package:pmsbmibile3/pages/geral/loading.dart';
import 'package:pmsbmibile3/state/models/usuarios.dart';
import 'package:pmsbmibile3/state/services.dart';
import 'package:pmsbmibile3/state/user_repository.dart';
import 'package:provider/provider.dart';

var db = DatabaseService();

class DefaultDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Consumer(
              builder: (context, Usuario usuario, _) => DrawerHeader(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Icon(
                          Icons.people,
                          size: 75,
                        ),
                        Text("${usuario.telefoneCelular}"),
                      ],
                    ),
                  ),
            ),
            ListTile(
              title: Text('Questionarios'),
              onTap: () {},
            ),
            ListTile(
              title: Text('Perguntas'),
              onTap: () {},
            ),
            ListTile(
              title: Text('Relatorios'),
              onTap: () {},
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
              onTap: () {},
            ),
            ListTile(
              title: Text('Sair'),
              onTap: () {
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

  const DefaultScaffold({
    Key key,
    this.body,
  }) : super(key: key);

  Widget _appBarBuild() {
    return AppBar(
      actions: <Widget>[
        MoreAppAction(),
      ],

      //leading: Text("leading"),
      centerTitle: true,
      title: Consumer(
        builder: (context, Usuario usuario, _) =>
            Text("Ola, ${usuario.lastName}"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    UserRepository userRepository = Provider.of<UserRepository>(context);
    if (userRepository.user != null) {
      return StreamProvider<Usuario>.value(
        initialData: Usuario(firstName: "..", lastName: ".."),
        stream: db.streamUsuario(userRepository.user.uid),
        child: Scaffold(
          drawer: DefaultDrawer(),
          endDrawer: DefaultEndDrawer(),
          appBar: _appBarBuild(),
          body: body,
        ),
      );
    }
    else{
      return LoadingPage();
    }
  }
}
