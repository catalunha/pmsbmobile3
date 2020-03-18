import 'package:flutter/material.dart';
import 'package:pmsbmibile3/bootstrap.dart';
import 'package:pmsbmibile3/pages/avaliacao/item_resposta_list_bloc.dart';
import 'package:pmsbmibile3/pages/page_arguments.dart';
// import 'package:pmsbmibile3/state/auth_bloc.dart';
// import 'package:pmsbmibile3/naosuportato/url_launcher.dart'
//     if (dart.library.io) 'packaimport 'package:piprof/auth_bloc.dart';

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
        title: Text('Setores deste item'),
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
            List<Widget> listaWidget = List<Widget>();

            // int lengthTurma = snapshot.data.produtoList.length;

            // int ordemLocal = 1;
            for (var setor in snapshot.data.itemRespostaList) {
              print('listando setor: ${setor.id}');
              listaWidget.add(
                Card(
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        // leading: Text('${setor.indice}'),
                        title: Text('${setor.setor.nome}'),
                        subtitle: Text('${setor.id}'),
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            "/avaliacao/resposta/crud",
                            arguments: ItemRespostaPageCRUDArguments(
                                item: widget.itemId, resposta: setor.id),
                          );
                        },
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

            return ListView(
              children: listaWidget,
            );
          } else {
            return Text('Existem dados inválidos. Informe o suporte.');
          }
        },
      ),
    );
  }
}
