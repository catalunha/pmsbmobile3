import 'package:flutter/material.dart';
import 'package:pmsbmibile3/pages/communicationCreateEdit.dart';
import 'package:pmsbmibile3/pages/home.dart';

class CommunicationPage extends StatefulWidget {
  @override
  _CommunicationPageState createState() => _CommunicationPageState();
}

class _CommunicationPageState extends State<CommunicationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _drawerBuild(),
      appBar: _appBarBuild(context),
      endDrawer: _endDrawerBuild(),
      body: _body(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CommunicationCreateEdit()),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }

  Widget _body() {
    return Container(
      child: ListView(
        children: <Widget>[
          _cardBuild(),
          _cardBuild(),
        ],
      ),
    );
  }

  Widget _modalBottomSheet() {
    return Container(
      child: Padding(
        padding: EdgeInsets.all(32.0),
        child: Text(
          'This is the modal bottom sheet. Slide down to dismiss.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 24.0,
          ),
        ),
      ),
    );
  }

  Widget _appBarBuild(context) {
    return AppBar(
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.search),
          onPressed: () {
            _settingModalBottomSheet(context);
          },
        ),
        MoreAppAction(),
      ],

      //leading: Text("leading"),
      centerTitle: true,
      title: Text("Eixo de comunicação"),
    );
  }

  Widget _cardBuild() {
    return Card(
        elevation: 10,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const ListTile(
              title: Text('Noticia teste'),
              subtitle: Text(
                  '01/02/0202 - 01/02/0202: \nMusic by Julie Gable. https://api.flutter.dev/flutter/material/ListTile-class.html Lyrics by Sidney Stein. Music by Julie Gable. Lyrics by Sidney Stein.Music by Julie Gable. Lyrics by Sidney Stein.'),
            ),
            ButtonTheme.bar(
              child: ButtonBar(
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.archive),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () async {
                      String s = await Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return CommunicationCreateEdit();
                      }));
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {},
                  )
                ],
              ),
            )
          ],
        ));
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
              title: Text('Comunicação'),
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

void _settingModalBottomSheet(context) {
  showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return Container(
          child: new ListView(
            children: <Widget>[
              Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(
                    "Escolha o item para filtrar a notícia:",
                    style: TextStyle(fontSize: 18),
                  )),
              ListTile(
                onTap: () {},
                title: Text("Numero"),
                trailing: Icon(Icons.arrow_forward),
              ),
              ListTile(
                onTap: () {},
                title: Text("Titulo"),
                trailing: Icon(Icons.arrow_forward),
              ),
              ListTile(
                onTap: () {},
                title: Text("Data de inicio"),
                trailing: Icon(Icons.arrow_forward),
              ),
              ListTile(
                onTap: () {},
                title: Text("Data de fim"),
                trailing: Icon(Icons.arrow_forward),
              ),
              ListTile(
                onTap: () {},
                title: Text("Tem anexo"),
                trailing: Icon(Icons.arrow_forward),
              ),
              ListTile(
                onTap: () {},
                title: Text("Lidas"),
                trailing: Icon(Icons.arrow_forward),
              ),
              ListTile(
                onTap: () {},
                title: Text("Não lidas"),
                trailing: Icon(Icons.arrow_forward),
              ),
              ListTile(
                onTap: () {},
                title: Text("Destinos"),
                trailing: Icon(Icons.arrow_forward),
              ),
              ListTile(
                onTap: () {},
                title: Text("Arquivadas"),
                trailing: Icon(Icons.arrow_forward),
              ),
            ],
          ),
        );
      });
}
