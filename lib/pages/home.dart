import 'package:flutter/material.dart';
import 'package:pmsbmibile3/components/login_required.dart';

class HomePageProxy extends StatelessWidget {
  Widget _appBarBuild() {
    return AppBar(
      actions: <Widget>[
        MoreAppAction(),
      ],

      //leading: Text("leading"),
      centerTitle: true,
      title: Text("Ola, Nome do Usuario"),
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

  Widget _drawerBuild() {
    return Drawer(
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Icon(
                    Icons.people,
                    size: 75,
                  ),
                  Text("+55 63 9 0000 0000"),
                ],
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
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLoginRequired(
      child: Scaffold(
        drawer: _drawerBuild(),
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
