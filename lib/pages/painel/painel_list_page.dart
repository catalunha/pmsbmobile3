import 'package:flutter/material.dart';
import 'package:pmsbmibile3/bootstrap.dart';
import 'package:pmsbmibile3/components/default_scaffold.dart';
import 'package:pmsbmibile3/pages/painel/painel_list_bloc.dart';
import 'package:pmsbmibile3/state/auth_bloc.dart';
import 'package:pmsbmibile3/naosuportato/url_launcher.dart'
    if (dart.library.io) 'package:url_launcher/url_launcher.dart';

class PainelListPage extends StatefulWidget {
  _PainelListPageState createState() => _PainelListPageState();
}

class _PainelListPageState extends State<PainelListPage> {
  PainelListBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = PainelListBloc(Bootstrap.instance.firestore);
  }

  @override
  void dispose() {
    super.dispose();
    bloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Adicionar/Editar itens do painel'),
      ),
      body: StreamBuilder<PainelListBlocState>(
          stream: bloc.stateStream,
          builder: (BuildContext context, AsyncSnapshot<PainelListBlocState> snapshot) {
            if (snapshot.hasError) {
              return Text("ERROR");
            }
            if (!snapshot.hasData) {
              return Text("SEM DADOS");
            }
            if (snapshot.hasData) {
              if (snapshot.data.isDataValid) {
                List<Widget> listaWidget = List<Widget>();
                for (var painel in snapshot.data.painelList) {
                  Widget icone;
                  if (painel.tipo == 'texto') {
                    icone = Icon(Icons.text_fields);
                  } else if (painel.tipo == 'numero') {
                    icone = Icon(Icons.looks_one);
                  } else if (painel.tipo == 'booleano') {
                    icone = Icon(Icons.thumbs_up_down);
                  } else if (painel.tipo == 'urlimagem') {
                    icone = Icon(Icons.image);
                  } else if (painel.tipo == 'urlarquivo') {
                    icone = Icon(Icons.attach_file);
                  }

                  listaWidget.add(Column(children: <Widget>[
                    Card(
                        child: ListTile(
                      trailing: icone,
                      title: Text('${painel?.nome}'),
                      subtitle:
                          Text('Editado por: ${painel?.usuarioID?.nome}\nEm: ${painel?.modificado}\nid:${painel.id}'),
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          "/painel/crud",
                          arguments: painel.id,
                        );
                      },
                    ))
                  ]));
                }
                listaWidget.add(Container(
                  padding: EdgeInsets.only(top: 70),
                ));
                return ListView(
                  children: listaWidget,
                );
              } else {
                return Text('Dados inválidos...');
              }
            }
          }),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamed(context, '/painel/crud', arguments: null);
        },
        // backgroundColor: Colors.blue,
      ),
    );
  }
}
