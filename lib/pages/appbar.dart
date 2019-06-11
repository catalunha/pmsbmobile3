import 'package:flutter/material.dart';

Widget drawerBuild(context) {
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

Widget endDrawerBuild(context) {
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
