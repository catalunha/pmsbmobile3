import 'package:flutter/material.dart';
import 'package:pmsbmibile3/components/default_scaffold.dart';
import 'package:pmsbmibile3/bootstrap.dart';
import 'package:pmsbmibile3/pages/checklist/produto_list_bloc.dart';
import 'package:pmsbmibile3/style/pmsb_colors.dart';

class ProdutoListPage extends StatefulWidget {
  const ProdutoListPage();

  @override
  _ProdutoListPageState createState() {
    return _ProdutoListPageState();
  }
}

class _ProdutoListPageState extends State<ProdutoListPage> {
  ProdutoListBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = ProdutoListBloc(
      Bootstrap.instance.firestore,
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
      backToRootPage: true,
      title: Text('Checklist - Produtos'),
      body: StreamBuilder<ProdutoListBlocState>(
        stream: bloc.stateStream,
        builder: (BuildContext context,
            AsyncSnapshot<ProdutoListBlocState> snapshot) {
          if (snapshot.hasError) {
            return Text("Existe algo errado! Informe o suporte.");
          }
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.data.isDataValid) {
            List<Widget> listaWidget = List<Widget>();

            for (var produto in snapshot.data.produtoList) {
              listaWidget.add(
                Card(
                  color: PmsbColors.card,
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        leading: Text('${produto.indice}'),
                        title: Text('${produto.descricao}'),
                        subtitle: Text('${produto.id}'),
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            "/checklist/item/list",
                            arguments: produto.id,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
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
