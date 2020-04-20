import 'package:flutter/material.dart';
import 'package:pmsbmibile3/bootstrap.dart';
import 'package:pmsbmibile3/pages/avaliacao/item_resposta_list_bloc.dart';
import 'package:pmsbmibile3/pages/page_arguments.dart';
// import 'package:pmsbmibile3/state/auth_bloc.dart';
// import 'package:pmsbmibile3/naosuportato/url_launcher.dart'
//     if (dart.library.io) 'packaimport 'package:piprof/auth_bloc.dart';
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

  // _ItemRespostaListPageState(AuthBloc authBloc)
  //     : bloc = ItemRespostaListBloc(
  //           authBloc, Bootstrap.instance.firestore);

  @override
  void initState() {
    super.initState();
    bloc = ItemRespostaListBloc(
      Bootstrap.instance.firestore,
      // widget.authBloc,
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
            "/avaliacao/resposta/crud",
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
                        print('iniciando ItemRespostaListPage do IAItem: ${snapshot.data.item.id}');

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
                        // trailing: setor.documento != null
                        //     ? Icon(
                        //         Icons.link,
                        //         // color: Colors.yellow,
                        //       )
                        //     : null,
                        trailing: setor.documento != null
                            ? IconButton(
                                icon: Icon(Icons.link),
                                onPressed: () {
                                  try {
                                    launch(setor.documento);
                                  } catch (e) {}
                                })
                            : null,
                        leading: icone,
                        title: Text('${setor.setor.nome}'),
                        // subtitle: Text('${setor.id} | ${setor.atendeTR}'),
                        subtitle: Text('${setor.descricao??''}'),
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            "/avaliacao/resposta/crud",
                            arguments: ItemRespostaPageCRUDArguments(
                                item: widget.itemId, resposta: setor.id),
                          );
                        },
                        // onLongPress: setor.documento != null
                        //     ? () {
                        //         try {
                        //           launch(setor.documento);
                        //         } catch (e) {}
                        //       }
                        //     : null,
                      ),
                      // Center(
                      //   child: Wrap(
                      //     children: <Widget>[
                      //       // IconButton(
                      //       //   tooltip: 'Descer ordem da turma',
                      //       //   icon: Icon(Icons.arrow_downward),
                      //       //   onPressed: (ordemLocal) < lengthTurma
                      //       //       ? () {
                      //       //           bloc.eventSink(
                      //       //               OrdenarEvent(produto, false));
                      //       //         }
                      //       //       : null,
                      //       // ),
                      //       // IconButton(
                      //       //   tooltip: 'Subir ordem da turma',
                      //       //   icon: Icon(Icons.arrow_upward),
                      //       //   onPressed: ordemLocal > 1
                      //       //       ? () {
                      //       //           bloc.eventSink(
                      //       //               OrdenarEvent(produto, true));
                      //       //         }
                      //       //       : null,
                      //       // ),
                      //       IconButton(
                      //         tooltip: 'Ver itens deste produto',
                      //         icon: Icon(Icons.edit),
                      //         onPressed: () {
                      //           Navigator.pushNamed(
                      //             context,
                      //             "/produto/crud",
                      //             arguments: produto.id,
                      //           );
                      //         },
                      //       ),
                      //     ],
                      //   ),
                      // ),
                    ],
                  ),
                ),
              );
              // ordemLocal++;
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
