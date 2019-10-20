import 'package:flutter/material.dart';
import 'package:pmsbmibile3/bootstrap.dart';
import 'package:pmsbmibile3/models/produto_funasa_model.dart';
import 'package:pmsbmibile3/pages/painel/painel_list_bloc.dart';
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
              if (produto == '*') {
                descricaoProdutoTab =
                    'Itens sem Destinatario, Produto ou eixo.';
                if (snapshot.data.painelTreeProdutoEixo['*'] != null)
                  painelList = snapshot.data.painelTreeProdutoEixo['*']['*'];
                popularListaWidget(painelList, listaWidget, context);
              } else {
                descricaoProdutoTab =
                    '${snapshot.data.produtoMap[produto]?.id}. ${snapshot.data.produtoMap[produto]?.descricao}';

                if (snapshot.data.painelTreeProdutoEixo[produto] != null) {
                  for (var eixo in snapshot
                      .data.painelTreeProdutoEixo[produto].keys
                      .toList()) {
                    listaWidget.add(Column(children: <Widget>[
                      eixoCard(snapshot.data.eixoInfoMap[eixo])
                    ]));

                    if (snapshot.data.eixoInfoMap[eixo].expandir) {
                      painelList =
                          snapshot.data.painelTreeProdutoEixo[produto][eixo];
                      popularListaWidget(painelList, listaWidget, context);
                    }
                  }
                }
              }

              listaWidget.add(Container(
                padding: EdgeInsets.only(top: 70),
              ));

              return Column(children: <Widget>[
                _descricaoAba(descricaoProdutoTab),
                _bodyAba(listaWidget)
              ]);
            } else {
              return Text('Dados inválidos...');
            }
          }
        });
  }

  Expanded _bodyAba(List<Widget> listaWidget) {
    return Expanded(
        flex: 10,
        child: listaWidget == null
            ? Container(
                child: Text('Sem itens de painel'),
              )
            : ListView(
                children: listaWidget,
              ));
  }

  Expanded _descricaoAba(String descricaoProdutoTab) {
    return Expanded(
      flex: 1,
      child: Center(child: Text('${descricaoProdutoTab}')),
    );
  }

  void popularListaWidget(List<PainelInfo> painelList, List<Widget> listaWidget,
      BuildContext context) {
    if (painelList != null) {
      for (var painelInfo in painelList) {
        Widget icone;
        icone = _defineTipoDeIconeDoItem(painelInfo.painel.tipo);

        listaWidget.add(
            Column(children: <Widget>[painelCard(painelInfo, icone, context)]));
      }
    }
  }

  Card eixoCard(EixoInfo eixoInfo) {
    return Card(
        color: eixoInfo.expandir ? Colors.deepOrange : Colors.deepPurple,
        child: ListTile(
          // selected: true,
          trailing:
              eixoInfo.expandir ? Icon(Icons.folder_open) : Icon(Icons.folder),
          title: Text('${eixoInfo.eixo.nome}'),
          onTap: () {
            bloc.eventSink(UpdateExpandeRetraiEixoMapEvent(eixoInfo.eixo.id));
          },
        ));
  }

  Card painelCard(PainelInfo painelInfo, Widget icone, BuildContext context) {
    return Card(
        // margin: EdgeInsets.only(left: 20),
        child: ListTile(
      selected: painelInfo.destacarSeDestinadoAoUsuarioLogado == null
          ? false
          : painelInfo.destacarSeDestinadoAoUsuarioLogado,
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
    ));
  }

  Widget _defineTipoDeIconeDoItem(String tipo) {
    if (tipo == 'texto') {
      return Icon(Icons.text_fields);
    } else if (tipo == 'numero') {
      return Icon(Icons.looks_one);
    } else if (tipo == 'booleano') {
      return Icon(Icons.thumbs_up_down);
    } else if (tipo == 'urlimagem') {
      return Icon(Icons.image);
    } else if (tipo == 'urlarquivo') {
      return Icon(Icons.attach_file);
    } else {
      return Text('?');
    }
  }
}
