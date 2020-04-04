import 'package:flutter/material.dart';
import 'package:pmsbmibile3/bootstrap.dart';
import 'package:pmsbmibile3/pages/checklist/item_list_bloc.dart';

class ItemListPage extends StatefulWidget {
  final String produtoId;

  const ItemListPage(this.produtoId);

  @override
  _ItemListPageState createState() {
    return _ItemListPageState();
  }
}

class _ItemListPageState extends State<ItemListPage> {
  ItemListBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = ItemListBloc(
      Bootstrap.instance.firestore,
    );
    bloc.eventSink(GetItemListEvent(widget.produtoId));
    bloc.eventSink(GetProdutoEvent(widget.produtoId));
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
        title: Text('Itens deste produto'),
      ),

      body: StreamBuilder<ItemListBlocState>(
        stream: bloc.stateStream,
        builder:
            (BuildContext context, AsyncSnapshot<ItemListBlocState> snapshot) {
          if (snapshot.hasError) {
            return Text("Existe algo errado! Informe o suporte.");
          }
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.data.isDataValid) {
            List<Widget> listaWidget = List<Widget>();
            // print('iniciando item_list_page do IAProduto: ${snapshot.data.produto.id}');
            for (var item in snapshot.data.itemList) {
              // print('listando item: ${item.id}');
              listaWidget.add(
                Card(
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        leading: Text('${item.indice}'),
                        title: Text('${item.descricao}'),
                        subtitle: Text('${item.id}'),
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            "/checklist/resposta/list",
                            arguments: item.id,
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
            return Column(
              children: <Widget>[
                Expanded(
                    flex: 1,
                    child: ListTile(
                      title: Text(
                          '${snapshot.data.produto.indice} - ${snapshot.data.produto.descricao}'),
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
