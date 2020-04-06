import 'package:flutter/material.dart';
import 'package:pmsbmibile3/bootstrap.dart';
import 'package:pmsbmibile3/components/default_scaffold.dart';
// import 'package:pmsbmibile3/pages/painel/painel_list_bloc.dart';
import 'package:pmsbmibile3/pages/setor_painel/setor_painel_list_bloc.dart';
import 'package:pmsbmibile3/state/auth_bloc.dart';
import 'package:pmsbmibile3/style/pmsb_colors.dart';
import 'package:pmsbmibile3/style/pmsb_styles.dart';

class SetorPainelListElement extends StatefulWidget {
  final AuthBloc authBloc;
  final String element;

  const SetorPainelListElement(
      {Key key, @required this.authBloc, @required this.element})
      : super(key: key);

  @override
  _SetorPainelListElementState createState() => _SetorPainelListElementState();
}

class _SetorPainelListElementState extends State<SetorPainelListElement> {
  SetorPainelListBloc bloc;

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
    return DefaultScaffold(
      title: Text("Itens do Painel"),
      backToRootPage: false,
      body: _body(),
    );
  }

  _body() {
    return Container(
      child: _tabAComites(widget.element),
    );
  }

  _tabAComites(String produto) {
    return StreamBuilder<SetorPainelListBlocState>(
        stream: bloc.stateStream,
        builder: (BuildContext context, AsyncSnapshot<SetorPainelListBlocState> snapshot) {
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
                descricaoProdutoTab = 'Itens sem Destinatario, Produto ou eixo.';
                if (snapshot.data.setorPainelTreeProdutoEixo['*'] != null)
                  painelList = snapshot.data.setorPainelTreeProdutoEixo['*']['*'];;
                  popularListaWidget(painelList, listaWidget, context);
              } else {
                descricaoProdutoTab = '${snapshot.data.produtoMap[produto]?.id}. ${snapshot.data.produtoMap[produto]?.descricao}';
                if (snapshot.data.setorPainelTreeProdutoEixo[produto] != null) {
                  for (var eixo in snapshot.data.setorPainelTreeProdutoEixo[produto].keys.toList()) {
                    listaWidget.add(
                      Column(
                        children: <Widget>[
                          eixoCard(snapshot.data.eixoInfoMap[eixo])
                        ],
                      ),
                    );

                    if (snapshot.data.eixoInfoMap[eixo].expandir != null && snapshot.data.eixoInfoMap[eixo].expandir) {
                      painelList = snapshot.data.setorPainelTreeProdutoEixo[produto][eixo];
                      popularListaWidget(painelList, listaWidget, context);
                    }
                  }
                }
              }

              listaWidget.add(
                Container(
                  padding: EdgeInsets.only(top: 70),
                ),
              );

              return Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: _descricaoAba(descricaoProdutoTab),
                  ),
                  _bodyAba(listaWidget)
                ],
              );
            } else {
              return Text('Dados inválidos...');
            }
          }
          return Text('Dados incompletos...');
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
            ),
    );
  }

  _descricaoAba(String descricaoProdutoTab) {
    return Text('$descricaoProdutoTab');

    // return Expanded(
    //   flex: 1,
    //   child: Center(child: Text('$descricaoProdutoTab')),
    // );
  }

  void popularListaWidget(List<SetorPainelInfo> painelList, List<Widget> listaWidget,
      BuildContext context) {
    if (painelList != null) {
      for (var painelInfo in painelList) {
        Widget icone;
        icone = _defineTipoDeIconeDoItem(painelInfo.setorPainel.painelID.tipo);

        listaWidget.add(
          Column(
            children: <Widget>[
              painelCard(painelInfo, icone, context),
            ],
          ),
        );
      }
    }
  }

  Card eixoCard(EixoInfo eixoInfo) {
    return Card(
        color: eixoInfo.expandir != null && eixoInfo.expandir
            ? Colors.deepOrange
            : Colors.deepPurple,
        child: ListTile(
          trailing: eixoInfo.expandir != null && eixoInfo.expandir
              ? Icon(Icons.folder_open)
              : Icon(Icons.folder),
          title: Text('${eixoInfo.eixo.nome}'),
          onTap: () {
           bloc.eventSink(UpdateExpandeRetraiEixoMapEvent(eixoInfo.eixo.id));
          },
        ));
  }

  Card painelCard(SetorPainelInfo setorPainelInfo, Widget icone, BuildContext context) {
    return Card(
      color: PmsbColors.card,
      child: ListTile(
        selected: setorPainelInfo.destacarSeDestinadoAoUsuarioLogado == null
            ? false
            : setorPainelInfo.destacarSeDestinadoAoUsuarioLogado,
        title: Text('${setorPainelInfo.setorPainel?.painelID?.nome}',
          style: PmsbStyles.textoPrimario,
        ),
        subtitle: Text('Obs: ${setorPainelInfo?.setorPainel?.observacao}\nDestinatário: ${setorPainelInfo.setorPainel?.usuarioQVaiResponder?.nome}\nEditado por: ${setorPainelInfo.setorPainel.usuarioQEditou?.nome}\nEm: ${setorPainelInfo.setorPainel?.modificada}\nid:${setorPainelInfo.setorPainel.id}'),
        trailing: icone,
        onTap: () {
          Navigator.pushNamed(
            context,
            "/setor_painel/crud",
            arguments: setorPainelInfo.setorPainel.id,
          );
        },
      ),
    );
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
