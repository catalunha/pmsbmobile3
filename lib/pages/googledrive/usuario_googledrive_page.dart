import 'package:flutter/material.dart';
import 'package:pmsbmibile3/bootstrap.dart';
import 'package:pmsbmibile3/pages/googledrive/usuario_googledrive_bloc.dart';

class UsuarioGoogleDrivePage extends StatefulWidget {
  final String googleDriveID;

  const UsuarioGoogleDrivePage(this.googleDriveID);

  @override
  _UsuarioGoogleDrivePageState createState() => _UsuarioGoogleDrivePageState();
}

class _UsuarioGoogleDrivePageState extends State<UsuarioGoogleDrivePage> {
  UsuarioGoogleDriveBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = UsuarioGoogleDriveBloc(Bootstrap.instance.firestore);
    bloc.eventSink(UpdateGoogleDriveEvent(widget.googleDriveID));
  }

  @override
  void dispose() {
    super.dispose();
    bloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return DefaultTabController(
      length: 3,
      child: Scaffold(
          appBar: new AppBar(
            // automaticallyImplyLeading: false,
            title: new Text('Atualizar acesso'),
            bottom: TabBar(
              tabs: <Widget>[
                Tab(
                  text: 'Cargo',
                ),
                Tab(
                  text: 'Eixo',
                ),
                Tab(
                  text: 'Usuário',
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              bloc.eventSink(SaveProdutoIDEvent());
              Navigator.pop(context);
            },
            child: Icon(Icons.cloud_upload),
          ),
          body: TabBarView(
            children: <Widget>[_cargoBody(), _eixoBody(), _usuarioBody()],
          )),
    );
  }

  _cargoBody() {
    return StreamBuilder<UsuarioGoogleDriveState>(
        stream: bloc.stateStream,
        builder: (BuildContext context,
            AsyncSnapshot<UsuarioGoogleDriveState> snapshot) {
          if (snapshot.hasError) {
            return Text('Erro.');
          }
          if (!snapshot.hasData) {
            return Text('Sem dados.');
          }
          if (snapshot.hasData) {
            //  var cargoList = List<Cargo>();
            var cargoList = snapshot.data.cargoList;
            return ListView(
              children: <Widget>[
                ...cargoList.map((variavel) {
                  return Card(
                      color: variavel.checked ? Colors.deepOrange : null,
                      child: InkWell(
                          onTap: () {
                            bloc.eventSink(SelectCargoIDEvent(variavel.id));
                          },
                          child: ListTile(
                            title: Text(
                              "${variavel.nome}",
                              style: TextStyle(fontSize: 18),
                            ),
                          )));
                }).toList()
              ],
            );
          }
          return Text('Algum problema...');
        });
  }

  _eixoBody() {
    return StreamBuilder<UsuarioGoogleDriveState>(
        stream: bloc.stateStream,
        builder: (BuildContext context,
            AsyncSnapshot<UsuarioGoogleDriveState> snapshot) {
          if (snapshot.hasError) {
            return Text('Erro.');
          }
          if (!snapshot.hasData) {
            return Text('Sem dados.');
          }
          if (snapshot.hasData) {
            //  var cargoList = List<Cargo>();
            var eixoList = snapshot.data.eixoList;
            return ListView(
              children: <Widget>[
                ...eixoList.map((variavel) {
                  return Card(
                      color: variavel.checked ? Colors.deepOrange : null,
                      child: InkWell(
                          onTap: () {
                            bloc.eventSink(SelectEixoIDEvent(variavel.id));
                          },
                          child: ListTile(
                            title: Text(
                              // "# ${variavel.id}-${variavel.nome}-${variavel.checked}",
                              "${variavel.nome}",
                              style: TextStyle(fontSize: 18),
                            ),

                            // subtitle: Text(
                            //   "## ${variavel?.nome}",
                            //   "CLIQUE AQUI PARA VER O ARQUIVO",
                            //   style:
                            //       TextStyle(fontSize: 16, color: Colors.blue),
                            // ),
                          )));
                }).toList()
              ],
            );
          }
          return Text('Algo parece não estar certo...');
        });
  }

  _usuarioBody() {
    return StreamBuilder<UsuarioGoogleDriveState>(
        stream: bloc.stateStream,
        builder: (BuildContext context,
            AsyncSnapshot<UsuarioGoogleDriveState> snapshot) {
          if (snapshot.hasError) {
            return Text('Erro.');
          }
          if (!snapshot.hasData) {
            return Text('Sem dados.');
          }
          if (snapshot.hasData) {
            //  var cargoList = List<Cargo>();
            var usuarioList = snapshot.data.usuarioList;
            return ListView(
              children: <Widget>[
                ...usuarioList.map((usuario) {
                  return Column(
                    children: <Widget>[
                      InkWell(
                          onTap: () {
                            bloc.eventSink(SelectUsuarioIDEvent(usuario.id));
                          },
                          child: Card(
                              color: usuario.checked ? Colors.deepPurple : null,
                              child: ListTile(
                                title: Text(
                                  "${usuario.nome}",
                                  style: TextStyle(fontSize: 18),
                                ),
                                subtitle: Text(
                                  "Eixo: ${usuario.eixo.nome}. Cargo: ${usuario.cargo.nome}.",
                                ),
                                // subtitle: Text(
                                //   "## ${variavel?.nome}",
                                //   "CLIQUE AQUI PARA VER O ARQUIVO",
                                //   style:
                                //       TextStyle(fontSize: 16, color: Colors.blue),
                                // ),
                              ))),
                      usuario.checked == true
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                  new Radio(
                                    value: 'writer',
                                    groupValue:
                                        usuario.usuarioGoogleDrive?.permissao,
                                    onChanged: (radioValue) {
                                      bloc.eventSink(ChangePermissaoEvent(
                                          radioValue, usuario.id));
                                    },
                                    activeColor: Colors.green,
                                  ),
                                  new Text(
                                    'Escrever',
                                  ),
                                  // new Radio(
                                  //   value: 'comentar',
                                  //   groupValue:
                                  //       usuario.usuarioGoogleDrive?.permissao,
                                  //   onChanged: (radioValue) {
                                  //     bloc.eventSink(ChangePermissaoEvent(
                                  //         radioValue, usuario.id));
                                  //   },
                                  //   activeColor: Colors.green,
                                  // ),
                                  // new Text(
                                  //   'Comentar',
                                  // ),
                                  new Radio(
                                    value: 'reader',
                                    groupValue:
                                        usuario.usuarioGoogleDrive?.permissao,
                                    onChanged: (radioValue) {
                                      bloc.eventSink(ChangePermissaoEvent(
                                          radioValue, usuario.id));
                                    },
                                    activeColor: Colors.green,
                                  ),
                                  new Text(
                                    'Ler',
                                  ),
                                ])
                          : Container(),
                    ],
                  );
                }).toList()
              ],
            );
          }
          return Text('Algo parece não estar certo...');
        });
  }
}
