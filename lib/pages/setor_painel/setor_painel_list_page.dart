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
  final List<Tab> myTabs = <Tab>[
    // Tab(text: "*"),
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
    bloc = SetorPainelListBloc(Bootstrap.instance.firestore, widget.authBloc);
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
        child: DefaultScaffold(
          title: Text('Painel'),
          bottom: TabBar(
            tabs: myTabs,
          ),
          body: _body(context),
        ));
  }

  TabBarView _body(context) {
    return TabBarView(
      children: [
        // _tabAComites('*'),
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
    return StreamBuilder<SetorPainelListBlocState>(
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
              List<SetorPainelInfo> painelList = List<SetorPainelInfo>();
              String descricaoProdutoTab;

              if (produto == '*') {
                descricaoProdutoTab =
                    'Itens sem Destinatario, Produto ou eixo.';
                if (snapshot.data.setorPainelTreeProdutoEixo['*'] != null)
                  painelList =
                      snapshot.data.setorPainelTreeProdutoEixo['*']['*'];
                popularListaWidget(painelList, listaWidget, context);
              } else {
                descricaoProdutoTab =
                    '${snapshot.data.produtoMap[produto]?.id}. ${snapshot.data.produtoMap[produto]?.descricao}';

                if (snapshot.data.setorPainelTreeProdutoEixo[produto] != null) {
                  for (var eixo in snapshot
                      .data.setorPainelTreeProdutoEixo[produto].keys
                      .toList()) {
                    listaWidget.add(Column(children: <Widget>[
                      eixoCard(snapshot.data.eixoInfoMap[eixo])
                    ]));

                    if (snapshot.data.eixoInfoMap[eixo].expandir!=null && snapshot.data.eixoInfoMap[eixo].expandir) {
                      painelList = snapshot
                          .data.setorPainelTreeProdutoEixo[produto][eixo];
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
  // Fim tab

  Expanded _bodyAba(List<Widget> listaWidget) {
    return Expanded(
        flex: 15,
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
      flex: 2,
      child: ListTile(
        title: Text('${descricaoProdutoTab}'),
        trailing: IconButton(
          tooltip: 'Ver comparativo em planilha.',
          icon: Icon(Icons.table_chart),
          onPressed: () async {
            launch(
                'https://docs.google.com/spreadsheets/d/1lGwxBTGXd55H6QfnJ_7WKuNBJi16dC_J6PBk0QR0viA/edit#gid=0');
          },
        ),
      ),
      // child: Center(child: Text('${descricaoProdutoTab}')),
    );
  }

  void popularListaWidget(List<SetorPainelInfo> painelList,
      List<Widget> listaWidget, BuildContext context) {
    if (painelList != null) {
      for (var painelInfo in painelList) {
        Widget icone;
        icone = _defineTipoDeIconeDoItem(painelInfo.setorPainel.painelID.tipo);

        listaWidget.add(
            Column(children: <Widget>[painelCard(painelInfo, icone, context)]));
      }
    }
  }

  Card eixoCard(EixoInfo eixoInfo) {
    return Card(
        color: eixoInfo.expandir!=null && eixoInfo.expandir ? Colors.deepOrange : Colors.deepPurple,
        child: ListTile(
          // selected: true,
          trailing:
              eixoInfo.expandir!=null &&   eixoInfo.expandir ? Icon(Icons.folder_open) : Icon(Icons.folder),
          title: Text('${eixoInfo.eixo.nome}'),
          onTap: () {
            bloc.eventSink(UpdateExpandeRetraiEixoMapEvent(eixoInfo.eixo.id));
          },
        ));
  }

  Card painelCard(
      SetorPainelInfo setorPainelInfo, Widget icone, BuildContext context) {
    return Card(
        // margin: EdgeInsets.only(left: 20),
        child: ListTile(
      selected: setorPainelInfo.destacarSeDestinadoAoUsuarioLogado == null
          ? false
          : setorPainelInfo.destacarSeDestinadoAoUsuarioLogado,
      title: Text('${setorPainelInfo.setorPainel?.painelID?.nome}'),
      subtitle: Text(
          'Obs: ${setorPainelInfo?.setorPainel?.observacao}\nDestinatário: ${setorPainelInfo.setorPainel?.usuarioQVaiResponder?.nome}\nEditado por: ${setorPainelInfo.setorPainel.usuarioQEditou?.nome}\nEm: ${setorPainelInfo.setorPainel?.modificada}\nid:${setorPainelInfo.setorPainel.id}'),
      // subtitle: Text(
      //     'Obs: ${setorPainelInfo?.setorPainel?.observacao}\nDestinatário: ${setorPainelInfo.setorPainel?.usuarioQVaiResponder?.nome}\nProduto: ${setorPainelInfo.setorPainel?.produto?.nome}\nEixo: ${setorPainelInfo.setorPainel.eixo?.nome}\nEditado por: ${setorPainelInfo.setorPainel.usuarioQEditou?.nome}\nEm: ${setorPainelInfo.setorPainel?.modificada}\nid:${setorPainelInfo.setorPainel.id}'),
      trailing: setorPainelInfo?.setorPainel?.valor == null
          ? Icon(Icons.edit)
          : icone,
      onTap: () {
        Navigator.pushNamed(
          context,
          "/setor_painel/crud",
          arguments: setorPainelInfo.setorPainel.id,
        );
      },
      onLongPress:
          (setorPainelInfo?.setorPainel?.painelID?.tipo == 'urlimagem' ||
                      setorPainelInfo?.setorPainel?.painelID?.tipo ==
                          'urlarquivo') &&
                  setorPainelInfo?.setorPainel?.valor != null
              ? () {
                  launch(setorPainelInfo?.setorPainel?.valor);
                }
              : null,
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
