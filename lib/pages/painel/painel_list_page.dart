import 'package:flutter/material.dart';
import 'package:pmsbmibile3/bootstrap.dart';
import 'package:pmsbmibile3/models/painel_model.dart';
import 'package:pmsbmibile3/models/produto_funasa_model.dart';
import 'package:pmsbmibile3/pages/painel/painel_list_bloc.dart';
import 'package:pmsbmibile3/naosuportato/url_launcher.dart'
    if (dart.library.io) 'package:url_launcher/url_launcher.dart';
import 'package:pmsbmibile3/state/auth_bloc.dart';

class PainelListPage extends StatefulWidget {
  final AuthBloc authBloc;

  PainelListPage(this.authBloc);

  _PainelListPageState createState() => _PainelListPageState();
}

class _PainelListPageState extends State<PainelListPage> {
  PainelListBloc bloc;

  final List<Tab> myTabs = <Tab>[
    Tab(text: "*"),
    Tab(text: "A"),
    Tab(text: "B"),
    Tab(text: "C"),
    Tab(text: "D"),
    Tab(text: "E"),
    Tab(text: "F"),
    Tab(text: "G"),
    Tab(text: "H"),
    Tab(text: "I"),
    Tab(text: "J"),
    Tab(text: "K"),
  ];
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
    return DefaultTabController(
      length: myTabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Adicionar/Editar itens do painel'),
          bottom: TabBar(
            tabs: myTabs,
          ),
        ),
        body: _body(context),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.pushNamed(context, '/painel/crud', arguments: null);
          },
          // backgroundColor: Colors.blue,
        ),
      ),
    );
  }

  TabBarView _body(context) {
    return TabBarView(
      children: [
        _tabAComites('*'),
        _tabAComites('A'),
        _tabAComites('B'),
        _tabAComites('C'),
        _tabAComites('D'),
        _tabAComites('E'),
        _tabAComites('F'),
        _tabAComites('G'),
        _tabAComites('H'),
        _tabAComites('I'),
        _tabAComites('J'),
        _tabAComites('K'),
      ],
    );
  }

  _tabAComites(String produto) {
    return StreamBuilder<PainelListBlocState>(
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
              List<PainelInfo> painelList = List<PainelInfo>();
              String descricaoProdutoTab;
              Map<String, List<PainelInfo>> painelEixo =
                  Map<String, List<PainelInfo>>();
              ProdutoFunasaModel produtoFunasa =
                  snapshot.data.produtoMap[produto];

              descricaoProdutoTab =
                  '${produtoFunasa?.id}. ${produtoFunasa?.descricao}';
              if (produto == '*') {
                descricaoProdutoTab = 'Itens sem Destinatario, Produto ou eixo.';

                painelList.addAll(snapshot.data.paneilSemDPE['*']);
                // print('paneilSemDPE: ${snapshot.data.paneilSemDPE}');
                // print('painelList: ${painelList}');
                if (painelList != null) {
                  for (var painelInfo in painelList) {
                    Widget icone;
                    if (painelInfo.painel.tipo == 'texto') {
                      icone = Icon(Icons.text_fields);
                    } else if (painelInfo.painel.tipo == 'numero') {
                      icone = Icon(Icons.looks_one);
                    } else if (painelInfo.painel.tipo == 'booleano') {
                      icone = Icon(Icons.thumbs_up_down);
                    } else if (painelInfo.painel.tipo == 'urlimagem') {
                      icone = Icon(Icons.image);
                    } else if (painelInfo.painel.tipo == 'urlarquivo') {
                      icone = Icon(Icons.attach_file);
                    }

                    listaWidget.add(Column(children: <Widget>[
                      Card(
                          // margin: EdgeInsets.only(left: 20),
                          child: ListTile(
                        selected: painelInfo.destacar == null
                            ? false
                            : painelInfo.destacar,
                        title: Text('${painelInfo.painel?.nome}'),
                        subtitle: Text(
                            'Destinatário: ${painelInfo.painel?.usuarioQVaiResponder?.nome}\nProduto: ${painelInfo.painel?.produto?.nome}\nEixo: ${painelInfo.painel?.eixo?.nome}\nEditado por: ${painelInfo.painel?.usuarioQEditou?.nome}\nEm: ${painelInfo.painel?.modificado}\nid:${painelInfo.painel.id}'),
                        trailing: icone,
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            "/painel/crud",
                            arguments: painelInfo.painel.id,
                          );
                        },
                      ))
                    ]));
                  }
                }
              } else {
                if (snapshot.data.painelPorProdutoEixo[produto] != null) {
                  // painelList = snapshot.data.painelMapList[produto];

                  painelEixo = snapshot.data.painelPorProdutoEixo[produto];

                  for (var eixo in painelEixo.entries) {
                    // print(
                    //     'eixo.key: ${snapshot.data.eixoMap[eixo.key].eixo.nome}-${snapshot.data.eixoMap[eixo.key].expandir}');
                    listaWidget.add(Column(children: <Widget>[
                      Card(
                          color: snapshot.data.eixoMap[eixo.key].expandir
                              ? Colors.deepOrange
                              : Colors.deepPurple,
                          child: ListTile(
                            // selected: true,
                            trailing: snapshot.data.eixoMap[eixo.key].expandir
                                ? Icon(Icons.folder_open)
                                : Icon(Icons.folder),
                            title: Text(
                                '${snapshot.data.eixoMap[eixo.key].eixo.nome}'),
                            onTap: () {
                              bloc.eventSink(
                                  UpdateExpandeRetraiEixoMapEvent(eixo.key));
                            },
                          ))
                    ]));

                    if (snapshot.data.eixoMap[eixo.key].expandir) {
                      painelList = [];

                      painelList =
                          snapshot.data.painelPorProdutoEixo[produto][eixo.key];

                      // print('painelEixo: ${painelEixo[eixo.key]}');
                      // print('painelList: ${painelList}');

                      if (painelList != null) {
                        for (var painelInfo in painelList) {
                          Widget icone;
                          if (painelInfo.painel.tipo == 'texto') {
                            icone = Icon(Icons.text_fields);
                          } else if (painelInfo.painel.tipo == 'numero') {
                            icone = Icon(Icons.looks_one);
                          } else if (painelInfo.painel.tipo == 'booleano') {
                            icone = Icon(Icons.thumbs_up_down);
                          } else if (painelInfo.painel.tipo == 'urlimagem') {
                            icone = Icon(Icons.image);
                          } else if (painelInfo.painel.tipo == 'urlarquivo') {
                            icone = Icon(Icons.attach_file);
                          }

                          listaWidget.add(Column(children: <Widget>[
                            Card(
                                margin: EdgeInsets.only(left: 20),
                                child: ListTile(
                                  selected: painelInfo.destacar == null
                                      ? false
                                      : painelInfo.destacar,
                                  title: Text('${painelInfo.painel?.nome}'),
                                  subtitle: Text(
                                      'Destinatário: ${painelInfo.painel?.usuarioQVaiResponder?.nome}\nProduto: ${painelInfo.painel?.produto?.nome}\nEixo: ${painelInfo.painel?.eixo?.nome}\nEditado por: ${painelInfo.painel?.usuarioQEditou?.nome}\nEm: ${painelInfo.painel?.modificado}\nid:${painelInfo.painel.id}'),
                                  trailing: icone,
                                  onTap: () {
                                    Navigator.pushNamed(
                                      context,
                                      "/painel/crud",
                                      arguments: painelInfo.painel.id,
                                    );
                                  },
                                ))
                          ]));
                        }
                      }
                    }
                  }
                }
              }
              // if (painelList != null) {
              listaWidget.add(Container(
                padding: EdgeInsets.only(top: 70),
              ));
              // return ListView(
              //   children: listaWidget,
              // );
              return Column(children: <Widget>[
                Expanded(
                  flex: 1, child: Center(child: Text('${descricaoProdutoTab}')),
                  // child: ListTile(
                  //   trailing: Text('${produto}'),
                  //   title: Text('${descricaoProdutoTab}'),
                  // ),
                ),
                Expanded(
                  flex: 10,
                  child: listaWidget != null
                      ? ListView(
                          children: listaWidget,
                        )
                      : Container(),
                )
              ]);
              // }
              //  else {
              //   return Text('Nenhum item para este produto...');
              // }
            } else {
              return Text('Dados inválidos...');
            }
          }
        });
  }


}
