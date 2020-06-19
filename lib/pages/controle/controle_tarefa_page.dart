import 'package:flutter/material.dart';
import 'package:pmsbmibile3/components/default_scaffold.dart';
import 'package:pmsbmibile3/models/models_controle/tarefa_model.dart';
import 'package:pmsbmibile3/pages/controle/controle_feed_page.dart';
import 'package:pmsbmibile3/style/pmsb_colors.dart';
import 'package:pmsbmibile3/widgets/equipe_wrap_widget.dart';
import 'package:pmsbmibile3/widgets/etiqueta_wrap_widget.dart';

class ControleTarefaPage extends StatefulWidget {
  final TarefaModel tarefa;
  ControleTarefaPage({Key key, @required this.tarefa}) : super(key: key);


  @override
  _ControleTarefaPageState createState() => _ControleTarefaPageState();
}

class _ControleTarefaPageState extends State<ControleTarefaPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultScaffold(
      backgroundColor: PmsbColors.navbar,
      backToRootPage: false,
      title: Text("${widget.tarefa.tituloAtividade}"),
      body: body(),
    );
  }

  Widget body() {
    double width = MediaQuery.of(context).size.width;
    return Center(
      child: Container(
        width: width * 0.7,
        color: Colors.black12,
        child: Column(
          children: <Widget>[
            _descricao(),
            Expanded(
              flex: 10,
              child: _painel(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _descricao() {
    return Container(
      child: Column(
        children: <Widget>[
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              RaisedButton.icon(
                color: Colors.transparent,
                onPressed: () {
                  print("teste");
                },
                icon: Icon(Icons.edit),
                label: Text("Editar"),
                elevation: 0,
                disabledElevation: 0,
                disabledColor: Colors.transparent,
                focusColor: Colors.transparent,
              ),
              SizedBox(
                width: 5,
              )
            ],
          ),
          SizedBox(height: 10),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.05,
            ),
            child: Text(
              "${widget.tarefa.descricaoAtividade}",
              style: TextStyle(color: PmsbColors.texto_terciario, fontSize: 14),
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _painel() {
    return Container(
      color: Colors.black12,
      child: Row(
        children: <Widget>[
          Flexible(child: _colunaOpcoes(), flex: 2),
          Flexible(child: ControleFeedPage(tarefa: widget.tarefa,), flex: 8),
        ],
      ),
    );
  }

  Widget _colunaOpcoes() {
    return Container(
      color: Colors.black12,
      child: ListView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(5),
            child: EquipeWrapWidget(),
          ),
          SizedBox(height: 10),
          Padding(
            padding: EdgeInsets.all(5) ,
            child: EtiquetaWrapWidget(etiquetas:widget.tarefa.etiquetas),
          ),
        ],
      ),
    );
  }
}
