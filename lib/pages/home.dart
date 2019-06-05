import 'package:flutter/material.dart';
import 'package:pmsbmibile3/components/login_required.dart';
import 'package:provider/provider.dart';
import 'package:pmsbmibile3/state/user_repository.dart';
import 'package:pmsbmibile3/state/services.dart';
import 'package:pmsbmibile3/state/models/usuarios.dart';
import 'package:pmsbmibile3/state/models/noticia.dart';

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

  Widget _drawerBuild() {
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
          drawer: _drawerBuild(),
          appBar: _appBarBuild(),
          endDrawer: _endDrawerBuild(),
          body: Container(
            child: StreamProvider<List<Future<Noticia>>>.value(
              stream: db.streamNoticias(userId),
              child: ListaNoticias(),
            ),
          ),
        ),
      ),
    );
  }
}

class ListaNoticias extends StatelessWidget {
  Widget _futureCard(Future<Noticia> futureNoticia) {
    return FutureBuilder(
      future: futureNoticia,
      builder: (BuildContext context, AsyncSnapshot<Noticia> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.active:
          case ConnectionState.waiting:
            return Center(
              child: CircularProgressIndicator(),
            );
          case ConnectionState.done:
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }
            return _cardBuild(snapshot.data);
        }
        return null; // unreachable
      },
    );
  }

  Widget _cardBuild(Noticia noticia) {
    return Container(
      padding: EdgeInsets.all(6),
      child: Card(
        child: Column(
          children: <Widget>[
            ListTile(
              //leading: Text("asdf"),
              title: Text("Titulo: ${noticia.titulo} id:${noticia.id}"),
              subtitle: Text("${noticia.conteudoMarkdown}"),
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

  @override
  Widget build(BuildContext context) {
    List<Future<Noticia>> noticias =
        Provider.of<List<Future<Noticia>>>(context);
    print(noticias.length);
    return ListView(
      children: noticias.map((noticia) => _futureCard(noticia)).toList(),
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
