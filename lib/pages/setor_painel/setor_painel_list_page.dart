import 'package:flutter/material.dart';
import 'package:pmsbmibile3/bootstrap.dart';
import 'package:pmsbmibile3/components/default_scaffold.dart';
import 'package:pmsbmibile3/pages/setor_painel/setor_painel_list_bloc.dart';
import 'package:pmsbmibile3/state/auth_bloc.dart';
import 'package:pmsbmibile3/naosuportato/url_launcher.dart'
    if (dart.library.io) 'package:url_launcher/url_launcher.dart';

class SetorPainelListPage extends StatefulWidget {
  final AuthBloc authBloc;

  SetorPainelListPage(this.authBloc);

  _SetorPainelListPageState createState() => _SetorPainelListPageState();
}

class _SetorPainelListPageState extends State<SetorPainelListPage> {
  SetorPainelListBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = SetorPainelListBloc(Bootstrap.instance.firestore, widget.authBloc);
  }

  @override
  void dispose() {
    super.dispose();
    bloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultScaffold(
        title: Text('Painel'),
        body: StreamBuilder<SetorPainelListBlocState>(
            stream: bloc.stateStream,
            builder: (BuildContext context,
                AsyncSnapshot<SetorPainelListBlocState> snapshot) {
              if (snapshot.hasError) {
                return Text("ERROR");
              }
              if (!snapshot.hasData) {
                return Text("SEM DADOS");
              }
              if (snapshot.hasData) {
                if (snapshot.data.isDataValid) {
                  List<Widget> listaWidget = List<Widget>();
                  for (var setorCensitarioPainel
                      in snapshot.data.setorCensitarioPainelList) {
                    Widget item;
                    if (setorCensitarioPainel.painelID.tipo == 'texto') {
                      item = Card(child:ListTile(
                        trailing: setorCensitarioPainel.valor == null
                            ? Icon(Icons.edit)
                            : Icon(Icons.text_fields),
                        title: Text('${setorCensitarioPainel?.painelID?.nome}'),
                        subtitle: Text(
                            '${setorCensitarioPainel?.valor}\nObs: ${setorCensitarioPainel?.observacao}\nAtualizada: ${setorCensitarioPainel?.modificada}\nEditor: ${setorCensitarioPainel?.usuarioID?.nome}\nid: ${setorCensitarioPainel?.id}'),
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            "/setor_painel/crud",
                            arguments: setorCensitarioPainel.id,
                          );
                        },
                      ));
                    } else if (setorCensitarioPainel.painelID.tipo ==
                        'numero') {
                      item = Card(child:ListTile(
                        trailing: setorCensitarioPainel.valor == null
                            ? Icon(Icons.edit)
                            : Text('${setorCensitarioPainel?.valor}'),
                        title: Text('${setorCensitarioPainel?.painelID?.nome}'),
                        subtitle: Text(
                            'Obs: ${setorCensitarioPainel?.observacao}\nAtualizada: ${setorCensitarioPainel?.modificada}\nEditor: ${setorCensitarioPainel?.usuarioID?.nome}\nid: ${setorCensitarioPainel?.id}'),
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            "/setor_painel/crud",
                            arguments: setorCensitarioPainel.id,
                          );
                        },
                      ));
                    } else if (setorCensitarioPainel.painelID.tipo ==
                        'booleano') {
                      item = Card(child:ListTile(
                        trailing: setorCensitarioPainel?.valor == null ||
                                setorCensitarioPainel.valor == false
                            ? Icon(Icons.thumb_down)
                            : Icon(Icons.thumb_up),
                        title: Text('${setorCensitarioPainel?.painelID?.nome}'),
                        subtitle: Text(
                            'Obs: ${setorCensitarioPainel?.observacao}\nAtualizada: ${setorCensitarioPainel?.modificada}\nEditor: ${setorCensitarioPainel?.usuarioID?.nome}\nid: ${setorCensitarioPainel?.id}'),
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            "/setor_painel/crud",
                            arguments: setorCensitarioPainel.id,
                          );
                        },
                      ));
                    } else if (setorCensitarioPainel.painelID.tipo ==
                        'urlimagem') {
                      item = Card(child:ListTile(
                        trailing: setorCensitarioPainel.valor == null ||
                                setorCensitarioPainel.valor == ''
                            ? Icon(Icons.cloud_off)
                            : Icon(Icons.cloud_done),
                        title: Text('${setorCensitarioPainel?.painelID?.nome}'),
                        subtitle: Text(
                            'Obs: ${setorCensitarioPainel?.observacao}\nAtualizada: ${setorCensitarioPainel?.modificada}\nEditor: ${setorCensitarioPainel?.usuarioID?.nome}\nid: ${setorCensitarioPainel?.id}'),
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            "/setor_painel/crud",
                            arguments: setorCensitarioPainel.id,
                          );
                        },
                        onLongPress: setorCensitarioPainel.valor != null
                            ? () {
                                launch(setorCensitarioPainel.valor);
                              }
                            : null,
                      ));
                    } else if (setorCensitarioPainel.painelID.tipo ==
                        'urlarquivo') {
                      item = Card(child:ListTile(
                        trailing: setorCensitarioPainel.valor == null ||
                                setorCensitarioPainel.valor == ''
                            ? Icon(Icons.cloud_off)
                            : Icon(Icons.cloud_done),
                        title: Text('${setorCensitarioPainel?.painelID?.nome}'),
                        subtitle: Text(
                            'Obs: ${setorCensitarioPainel?.observacao}\nAtualizada: ${setorCensitarioPainel?.modificada}\nEditor: ${setorCensitarioPainel?.usuarioID?.nome}\nid: ${setorCensitarioPainel?.id}'),
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            "/setor_painel/crud",
                            arguments: setorCensitarioPainel.id,
                          );
                        },
                        onLongPress: setorCensitarioPainel.valor != null
                            ? () {
                                launch(setorCensitarioPainel.valor);
                              }
                            : null,
                      ));
                    }else{
                      print('widget nulo: '+setorCensitarioPainel.id);
                      item=Container();
                    }

                    listaWidget.add(Column(children: <Widget>[item]));
                  }
                  return Column(children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          flex: 10,
                          child: Text(
                              'Setor: ${snapshot.data?.usuarioID?.setorCensitarioID?.nome}'),
                        ),
                        Wrap(alignment: WrapAlignment.start, children: <Widget>[
                          IconButton(
                            tooltip: 'Adicionar/Editar itens do painel',
                            icon: Icon(Icons.playlist_add),
                            onPressed: () async {
                              Navigator.pushNamed(
                            context,
                            "/painel/home",
                          );
                            },
                          ),
                          IconButton(
                            tooltip: 'Ver comparativo em planilha.',
                            icon: Icon(Icons.table_chart),
                            onPressed: () async {
                              launch(
                                  'https://docs.google.com/spreadsheets/d/1lGwxBTGXd55H6QfnJ_7WKuNBJi16dC_J6PBk0QR0viA/edit#gid=0');
                            },
                          )
                        ]),
                      ],
                    ),
                    Divider(),
                    Expanded(
                      flex: 10,
                      child: listaWidget != null
                          ? ListView(
                              children: listaWidget,
                            )
                          : Container(),
                    )
                  ]);
                } else {
                  return Text('Dados inválidos...');
                }
              }
            }));
  }
}
