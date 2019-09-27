import 'package:flutter/material.dart';
import 'package:pmsbmibile3/bootstrap.dart';
import 'package:pmsbmibile3/components/default_scaffold.dart';
import 'package:pmsbmibile3/pages/painel/painel_list_bloc.dart';
import 'package:pmsbmibile3/state/auth_bloc.dart';

class PainelListPage extends StatefulWidget {
  final AuthBloc authBloc;

  PainelListPage(this.authBloc);

  _PainelListPageState createState() => _PainelListPageState();
}

class _PainelListPageState extends State<PainelListPage> {
  PainelListBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = PainelListBloc(Bootstrap.instance.firestore, widget.authBloc);
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
        body: StreamBuilder<PainelListBlocState>(
            stream: bloc.stateStream,
            builder: (BuildContext context,
                AsyncSnapshot<PainelListBlocState> snapshot) {
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
                      item = ListTile(
                        trailing: setorCensitarioPainel.valor == null
                            ? Icon(Icons.edit)
                            : Icon(Icons.text_fields),
                        title: Text('${setorCensitarioPainel.painelID.nome}'),
                        subtitle: Text(
                            'Texto:${setorCensitarioPainel.valor}\nObs: ${setorCensitarioPainel.observacao}\nid: ${setorCensitarioPainel.id}'),
                        onTap: () {
                          print('texto');
                        },
                        onLongPress: () {
                          print('link');
                        },
                      );
                    } else if (setorCensitarioPainel.painelID.tipo ==
                        'numero') {
                      item = ListTile(
                          trailing: setorCensitarioPainel.valor == null
                              ? Icon(Icons.edit)
                              : setorCensitarioPainel.valor,
                          title: Text('${setorCensitarioPainel.painelID.nome}'),
                          subtitle: Text(
                              'Obs: ${setorCensitarioPainel.observacao}\nid: ${setorCensitarioPainel.id}'));
                    } else if (setorCensitarioPainel.painelID.tipo ==
                        'booleano') {
                      item = ListTile(
                          trailing: setorCensitarioPainel.valor == null ||
                                  setorCensitarioPainel.valor
                              ? Icon(Icons.thumb_down)
                              : Icon(Icons.thumb_up),
                          title: Text('${setorCensitarioPainel.painelID.nome}'),
                          subtitle: Text(
                              'Obs: ${setorCensitarioPainel.observacao}\nid: ${setorCensitarioPainel.id}'));
                    } else if (setorCensitarioPainel.painelID.tipo == 'url') {
                      item = ListTile(
                          trailing: setorCensitarioPainel.valor == null ||
                                  setorCensitarioPainel.valor == ''
                              ? Icon(Icons.cloud_off)
                              : Icon(Icons.cloud_done),
                          title: Text('${setorCensitarioPainel.painelID.nome}'),
                          subtitle: Text(
                              'Obs: ${setorCensitarioPainel.observacao}\nid: ${setorCensitarioPainel.id}'));
                    }

                    listaWidget.add(Column(children: <Widget>[item]));
                  }
                  return Column(children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          flex: 10,
                          child: Text(
                              'Setor: ${snapshot.data.usuarioID.setorCensitarioID.nome}'),
                        ),
                        Wrap(alignment: WrapAlignment.start, children: <Widget>[
                          IconButton(
                            tooltip: 'Relatorio Geral em PDF.',
                            icon: Icon(Icons.picture_as_pdf),
                            onPressed: () async {
                              // var pdf = await PdfCreateService
                              //     .pdfwidgetForControleTarefaDoUsuario(
                              //         usuarioModel: snapshot.data.usuarioID,
                              //         remetente: false,
                              //         concluida: false);
                              // PdfSaveService.generatePdfAndOpen(pdf);
                            },
                          ),
                          IconButton(
                            tooltip: 'Relatorio deste setor em PDF.',
                            icon: Icon(Icons.picture_as_pdf),
                            onPressed: () async {
                              // var pdf = await PdfCreateService
                              //     .pdfwidgetForControleTarefaDoUsuario(
                              //         usuarioModel: snapshot.data.usuarioID,
                              //         remetente: false,
                              //         concluida: false);
                              // PdfSaveService.generatePdfAndOpen(pdf);
                            },
                          ),
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
