import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pmsbmibile3/components/default_scaffold.dart';
import 'package:pmsbmibile3/models/models_controle/tarefa_model.dart';
import 'package:pmsbmibile3/pages/controle/controle_feed_page.dart';
import 'package:pmsbmibile3/style/pmsb_colors.dart';
import 'package:pmsbmibile3/widgets/acao_list_widget.dart';
import 'package:pmsbmibile3/widgets/criar_editar_tarefa_widget.dart';
import 'package:pmsbmibile3/widgets/equipe_wrap_widget.dart';
import 'package:pmsbmibile3/widgets/etiqueta_wrap_widget.dart';

class ControleTarefaPage extends StatefulWidget {
  final TarefaModel tarefa;
  ControleTarefaPage({Key key, @required this.tarefa}) : super(key: key);

  @override
  _ControleTarefaPageState createState() => _ControleTarefaPageState();
}

class _ControleTarefaPageState extends State<ControleTarefaPage> {
  ScrollController scrowllController = new ScrollController();

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
    double widthPage = width > 1800 ? (width * 0.8) : (width * 0.95);

    return Scrollbar(
      controller: scrowllController,
      isAlwaysShown: true,
      child: Center(
        child: Container(
          width: widthPage,
          color: Colors.black12,
          child: ListView(
            children: <Widget>[
              _descricao(),
              _painel(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _descricao() {
    double width = MediaQuery.of(context).size.width;
    double widthPage = width > 1800 ? (width * 0.7) : (width * 0.6);

    return Container(
      color: Colors.black12,
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Flexible(
                flex: 8,
                child: Padding(
                  padding: EdgeInsets.all(5),
                  child: Container(
                    width: widthPage,
                    child: Text(
                      "${widget.tarefa.descricaoAtividade}",
                      style: TextStyle(
                        color: PmsbColors.texto_terciario,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ),
              Flexible(
                flex: 3,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(width: 3),
                    RaisedButton.icon(
                      color: Colors.transparent,
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) =>
                                CriarEditarTarefaWidget(
                                   editar: true,
                                ));
                      },
                      icon: Icon(Icons.edit),
                      label: Text("Editar"),
                      elevation: 0,
                      disabledElevation: 0,
                      disabledColor: Colors.transparent,
                      focusColor: Colors.transparent,
                    ),
                    SizedBox(width: 3),
                    RaisedButton.icon(
                      color: Colors.transparent,
                      onPressed: () {
                        print("teste");
                      },
                      icon: Icon(Icons.archive),
                      label: Text("Arquivar"),
                      elevation: 0,
                      disabledElevation: 0,
                      disabledColor: Colors.transparent,
                      focusColor: Colors.transparent,
                    ),
                    SizedBox(width: 3),
                  ],
                ),
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 3,
              ),
              Expanded(
                child: Container(
                  height: 115,
                  // color: Color(0xFF77869c),
                  child: Padding(
                    padding: EdgeInsets.only(top: 2),
                    child: EquipeWrapWidget(),
                  ),
                ),
              ),
              SizedBox(
                width: 3,
              ),
              Expanded(
                child: Container(
                  height: 115,
                  // color: Color(0xFF77869c),
                  child: Padding(
                    padding: EdgeInsets.only(top: 2),
                    child:
                        EtiquetaWrapWidget(etiquetas: widget.tarefa.etiquetas),
                  ),
                ),
              ),
              SizedBox(
                width: 3,
              ),
            ],
          ),
          //SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _painel() {
    return Container(
      // color: Colors.red,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Flexible(
              child: ControleFeedPage(
                tarefa: widget.tarefa,
              ),
              flex: 7),
          SizedBox(
            width: 1,
          ),
          Flexible(child: _colunaOpcoes(), flex: 3),
        ],
      ),
    );
  }

  Widget _colunaOpcoes() {
    return Container(
      child: Column(
        children: <Widget>[
          SizedBox(height: 10),
          // Container(
          //   color: Color(0xFF77869c),
          //   child: Padding(
          //     padding: EdgeInsets.all(5),
          //     child: EquipeWrapWidget(),
          //   ),
          // ),
          // SizedBox(height: 10),
          Container(
            color: Color(0xFF77869c),
            child: Padding(
              padding: EdgeInsets.only(top: 2),
              child: AcaoListWidget(acoes: widget.tarefa.acoes),
            ),
          ),
          SizedBox(height: 10),
          // Container(
          //   color: Color(0xFF77869c),
          //   child: Padding(
          //     padding: EdgeInsets.all(5),
          //     child: EtiquetaWrapWidget(etiquetas: widget.tarefa.etiquetas),
          //   ),
          // ),
        ],
      ),
    );
  }
}
