import 'package:flutter/material.dart';
import 'package:pmsbmibile3/bootstrap.dart';
import 'package:pmsbmibile3/pages/checklist/item_resposta_list_bloc.dart';
import 'package:pmsbmibile3/pages/page_arguments.dart';

import 'package:pmsbmibile3/naosuportato/url_launcher.dart'
    if (dart.library.io) 'package:url_launcher/url_launcher.dart';

class ItemRespostaListPage extends StatefulWidget {
  final String itemId;

  const ItemRespostaListPage(this.itemId);

  @override
  _ItemRespostaListPageState createState() {
    return _ItemRespostaListPageState();
  }
}

class _ItemRespostaListPageState extends State<ItemRespostaListPage> {
  ItemRespostaListBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = ItemRespostaListBloc(
      Bootstrap.instance.firestore,
    );
    bloc.eventSink(GetItemRespostaListEvent(widget.itemId));
    bloc.eventSink(GetItemEvent(widget.itemId));
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Municípios neste item'),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamed(
            context,
            "/checklist/resposta/crud",
            arguments: ItemRespostaPageCRUDArguments(
                item: widget.itemId, resposta: null),
          );
        },
      ),
      body: StreamBuilder<ItemRespostaListBlocState>(
        stream: bloc.stateStream,
        builder: (BuildContext context,
            AsyncSnapshot<ItemRespostaListBlocState> snapshot) {
          if (snapshot.hasError) {
            return Text("Existe algo errado! Informe o suporte.");
          }
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.data.isDataValid) {
            // print('iniciando ItemRespostaListPage do IAItem: ${snapshot.data.item.id}');

            List<Widget> listaWidget = List<Widget>();
            for (var setor in snapshot.data.itemRespostaList) {
              var icone;
              if (setor.atendeTR == 'Sim') {
                icone = Icon(
                  Icons.thumb_up,
                  color: Colors.green,
                );
              } else if (setor.atendeTR == 'Não') {
                icone = Icon(
                  Icons.thumb_down,
                  color: Colors.red,
                );
              } else if (setor.atendeTR == 'Parcialmente') {
                icone = Icon(
                  Icons.thumbs_up_down,
                  color: Colors.yellow,
                );
              }
              listaWidget.add(
                Card(
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        // trailing: setor.linkDocumento != null
                        //     ? IconButton(
                        //         icon: Icon(Icons.link),
                        //         onPressed: () {
                        //           try {
                        //             launch(setor.linkDocumento);
                        //           } catch (e) {}
                        //         })
                        //     : null,
                        leading: icone,
                        title: Text('${setor.setor.nome}'),
                        subtitle: Text('${setor.comentario ?? ''}'),
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            "/checklist/resposta/crud",
                            arguments: ItemRespostaPageCRUDArguments(
                                item: widget.itemId, resposta: setor.id),
                          );
                        },
                      ),
                      Wrap(alignment: WrapAlignment.center, children: <Widget>[
                        setor.linkDocumento != null
                            ? IconButton(
                                tooltip: 'Link para documento específico',
                                icon: Icon(Icons.description),
                                onPressed: () {
                                  try {
                                    launch(setor.linkDocumento);
                                  } catch (e) {}
                                },
                              )
                            : Container(),
                        setor.setor.checklistPasta != null
                            ? IconButton(
                                tooltip: 'Link para pasta do município',
                                icon: Icon(Icons.folder),
                                onPressed: () {
                                  try {
                                    launch(setor.setor.checklistPasta);
                                  } catch (e) {}
                                },
                              )
                            : Container(),
                        setor.setor.checklistPlanilha != null
                            ? IconButton(
                                tooltip: 'Link para planilha do município',
                                icon: Icon(Icons.table_chart),
                                onPressed: () {
                                  try {
                                    launch(setor.setor.checklistPlanilha);
                                  } catch (e) {}
                                },
                              )
                            : Container(),
                      ]),
                    ],
                  ),
                ),
              );
            }
            listaWidget.add(Container(
              padding: EdgeInsets.only(top: 70),
            ));

            return Column(
              children: <Widget>[
                Expanded(
                    flex: 1,
                    child: ListTile(
                      subtitle: Text(
                          '${snapshot.data.item.indice} - ${snapshot.data.item.descricao}'),
                    )),
                Expanded(
                  flex: 10,
                  child: ListView(
                    children: listaWidget,
                  ),
                )
              ],
            );
          } else {
            return Text('Existem dados inválidos. Informe o suporte.');
          }
        },
      ),
    );
  }
}
