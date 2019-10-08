import 'package:flutter/material.dart';
import 'package:pmsbmibile3/bootstrap.dart';
import 'package:pmsbmibile3/components/default_scaffold.dart';
import 'package:pmsbmibile3/pages/painel/painel_list_bloc.dart';
import 'package:pmsbmibile3/services/pdf_create_service.dart';
import 'package:pmsbmibile3/services/pdf_save_service.dart';
import 'package:pmsbmibile3/state/auth_bloc.dart';
import 'package:pmsbmibile3/naosuportato/url_launcher.dart'
    if (dart.library.io) 'package:url_launcher/url_launcher.dart';

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
                  for (var setorCensitarioPainel in snapshot.data.setorCensitarioPainelList) {
                    Widget item;
                    if (setorCensitarioPainel.painelID.tipo == 'texto') {
                      item = ListTile(
                        trailing: setorCensitarioPainel.valor == null ? Icon(Icons.edit) : Icon(Icons.text_fields),
                        title: Text('${setorCensitarioPainel.painelID.nome}'),
                        subtitle: Text(
                            '${setorCensitarioPainel?.valor}\nObs: ${setorCensitarioPainel?.observacao}\nAtualizada: ${setorCensitarioPainel?.modificada}\nEditor: ${setorCensitarioPainel?.usuarioID?.nome}\nid: ${setorCensitarioPainel?.id}'),
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            "/painel/crud",
                            arguments: setorCensitarioPainel.id,
                          );
                        },
                      );
                    } else if (setorCensitarioPainel.painelID.tipo == 'numero') {
                      item = ListTile(
                        trailing: setorCensitarioPainel.valor == null
                            ? Icon(Icons.edit)
                            : Text('${setorCensitarioPainel.valor}'),
                        title: Text('${setorCensitarioPainel.painelID.nome}'),
                        subtitle: Text(
                            'Obs: ${setorCensitarioPainel?.observacao}\nAtualizada: ${setorCensitarioPainel?.modificada}\nEditor: ${setorCensitarioPainel?.usuarioID?.nome}\nid: ${setorCensitarioPainel?.id}'),
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            "/painel/crud",
                            arguments: setorCensitarioPainel.id,
                          );
                        },
                      );
                    } else if (setorCensitarioPainel.painelID.tipo == 'booleano') {
                      item = ListTile(
                        trailing: setorCensitarioPainel?.valor == null || setorCensitarioPainel.valor == false
                            ? Icon(Icons.thumb_down)
                            : Icon(Icons.thumb_up),
                        title: Text('${setorCensitarioPainel.painelID.nome}'),
                        subtitle: Text(
                            'Obs: ${setorCensitarioPainel?.observacao}\nAtualizada: ${setorCensitarioPainel?.modificada}\nEditor: ${setorCensitarioPainel?.usuarioID?.nome}\nid: ${setorCensitarioPainel?.id}'),
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            "/painel/crud",
                            arguments: setorCensitarioPainel.id,
                          );
                        },
                      );
                    } else if (setorCensitarioPainel.painelID.tipo == 'url') {
                      item = ListTile(
                        trailing: setorCensitarioPainel.valor == null || setorCensitarioPainel.valor == ''
                            ? Icon(Icons.cloud_off)
                            : Icon(Icons.cloud_done),
                        title: Text('${setorCensitarioPainel.painelID.nome}'),
                        subtitle: Text(
                            'Obs: ${setorCensitarioPainel?.observacao}\nAtualizada: ${setorCensitarioPainel?.modificada}\nEditor: ${setorCensitarioPainel?.usuarioID?.nome}\nid: ${setorCensitarioPainel?.id}'),
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            "/painel/crud",
                            arguments: setorCensitarioPainel.id,
                          );
                        },
                        onLongPress: setorCensitarioPainel.valor != null
                            ? () {
                                launch(setorCensitarioPainel.valor);
                              }
                            : null,
                      );
                    }

                    listaWidget.add(Column(children: <Widget>[item]));
                  }
                  return Column(children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          flex: 10,
                          child: Text('Setor: ${snapshot.data.usuarioID.setorCensitarioID.nome}'),
                        ),
                        Wrap(alignment: WrapAlignment.start, children: <Widget>[
                          // IconButton(
                          //   tooltip: 'Comparativo em PDF.',
                          //   icon: Icon(Icons.view_list),
                          //   onPressed: () async {
                          //     var pdf = await PdfCreateService.pdfwidgetForPainelComparativo(
                          //       setorCensitario: snapshot.data.usuarioID.setorCensitarioID.id,
                          //     );
                          //     PdfSaveService.generatePdfAndOpen(pdf);
                          //   },
                          // ),
                          // IconButton(
                          //   tooltip: 'Relatorio deste setor em PDF.',
                          //   icon: Icon(Icons.picture_as_pdf),
                          //   onPressed: () async {
                          //     var pdf = await PdfCreateService.pdfwidgetForPainelSetor(
                          //       setorCensitario: snapshot.data.usuarioID.setorCensitarioID.id,
                          //     );
                          //     PdfSaveService.generatePdfAndOpen(pdf);
                          //   },
                          // ),
                          snapshot.data?.relatorioPdfMakeModel?.pdfGerar != null &&
                                  snapshot.data?.relatorioPdfMakeModel?.pdfGerar == false &&
                                  snapshot.data?.relatorioPdfMakeModel?.pdfGerado == true &&
                                  snapshot.data?.relatorioPdfMakeModel?.tipo == 'painel01'
                              ? IconButton(
                                  tooltip: 'Ver relatorio individual.',
                                  icon: Icon(Icons.link),
                                  onPressed: () async {
                                    bloc.eventSink(GerarRelatorioPdfMakeEvent(
                                        pdfGerar: false, pdfGerado: false, tipo: 'painel01'));
                                    launch(snapshot.data?.relatorioPdfMakeModel?.url);
                                  },
                                )
                              : IconButton(
                                  tooltip: 'Atualizar pdf individual.',
                                  icon: Icon(Icons.picture_as_pdf),
                                  onPressed: () async {
                                    bloc.eventSink(GerarRelatorioPdfMakeEvent(
                                        pdfGerar: true, pdfGerado: false, tipo: 'painel01'));
                                  },
                                ),
 
                          snapshot.data?.relatorioPdfMakeModel?.pdfGerar != null &&
                                  snapshot.data?.relatorioPdfMakeModel?.pdfGerar == false &&
                                  snapshot.data?.relatorioPdfMakeModel?.pdfGerado == true &&
                                  snapshot.data?.relatorioPdfMakeModel?.tipo == 'painel02'
                              ? IconButton(
                                  tooltip: 'Ver relatorio comparativo.',
                                  icon: Icon(Icons.link),
                                  onPressed: () async {
                                    bloc.eventSink(GerarRelatorioPdfMakeEvent(
                                        pdfGerar: false, pdfGerado: false, tipo: 'painel02'));
                                    launch(snapshot.data?.relatorioPdfMakeModel?.url);
                                  },
                                )
                              : IconButton(
                                  tooltip: 'Atualizar pdf comparativo.',
                                  icon: Icon(Icons.table_chart),
                                  onPressed: () async {
                                    bloc.eventSink(GerarRelatorioPdfMakeEvent(
                                        pdfGerar: true, pdfGerado: false, tipo: 'painel02'));
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
