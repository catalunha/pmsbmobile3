import 'package:flutter/material.dart';
import 'package:pmsbmibile3/components/login_required.dart';
import 'package:provider/provider.dart';
import 'package:pmsbmibile3/state/user_repository.dart';
import 'package:pmsbmibile3/state/services.dart';
import 'package:pmsbmibile3/state/models/usuarios.dart';

var db = DatabaseService();

class HomePage extends StatelessWidget {
  UserRepository userRepository;

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

  Widget _cardBuild() {
    return Container(
      padding: EdgeInsets.all(6),
      child: Card(
        child: Column(
          children: <Widget>[
            ListTile(
              //leading: Text("asdf"),
              title: Text("Noticia N"),
              subtitle: Text(
                  "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."),
            ),
            Container(
              padding: EdgeInsets.all(12),
              alignment: Alignment.centerRight,
              child: Icon(Icons.thumb_up),
            ),
          ],
        ),
      ),
    );
  }

  Widget _drawerBuild(context) {
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
              title: Text('Comunicação'),
              onTap: () {
                Navigator.pushNamed(context, '/comunicacao');
              },
            ),
            ListTile(
              title: Text('Produto'),
              onTap: () {
                Navigator.pushNamed(context, '/produto');
              },
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

  Widget _endDrawerBuild() {
    return Drawer(
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            ListTile(
              title: Text('Dados da conta'),
              onTap: () {},
            ),
            ListTile(
              title: Text('Informações do Perfil'),
              onTap: () {},
            ),
            ListTile(
              title: Text('Noticias'),
              onTap: () {},
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

  @override
  Widget build(BuildContext context) {
    userRepository = Provider.of<UserRepository>(context);

    var userId = null;
    if (userRepository.user != null) {
      userId = userRepository.user.uid;
    }

    return DefaultLoginRequired(
      child: StreamProvider<Usuario>.value(
        initialData: Usuario(firstName: "..", lastName: ".."),
        stream: db.streamUsuario(userId),
        child: Scaffold(
          drawer: _drawerBuild(context),
          appBar: _appBarBuild(),
          endDrawer: _endDrawerBuild(),
          body: Container(
            child: ListView(
              children: <Widget>[
                _cardBuild(),
                _cardBuild(),
                _cardBuild(),
                _cardBuild(),
                _cardBuild(),
                _cardBuild(),
                _cardBuild(),
              ],
            ),
          ),
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
