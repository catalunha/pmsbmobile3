import 'package:flutter/material.dart';
import 'package:pmsbmibile3/components/default_scaffold.dart';
import 'package:pmsbmibile3/bootstrap.dart';
import 'package:pmsbmibile3/pages/avaliacao/produto_list_bloc.dart';
// import 'package:pmsbmibile3/state/auth_bloc.dart';
// import 'package:pmsbmibile3/naosuportato/url_launcher.dart'
//     if (dart.library.io) 'packaimport 'package:piprof/auth_bloc.dart';

class ProdutoListPage extends StatefulWidget {
  // final AuthBloc authBloc;

  // const ProdutoListPage(this.authBloc);
  const ProdutoListPage();

  @override
  _ProdutoListPageState createState() {
    return _ProdutoListPageState();
  }
}

class _ProdutoListPageState extends State<ProdutoListPage> {
  ProdutoListBloc bloc;

  // _ProdutoListPageState(AuthBloc authBloc)
  //     : bloc = ProdutoListBloc(
  //           authBloc, Bootstrap.instance.firestore);

  @override
  void initState() {
    super.initState();
    bloc = ProdutoListBloc(
      Bootstrap.instance.firestore,
      // widget.authBloc,
    );
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultScaffold(
      title: Text('Inst. Avaliação  - Produtos'),
      // floatingActionButton: FloatingActionButton(
      //   child: Icon(Icons.add),
      //   onPressed: () {
      //     Navigator.pushNamed(
      //       context,
      //       "/produto/crud",
      //       arguments: null,
      //     );
      //   },
      // ),
      body: StreamBuilder<ProdutoListBlocState>(
        stream: bloc.stateStream,
        builder:
            (BuildContext context, AsyncSnapshot<ProdutoListBlocState> snapshot) {
          if (snapshot.hasError) {
            return Text("Existe algo errado! Informe o suporte.");
          }
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.data.isDataValid) {
            List<Widget> listaWidget = List<Widget>();
            print('iniciando produto_list_page');
            print('snapshot.data.produtoList.length: ${snapshot.data.produtoList.length}');

            for (var produto in snapshot.data.produtoList) {
              // print('listando produto: ${produto.id}');
              listaWidget.add(
                Card(
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        leading: Text('${produto.indice}'),
                        title: Text('${produto.titulo}'),
                        subtitle: Text('${produto.subtitulo}'),
                        // subtitle: Text('${produto.subtitulo}\n${produto.id}'),
                        onTap: (){
                          Navigator.pushNamed(
                                  context,
                                  "/avaliacao/item/list",
                                  arguments: produto.id,
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
