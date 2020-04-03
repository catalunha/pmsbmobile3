import 'package:flutter/material.dart';
import 'package:pmsbmibile3/bootstrap.dart';
import 'package:pmsbmibile3/components/default_scaffold.dart';
import 'package:pmsbmibile3/pages/painel/painel_list_bloc.dart';
import 'package:pmsbmibile3/pages/painel/painel_list_element_page.dart';
import 'package:pmsbmibile3/state/auth_bloc.dart';
import 'package:pmsbmibile3/style/pmsb_colors.dart';

class PainelListPage extends StatefulWidget {
  final AuthBloc authBloc;

  PainelListPage(this.authBloc);

  _PainelListPageState createState() => _PainelListPageState();
}

class _PainelListPageState extends State<PainelListPage> {
  PainelListBloc bloc;

  final List<String> _myTabs = <String>[
    "*",
    "A",
    "B",
    "C",
    "D",
    "E",
    "F",
    "G",
    "H",
    "I",
    "J",
    "K",
  ];

  // final List<Tab> myTabs = <Tab>[
  //   Tab(text: "*"),
  //   Tab(text: "A"),
  //   Tab(text: "B"),
  //   Tab(text: "C"),
  //   Tab(text: "D"),
  //   Tab(text: "E"),
  //   Tab(text: "F"),
  //   Tab(text: "G"),
  //   Tab(text: "H"),
  //   Tab(text: "I"),
  //   Tab(text: "J"),
  //   Tab(text: "K"),
  // ];

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
      backToRootPage: true,
      title: Text("Adicionar/Editar itens do painel"),
      body: _body(context),
      floatingActionButton: FloatingActionButton(
        backgroundColor: PmsbColors.cor_destaque,
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamed(context, '/painel/crud', arguments: null);
        },
      ),
    );

    // return DefaultTabController(
    //   length: myTabs.length,
    //   child: DefaultScaffold(
    //     backToRootPage: true,
    //     title: Text('Adicionar/Editar itens do painel'),
    //     bottom: TabBar(
    //       tabs: myTabs,
    //     ),
    //     body: _body(context),
    //     floatingActionButton: FloatingActionButton(
    //       child: Icon(Icons.add),
    //       onPressed: () {
    //         Navigator.pushNamed(context, '/painel/crud', arguments: null);
    //       },
    //     ),
    //   ),
    // );
  }

  _body(context) {
    return StreamBuilder<PainelListBlocState>(
      stream: bloc.stateStream,
      builder:
          (BuildContext context, AsyncSnapshot<PainelListBlocState> snapshot) {
        List<Widget> list = List<Widget>();
        String descricaoProdutoTab;
        list.add(Divider());

        _myTabs.forEach((produto) {
          if (produto == '*') {
            descricaoProdutoTab = 'Itens sem Destinatario, Produto ou eixo.';
          } else {
            descricaoProdutoTab =
                '${snapshot.data.produtoMap[produto]?.id}. ${snapshot.data.produtoMap[produto]?.descricao}';
          }

          list.add(
            ListTile(
              trailing: Icon(Icons.arrow_forward),
              title: Text(descricaoProdutoTab),
              onTap: () {
                Navigator.of(context).push(
                  // With MaterialPageRoute, you can pass data between pages,
                  // but if you have a more complex app, you will quickly get lost.
                  MaterialPageRoute(
                    builder: (context) => PainelListElement(
                      authBloc: widget.authBloc,
                      element: produto,
                    ),
                  ),
                );
              },
            ),
          );

          list.add(Divider());
        });

        list.add(SizedBox(height: 80));

        return ListView(children: list);
      },
    );

    // return TabBarView(
    //   children: [
    //     _tabAComites('*'),
    //     _tabAComites('A'),
    //     _tabAComites('B'),
    //     _tabAComites('C'),
    //     _tabAComites('D'),
    //     _tabAComites('E'),
    //     _tabAComites('F'),
    //     _tabAComites('G'),
    //     _tabAComites('H'),
    //     _tabAComites('I'),
    //     _tabAComites('J'),
    //     _tabAComites('K'),
    //   ],
    // );
  }

  // _tabAComites(String produto) {
  //   return StreamBuilder<PainelListBlocState>(
  //       stream: bloc.stateStream,
  //       builder: (BuildContext context,
  //           AsyncSnapshot<PainelListBlocState> snapshot) {
  //         if (snapshot.hasError) {
  //           return Text("ERROR");
  //         }
  //         if (!snapshot.hasData) {
  //           return Text("SEM DADOS");
  //         }
  //         if (snapshot.hasData) {
  //           if (snapshot.data.isDataValid) {
  //             List<Widget> listaWidget = List<Widget>();
  //             List<PainelInfo> painelList = List<PainelInfo>();
  //             String descricaoProdutoTab;
  //             if (produto == '*') {
  //               descricaoProdutoTab =
  //                   'Itens sem Destinatario, Produto ou eixo.';
  //               if (snapshot.data.painelTreeProdutoEixo['*'] != null)
  //                 painelList = snapshot.data.painelTreeProdutoEixo['*']['*'];
  //               popularListaWidget(painelList, listaWidget, context);
  //             } else {
  //               descricaoProdutoTab =
  //                   '${snapshot.data.produtoMap[produto]?.id}. ${snapshot.data.produtoMap[produto]?.descricao}';
  //               if (snapshot.data.painelTreeProdutoEixo[produto] != null) {
  //                 for (var eixo in snapshot
  //                     .data.painelTreeProdutoEixo[produto].keys
  //                     .toList()) {
  //                   listaWidget.add(Column(children: <Widget>[
  //                     eixoCard(snapshot.data.eixoInfoMap[eixo])
  //                   ]));

  //                   if (snapshot.data.eixoInfoMap[eixo].expandir != null &&
  //                       snapshot.data.eixoInfoMap[eixo].expandir) {
  //                     painelList =
  //                         snapshot.data.painelTreeProdutoEixo[produto][eixo];
  //                     popularListaWidget(painelList, listaWidget, context);
  //                   }
  //                 }
  //               }
  //             }

  //             listaWidget.add(Container(
  //               padding: EdgeInsets.only(top: 70),
  //             ));

  //             return Column(children: <Widget>[
  //               _descricaoAba(descricaoProdutoTab),
  //               _bodyAba(listaWidget)
  //             ]);
  //           } else {
  //             return Text('Dados inválidos...');
  //           }
  //         }
  //         return Text('Dados incompletos...');
  //       });
  // }

  // Expanded _bodyAba(List<Widget> listaWidget) {
  //   return Expanded(
  //       flex: 10,
  //       child: listaWidget == null
  //           ? Container(
  //               child: Text('Sem itens de painel'),
  //             )
  //           : ListView(
  //               children: listaWidget,
  //             ));
  // }

  // Expanded _descricaoAba(String descricaoProdutoTab) {
  //   return Expanded(
  //     flex: 1,
  //     child: Center(child: Text('$descricaoProdutoTab')),
  //   );
  // }

  // void popularListaWidget(List<PainelInfo> painelList, List<Widget> listaWidget,
  //     BuildContext context) {
  //   if (painelList != null) {
  //     for (var painelInfo in painelList) {
  //       Widget icone;
  //       icone = _defineTipoDeIconeDoItem(painelInfo.painel.tipo);

  //       listaWidget.add(
  //           Column(children: <Widget>[painelCard(painelInfo, icone, context)]));
  //     }
  //   }
  // }

  // Card eixoCard(EixoInfo eixoInfo) {
  //   return Card(
  //       color: eixoInfo.expandir != null && eixoInfo.expandir
  //           ? Colors.deepOrange
  //           : Colors.deepPurple,
  //       child: ListTile(
  //         trailing: eixoInfo.expandir != null && eixoInfo.expandir
  //             ? Icon(Icons.folder_open)
  //             : Icon(Icons.folder),
  //         title: Text('${eixoInfo.eixo.nome}'),
  //         onTap: () {
  //           bloc.eventSink(UpdateExpandeRetraiEixoMapEvent(eixoInfo.eixo.id));
  //         },
  //       ));
  // }

  // Card painelCard(PainelInfo painelInfo, Widget icone, BuildContext context) {
  //   return Card(
  //       child: ListTile(
  //     selected: painelInfo.destacarSeDestinadoAoUsuarioLogado == null
  //         ? false
  //         : painelInfo.destacarSeDestinadoAoUsuarioLogado,
  //     title: Text('${painelInfo.painel?.nome}'),
  //     subtitle: Text(
  //         'Destinatário: ${painelInfo.painel?.usuarioQVaiResponder?.nome}\nProduto: ${painelInfo.painel?.produto?.nome}\nEixo: ${painelInfo.painel?.eixo?.nome}\nEditado por: ${painelInfo.painel?.usuarioQEditou?.nome}\nEm: ${painelInfo.painel?.modificado}\nid:${painelInfo.painel.id}'),
  //     trailing: icone,
  //     onTap: () {
  //       Navigator.pushNamed(
  //         context,
  //         "/painel/crud",
  //         arguments: painelInfo.painel.id,
  //       );
  //     },
  //   ));
  // }

  // Widget _defineTipoDeIconeDoItem(String tipo) {
  //   if (tipo == 'texto') {
  //     return Icon(Icons.text_fields);
  //   } else if (tipo == 'numero') {
  //     return Icon(Icons.looks_one);
  //   } else if (tipo == 'booleano') {
  //     return Icon(Icons.thumbs_up_down);
  //   } else if (tipo == 'urlimagem') {
  //     return Icon(Icons.image);
  //   } else if (tipo == 'urlarquivo') {
  //     return Icon(Icons.attach_file);
  //   } else {
  //     return Text('?');
  //   }
  // }
}
